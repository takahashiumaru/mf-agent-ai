import test from 'node:test';
import assert from 'node:assert/strict';
import { parseAssistantContent, validateVisualization } from './visualizations.js';

const chart = { type: 'bar', title: 'Data uji', labels: ['A', 'B'], values: [12, 8] };
const fence = (data) => '```visitflow-chart\n' + JSON.stringify(data) + '\n```\n';

test('renders a chart between explanation and follow-up text without changing its numbers', () => {
  const parts = parseAssistantContent('Penjelasan.\n\n' + fence(chart) + '\nKesimpulan.');
  assert.deepEqual(parts.map(part => part.type), ['markdown', 'visualization', 'markdown']);
  assert.deepEqual(parts[1].chart.values, [12, 8]);
});
test('incomplete streaming JSON stays readable until the closing fence arrives', () => {
  assert.equal(parseAssistantContent(fence(chart).replace(/```\n$/, ''))[0].type, 'markdown');
});
test('mismatched labels, nonnumeric data, huge values, and negative donut values are rejected', () => {
  for (const invalid of [{ ...chart, values: [12] }, { ...chart, values: ['12', 8] }, { ...chart, values: [Infinity, 8] }, { ...chart, values: [1e15, 8] }, { ...chart, type: 'donut', values: [-1, 8] }]) assert.equal(validateVisualization(invalid), null);
});
test('zero totals and signed bar/line values are retained accurately', () => {
  assert.deepEqual(validateVisualization({ ...chart, type: 'donut', values: [0, 0] }).values, [0, 0]);
  assert.deepEqual(validateVisualization({ ...chart, type: 'line', values: [-4, 8] }).values, [-4, 8]);
});
test('invalid JSON falls back to ordinary markdown and excessive categories are rejected', () => {
  assert.equal(parseAssistantContent('```visitflow-chart\nno json\n```')[0].type, 'markdown');
  assert.equal(validateVisualization({ ...chart, labels: Array(25).fill('A'), values: Array(25).fill(1) }), null);
});
test('flow keeps steps in order and rejects missing steps', () => {
  assert.deepEqual(validateVisualization({ type: 'flow', title: 'Alur uji', steps: ['Mulai', 'Selesai'] }).steps, ['Mulai', 'Selesai']);
  assert.equal(validateVisualization({ type: 'flow', title: 'Alur uji', steps: ['Mulai', ''] }), null);
});
test('artifact-looking text nested inside an ordinary code block is not rendered', () => {
  assert.equal(parseAssistantContent('````markdown\n' + fence(chart) + '````\n')[0].type, 'markdown');
});
