import { lexer } from 'marked';

const LIMIT = 24;
function text(value, max = 160) {
  return typeof value === 'string' ? value.trim().slice(0, max) : '';
}

/** Keep model-produced artifacts small, typed, and free of executable content. */
export function validateVisualization(input) {
  if (!input || typeof input !== 'object' || !text(input.title)) return null;
  const common = { title: text(input.title), description: text(input.description, 500), source: text(input.source, 500), unit: text(input.unit, 40) };
  if (input.type === 'flow') {
    if (!Array.isArray(input.steps) || input.steps.length < 2 || input.steps.length > 12 || input.steps.some(step => !text(step))) return null;
    return { ...common, type: 'flow', steps: input.steps.map(step => text(step, 120)) };
  }
  if (!['bar', 'line', 'donut'].includes(input.type)) return null;
  if (!Array.isArray(input.labels) || !Array.isArray(input.values) || input.labels.length !== input.values.length || !input.labels.length || input.labels.length > LIMIT) return null;
  if (input.labels.some(label => !text(label)) || input.values.some(value => typeof value !== 'number' || !Number.isFinite(value) || Math.abs(value) >= 1e15)) return null;
  if (input.type === 'donut' && input.values.some(value => value < 0)) return null;
  return { ...common, type: input.type, labels: input.labels.map(label => text(label, 120)), values: [...input.values] };
}

/** Parse only complete top-level artifact fences; ordinary code stays ordinary code. */
export function parseAssistantContent(content = '') {
  const parts = [];
  let markdown = '';
  let charts = 0;
  for (const token of lexer(content)) {
    let chart = null;
    if (token.type === 'code' && token.lang === 'visitflow-chart' && /\n[ \t]*`{3,}[ \t]*(?:\r?\n)?$/.test(token.raw) && charts < 6) {
      try { chart = validateVisualization(JSON.parse(token.text)); } catch { /* Preserve invalid artifacts as readable code. */ }
    }
    if (chart) {
      if (markdown) parts.push({ type: 'markdown', content: markdown });
      markdown = '';
      parts.push({ type: 'visualization', chart });
      charts++;
    } else {
      markdown += token.raw;
    }
  }
  if (markdown) parts.push({ type: 'markdown', content: markdown });
  return parts;
}
