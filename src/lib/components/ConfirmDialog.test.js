import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const component = await readFile(new URL('./ConfirmDialog.svelte', import.meta.url), 'utf8');

test('opening ConfirmDialog initially focuses the confirm action', () => {
  assert.match(component, /querySelector\('\[data-confirm-action\]'\)\?\.focus\(\)/);
  assert.match(component, /class="btn-confirm[^\"]*"[^>]*data-confirm-action/);
});