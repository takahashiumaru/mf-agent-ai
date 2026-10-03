import 'dotenv/config';
import fs from 'node:fs';
import path from 'node:path';

let envFallbackParsed = null;

function getEnvFallback(key) {
  if (process.env[key]) return process.env[key];
  if (!envFallbackParsed) {
    envFallbackParsed = {};
    try {
      const envPath = path.resolve(process.cwd(), '.env');
      if (fs.existsSync(envPath)) {
        const content = fs.readFileSync(envPath, 'utf8');
        for (const rawLine of content.split('\n')) {
          const line = rawLine.trim();
          if (!line) continue;
          // Support lines with or without leading '#' if they contain key=value
          const match = line.match(/^(?:#\s*)?([A-Za-z0-9_]+)=(.*)$/);
          if (match) {
            const k = match[1].trim();
            const v = match[2].trim().replace(/^['"](.*)['"]$/, '$1');
            if (!envFallbackParsed[k] || !rawLine.startsWith('#')) {
              envFallbackParsed[k] = v;
            }
          }
        }
      }
    } catch (e) {
      console.warn('Fallback env parse warning:', e.message);
    }
  }
  return envFallbackParsed[key] || '';
}

export function normalizeModelForApi(rawModel) {
  if (!rawModel) return 'combo-9router';
  
  const m = String(rawModel).trim();

  // Already prefixed or default combo
  if (m.startsWith('ag/') || m.startsWith('cx/') || m === 'combo-9router') {
    return m;
  }

  // Codex / OpenAI models on 9router
  if (m === 'codex-luna-6-low' || m === 'luna-6-low' || m === 'gpt-6-luna' || m === 'luna') {
    return 'cx/gpt-6-luna';
  }
  if (m === 'codex-sol-6.1-low' || m === 'sol-6.1-low' || m === 'gpt-6.1-sol' || m === 'sol') {
    return 'cx/gpt-6.1-sol';
  }
  if (m.startsWith('gpt-') || m.startsWith('codex-')) {
    const clean = m.replace(/^codex-/, '');
    return `cx/${clean}`;
  }

  // Gemini / Claude models on 9router
  if (m.startsWith('gemini-') || m.startsWith('claude-')) {
    return `ag/${m}`;
  }

  return 'combo-9router';
}

export function getLLMConfig() {
  const api = process.env.LLM_API || getEnvFallback('LLM_API') || 'https://9router.takahashiumaru.web.id/v1/chat/completions';
  const token = process.env.LLM_TOKEN || getEnvFallback('LLM_TOKEN') || 'sk-f053a22d0367387b-nn7ld6-63cc27ad';
  const model = normalizeModelForApi(process.env.LLM_MODEL || getEnvFallback('LLM_MODEL') || 'combo-9router');
  return { api, token, model };
}

/**
 * Streams chat completions from OpenAI-compatible LLM
 * @param {Array<{role: string, content: string}>} messages 
 * @param {Object} options 
 * @returns {AsyncGenerator<string>}
 */
export async function* streamChatCompletions(messages, options = {}) {
  const { api, token, model } = getLLMConfig();
  const selectedModel = normalizeModelForApi(options.model || model);

  const payload = {
    model: selectedModel,
    messages,
    stream: true,
    temperature: options.temperature !== undefined ? options.temperature : 0.4,
    max_tokens: options.max_tokens || 4096
  };

  const headers = {
    'Content-Type': 'application/json'
  };
  if (token) {
    headers['Authorization'] = token.startsWith('Bearer ') ? token : `Bearer ${token}`;
  }

  console.log(`[LLM API] Requesting stream completions from 9Router (Model: ${selectedModel}, Messages: ${messages.length})`);

  const res = await fetch(api, {
    method: 'POST',
    headers,
    body: JSON.stringify(payload),
    signal: options.signal
  });

  if (!res.ok) {
    const errText = await res.text();
    throw new Error(`LLM API returned ${res.status}: ${errText}`);
  }

  const reader = res.body.getReader();
  const decoder = new TextDecoder('utf-8');
  let buffer = '';
  let chunkCount = 0;

  try {
    while (true) {
      const { value, done } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() || ''; // Keep the last incomplete line

      for (const line of lines) {
        const trimmed = line.trim();
        if (!trimmed || trimmed.startsWith(':')) continue;
        if (trimmed === 'data: [DONE]') {
          console.log(`[LLM API] Stream completed [DONE] (Model: ${selectedModel}, Chunks: ${chunkCount})`);
          return;
        }

        if (trimmed.startsWith('data: ')) {
          const jsonStr = trimmed.slice(6);
          try {
            const parsed = JSON.parse(jsonStr);
            const delta = parsed.choices?.[0]?.delta;
            if (delta) {
              if (delta.content) {
                chunkCount++;
                yield delta.content;
              }
            }
          } catch (e) {
            // Ignore partial or unparseable SSE line
          }
        }
      }
    }
    console.log(`[LLM API] Stream finished (Model: ${selectedModel}, Chunks: ${chunkCount})`);
  } finally {
    reader.releaseLock();
  }
}

/**
 * Non-streaming chat completion helper
 */
export async function createChatCompletion(messages, options = {}) {
  const { api, token, model } = getLLMConfig();
  const selectedModel = options.model || model;

  const payload = {
    model: selectedModel,
    messages,
    stream: false,
    temperature: options.temperature !== undefined ? options.temperature : 0.3,
    max_tokens: options.max_tokens || 2048
  };

  const headers = {
    'Content-Type': 'application/json'
  };
  if (token) {
    headers['Authorization'] = token.startsWith('Bearer ') ? token : `Bearer ${token}`;
  }

  const res = await fetch(api, {
    method: 'POST',
    headers,
    body: JSON.stringify(payload),
    signal: options.signal
  });

  if (!res.ok) {
    const errText = await res.text();
    throw new Error(`LLM API error ${res.status}: ${errText}`);
  }

  const data = await res.json();
  return data.choices?.[0]?.message?.content || '';
}
