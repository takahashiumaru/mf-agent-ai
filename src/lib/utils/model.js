export const AVAILABLE_MODELS = [
  { id: 'combo-9router', label: '9Router Smart Combo', speed: 'Recommended' },
  { id: 'codex-luna-6-low', label: 'Codex Luna 6 Low', speed: 'Codex Fast' },
  { id: 'codex-sol-6.1-low', label: 'Codex Sol 6.1 Low', speed: 'Codex Deep' },
  { id: 'gemini-3.7-flash-low', label: 'Gemini 3.7 Flash Low', speed: 'AGY Flash' },
  { id: 'gemini-3.7-flash-medium', label: 'Gemini 3.7 Flash Med', speed: 'AGY Balanced' },
  { id: 'gemini-3.7-flash-high', label: 'Gemini 3.7 Flash High', speed: 'AGY Deep' }
];

export function formatModelName(modelId) {
  if (!modelId) return '9Router Smart Combo';
  const found = AVAILABLE_MODELS.find(m => m.id === modelId || m.id === modelId.replace(/^(ag\/|cx\/)/, ''));
  if (found) return found.label;
  if (modelId === 'combo-9router') return '9Router Smart Combo';
  if (modelId.includes('luna')) return 'Codex Luna 6 Low';
  if (modelId.includes('sol')) return 'Codex Sol 6.1 Low';
  if (modelId.includes('flash-low')) return 'Gemini 3.7 Flash Low';
  if (modelId.includes('medium')) return 'Gemini 3.7 Flash Med';
  if (modelId.includes('high')) return 'Gemini 3.7 Flash High';
  return modelId;
}
