import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const moduleUrl = source => `data:text/javascript,${encodeURIComponent(source)}`;

test('PATCH reports failure when title persistence throws EISDIR', async () => {
  const dbUrl = moduleUrl(`
    export const writes = [];
    export function updateConversationTitle(id, title) {
      writes.push({ id, title });
      throw Object.assign(new Error('Synthetic persistence failure'), { code: 'EISDIR' });
    }
    export function getConversationById() { throw new Error('Unexpected read'); }
    export function getMessagesByConversationId() { throw new Error('Unexpected read'); }
    export function deleteConversation() { throw new Error('Unexpected delete'); }
  `);
  const kitUrl = moduleUrl(`export function json(body, options = {}) {
    return Response.json(body, options);
  }`);
  const routeUrl = new URL('../../routes/api/conversations/[id]/+server.js', import.meta.url);
  const source = (await readFile(routeUrl, 'utf8'))
    .replace("'@sveltejs/kit'", JSON.stringify(kitUrl))
    .replace("'$lib/db/conversations.js'", JSON.stringify(dbUrl))
    .replace("'$lib/utils/conversation-title.js'", JSON.stringify(new URL('./conversation-title.js', import.meta.url).href));
  const { PATCH } = await import(moduleUrl(source));
  const { writes } = await import(dbUrl);
  const response = await PATCH({
    params: { id: 'synthetic' },
    request: new Request('http://fixture.test/api/conversations/synthetic', {
      method: 'PATCH', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'Synthetic title' })
    })
  });
  assert.equal(response.status, 500);
  assert.deepEqual(await response.json(), { success: false, error: 'Synthetic persistence failure' });
  assert.deepEqual(writes, [{ id: 'synthetic', title: 'Synthetic title' }]);
});
