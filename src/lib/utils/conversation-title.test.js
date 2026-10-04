import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

import { normalizeConversationTitle } from './conversation-title.js';

const routeUrl = new URL('../../routes/api/conversations/[id]/+server.js', import.meta.url);
const moduleUrl = (source) => `data:text/javascript,${encodeURIComponent(source)}`;
let fixtureId = 0;

// Load the real route module, replacing only framework/persistence imports.
// The real title utility is resolved from disk; the DB module is never loaded.
async function patchFixture() {
  const dbUrl = moduleUrl(`
    // Isolate module state for fixture ${fixtureId++}.
    export const writes = [];
    export function updateConversationTitle(id, title) {
      writes.push({ id, title });
      return { id, title };
    }
    export function getConversationById() { throw new Error('Unexpected read'); }
    export function getMessagesByConversationId() { throw new Error('Unexpected read'); }
    export function deleteConversation() { throw new Error('Unexpected delete'); }
  `);
  const kitUrl = moduleUrl(`export function json(body, options = {}) {
    return Response.json(body, options);
  }`);
  const source = (await readFile(routeUrl, 'utf8'))
    .replace("'@sveltejs/kit'", JSON.stringify(kitUrl))
    .replace("'$lib/db/conversations.js'", JSON.stringify(dbUrl))
    .replace("'$lib/utils/conversation-title.js'", JSON.stringify(new URL('./conversation-title.js', import.meta.url).href));
  const { PATCH } = await import(moduleUrl(source));
  const { writes } = await import(dbUrl);
  return {
    writes,
    patch: (body) => PATCH({
      params: { id: 'fixture' },
      request: new Request('http://fixture.test/api/conversations/fixture', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
      })
    })
  };
}

for (const [name, body] of [
  ['object', { title: { text: 'title' } }],
  ['array', { title: ['title'] }],
  ['boolean', { title: true }],
  ['zero', { title: 0 }],
  ['null', { title: null }],
  ['missing', {}],
  ['empty', { title: '' }],
  ['mixed whitespace', { title: '\t\r\n \u00a0\u2003' }]
]) {
  test(`PATCH rejects ${name} title before persistence`, async () => {
    const { patch, writes } = await patchFixture();
    const response = await patch(body);
    assert.equal(response.status, 400);
    assert.deepEqual(await response.json(), { success: false, error: 'Title is required' });
    assert.deepEqual(writes, []);
  });
}

for (const title of ['VisitFlow', '42', '日本語 — project', 'a'.repeat(300)]) {
  test(`PATCH preserves valid title ${title.slice(0, 30)}`, async () => {
    const { patch, writes } = await patchFixture();
    const response = await patch({ title });
    assert.equal(response.status, 200);
    assert.deepEqual(await response.json(), { success: true, conversation: { id: 'fixture', title } });
    assert.deepEqual(writes, [{ id: 'fixture', title }]);
  });
}

test('title normalization preserves internal whitespace and characters', () => {
  assert.equal(normalizeConversationTitle(' \tTitle  日本語\nsecond line \n'), 'Title  日本語\nsecond line');
});

test('PATCH rejects whitespace-only titles before persistence', async () => {
  const { patch, writes } = await patchFixture();
  const response = await patch({ title: '   ' });
  const body = await response.json();
  assert.deepEqual({ status: response.status, body, writes }, {
    status: 400,
    body: { success: false, error: 'Title is required' },
    writes: []
  });
});

test('PATCH persists a trimmed valid title exactly once', async () => {
  const { patch, writes } = await patchFixture();
  const response = await patch({ title: '  VisitFlow  project — 日本語  \n' });
  assert.equal(response.status, 200);
  assert.deepEqual(await response.json(), {
    success: true,
    conversation: { id: 'fixture', title: 'VisitFlow  project — 日本語' }
  });
  assert.deepEqual(writes, [{ id: 'fixture', title: 'VisitFlow  project — 日本語' }]);
});

test('PATCH rejects numeric titles before persistence', async () => {
  const { patch, writes } = await patchFixture();
  const response = await patch({ title: 42 });
  const body = await response.json();
  assert.deepEqual({ status: response.status, body, writes }, {
    status: 400,
    body: { success: false, error: 'Title is required' },
    writes: []
  });
});
