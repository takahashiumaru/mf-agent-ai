import { spawn } from 'node:child_process';
import path from 'node:path';

/**
 * Runs CLI agent (Codex CLI or AGY CLI) and streams stdout
 * @param {string} prompt 
 * @param {Object} options 
 * @returns {AsyncGenerator<{type: 'chunk' | 'error', text: string}>}
 */
export async function* runCliAgentStream(prompt, options = {}) {
  const model = options.model || process.env.AGENT_MODEL || 'codex-luna-6-low';
  
  // Explicit check: gemini models always go to AGY CLI, codex/luna/sol/gpt go to Codex CLI
  const isAgy = model.startsWith('gemini-') || model.startsWith('claude-') || options.cli === 'agy';
  const isCodex = !isAgy && (options.cli === 'codex' || model.includes('luna') || model.includes('sol') || model.startsWith('gpt-') || model.startsWith('codex-'));

  const cliBinary = isCodex ? 'codex' : 'agy';
  const workspaceDir = options.cwd || path.resolve(process.cwd());
  let args = [];
  if (isCodex) {
    // Map friendly model names to codex model identifiers
    let codexModel = model;
    let effort = 'low';
    if (model === 'codex-luna-6-low' || model === 'luna-6-low' || model === 'gpt-6-luna') {
      codexModel = 'gpt-6-luna';
      effort = 'low';
    } else if (model === 'codex-sol-6.1-low' || model === 'sol-6.1-low' || model === 'gpt-6.1-sol') {
      codexModel = 'gpt-6.1-sol';
      effort = 'low';
    }

    args = [
      'exec',
      '--json',
      '-m', codexModel,
      '-c', `model_reasoning_effort="${effort}"`,
      '--dangerously-bypass-approvals-and-sandbox',
      '--skip-git-repo-check',
      '-C', workspaceDir,
      prompt
    ];
  } else {
    args = [
      '-p', prompt,
      '--dangerously-skip-permissions',
      '--add-dir', workspaceDir
    ];
    if (model) {
      args.push('--model', model);
    }
  }

  console.log(`[CLI Agent] Spawning: ${cliBinary} ${args.join(' ')}`);

  const child = spawn(cliBinary, args, {
    cwd: workspaceDir,
    env: { ...process.env, PATH: process.env.PATH },
    stdio: ['ignore', 'pipe', 'pipe']
  });

  let spawnError = null;

  child.on('error', (err) => {
    spawnError = err;
    console.warn(`[CLI Agent] Spawn error (${cliBinary}):`, err.message);
  });

  if (options.signal) {
    options.signal.addEventListener('abort', () => {
      try {
        child.kill('SIGTERM');
      } catch (e) {}
    });
  }

  let stderrOutput = '';

  if (child.stderr) {
    child.stderr.on('data', (data) => {
      const str = data.toString();
      stderrOutput += str;
      // Suppress non-fatal background model-list refresh timeouts and stdin prompts
      if (
        !str.includes('failed to refresh available models') &&
        !str.includes('Reading additional input from stdin')
      ) {
        console.warn(`[CLI Agent Stderr]:`, str);
      }
    });
  }

  const stdout = child.stdout;
  let buffer = '';

  if (stdout) {
    if (isCodex) {
      // Process JSONL events from codex exec --json
      for await (const chunk of stdout) {
        buffer += chunk.toString();
        const lines = buffer.split('\n');
        buffer = lines.pop() || '';

        for (const line of lines) {
          const trimmed = line.trim();
          if (!trimmed) continue;
          try {
            const event = JSON.parse(trimmed);
            if (event.type === 'item.completed' && event.item) {
              if (event.item.type === 'agent_message' && event.item.text) {
                yield { type: 'chunk', text: event.item.text };
              }
            } else if (event.type === 'error' && event.message) {
              console.warn('[Codex Event Error]:', event.message);
            }
          } catch (e) {
            // If non-JSON chunk, pass raw text if meaningful
          }
        }
      }
    } else {
      for await (const chunk of stdout) {
        const text = chunk.toString();
        yield { type: 'chunk', text };
      }
    }
  }

  const exitCode = await new Promise((resolve) => {
    if (spawnError) {
      return resolve(-1);
    }
    child.on('close', resolve);
    child.on('error', () => resolve(-1));
  });

  if (spawnError) {
    throw new Error(`CLI binary '${cliBinary}' tidak dapat dijalankan: ${spawnError.message}`);
  }

  if (exitCode !== 0) {
    const cleanError = stderrOutput.trim() || `CLI exited with code ${exitCode}`;
    throw new Error(cleanError);
  }
}
