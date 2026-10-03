import fs from 'node:fs';
import path from 'node:path';
import { VISUALIZATION_INSTRUCTIONS } from './visualization-prompt.js';

const cachedPrompts = new Map();

function readDocFile(relPath) {
  try {
    const fullPath = path.resolve(process.cwd(), relPath);
    if (fs.existsSync(fullPath)) {
      return fs.readFileSync(fullPath, 'utf8');
    }
  } catch (err) {
    console.warn(`Could not read ${relPath}:`, err.message);
  }
  return '';
}

export function getBasePrompts(project = 'visitflow') {
  if (process.env.NODE_ENV === 'production' && cachedPrompts.has(project)) {
    return cachedPrompts.get(project);
  }

  let system = '';
  let rules = '';
  let tools = '';
  let references = '';

  if (project === 'ski-compliance') {
    system = readDocFile('prompts/ski-compliance/system.md') || 'Nama kamu Ski Compliance AI Assistant untuk Metiska Farma.';
    rules = readDocFile('prompts/ski-compliance/rules.md') || '';
    tools = readDocFile('prompts/ski-compliance/tools.md') || '';
    
    const salesFfRef = readDocFile('prompts/ski-compliance/sales_ff_reference.md');
    const tablesRef = readDocFile('prompts/ski-compliance/tables_reference.md');
    const projectMapRef = readDocFile('prompts/ski-compliance/project_map.md');
    const domainRef = readDocFile('prompts/ski-compliance/domain.md');
    const dataAnswersRef = readDocFile('prompts/ski-compliance/data_answers.md');
    references = [salesFfRef, tablesRef, projectMapRef, domainRef, dataAnswersRef].filter(Boolean).join('\n\n---\n\n');
  } else {
    system = readDocFile('prompts/default/system.md') || 'Nama kamu VisitFlowAI, Asisten Cerdas untuk VisitFlow.';
    rules = readDocFile('prompts/default/rules.md') || '';
    tools = readDocFile('prompts/default/tools.md') || '';
  }

  const result = { system, rules, tools, references };
  cachedPrompts.set(project, result);
  return result;
}

/**
 * Builds the complete system prompt injecting retrieved repository knowledge and context.
 */
export function buildSystemPrompt(contextBlock = '', toolResultsBlock = '', project = 'visitflow') {
  const { system, rules, references } = getBasePrompts(project);
  const isCompliance = project === 'ski-compliance';
  const appName = isCompliance ? 'Ski Compliance' : 'VisitFlow';

  return `
${system}

${VISUALIZATION_INSTRUCTIONS}

---

## ATURAN PERILAKU & INTEGRITAS DATA (STRICT):
1. Jawablah selalu berdasarkan informasi yang ada di dokumentasi, source code, rules, dan schema repository ${appName} yang diberikan di bawah.
2. JANGAN MENGARANG (hallucinate) atau menebak informasi yang tidak tertera di repository.
3. Jika informasi yang ditanyakan belum ada atau tidak ditemukan di knowledge base, katakan dengan jujur dan sopan: "Informasi mengenai hal tersebut belum tersedia di dokumentasi/repository ${appName} saat ini."
4. Gunakan Bahasa Indonesia yang ramah, profesional, ringkas, dan jelas.
5. Format jawaban menggunakan Markdown yang rapi (gunakan bold, bullet points, numbered list, tabel, dan code block dengan bahasa pemrogramannya seperti \`\`\`sql, \`\`\`json, \`\`\`go).
6. Di SKI Compliance, istilah "SPC" atau "CN" secara mutlak merujuk ke Credit Notes (Nota Kredit / potongan klaim retur & diskon ekstra kesepakatan dokter), dan setiap pertanyaan terkait Total CN atau Total SPC WAJIB mengambil data dari tabel 'credit_notes' di SKI_MF_PROD (dengan kolom nominal 'value' dan filter 'WHERE deleted_at IS NULL').
7. ${rules}

${references ? `\n---\n## REFERENSI RESMI REPOSITORY & SKEMA TABEL:\n${references}\n` : ''}

---

## KNOWLEDGE & KONTEKS TERVERIFIKASI DARI REPOSITORY ${appName.toUpperCase()}:
${contextBlock}

${toolResultsBlock ? `\n---\n## DATA REAL-TIME DARI API / TOOL RESULT:\n${toolResultsBlock}\n` : ''}
`.trim();
}
