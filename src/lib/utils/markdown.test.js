import { test } from 'node:test';
import assert from 'node:assert/strict';
import { renderMarkdown } from './markdown.js';

test('renderMarkdown wraps table in table-responsive-container for horizontal mobile scrolling', () => {
  const tableMd = `
| Periode | Bulan | Realisasi Kunjungan Sah | Keterangan |
| --- | --- | --- | --- |
| 202601 | Januari | 1.842 | Selesai Full |
| 202602 | Februari | 1.720 | Selesai Full |
`;
  const html = renderMarkdown(tableMd);
  assert.match(html, /<div class="table-responsive-container">/);
  assert.match(html, /<table>/);
  assert.match(html, /<\/div>/);
});
