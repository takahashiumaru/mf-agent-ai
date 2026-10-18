import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const moduleUrl = source => `data:text/javascript,${encodeURIComponent(source)}`;

async function loadRoute() {
  const dbUrl = moduleUrl(`
    export function deleteConversation(id) { return globalThis.deleteConversation(id); }
    export function getConversationById() { throw new Error('Unexpected read'); }
    export function getMessagesByConversationId() { throw new Error('Unexpected read'); }
    export function updateConversationTitle() { throw new Error('Unexpected update'); }
  `);
  const kitUrl = moduleUrl(`export function json(body, options = {}) { return Response.json(body, options); }`);
  const routeUrl = new URL('../../routes/api/conversations/[id]/+server.js', import.meta.url);
  const source = (await readFile(routeUrl, 'utf8'))
    .replace("'@sveltejs/kit'", JSON.stringify(kitUrl))
    .replace("'$lib/db/conversations.js'", JSON.stringify(dbUrl))
    .replace("'$lib/utils/conversation-title.js'", JSON.stringify(new URL('./conversation-title.js', import.meta.url).href));
  return (await import(moduleUrl(source))).DELETE;
}

const DELETE = await loadRoute();

test('DELETE missing conversation returns 404 and preserves existing conversations', async () => {
  const conversations = [{ id: 'another-conversation' }];
  const messages = [{ conversation_id: 'another-conversation' }];
  globalThis.deleteConversation = id => {
    const exists = conversations.some(conversation => conversation.id === id);
    if (!exists) return null;
    return { success: true };
  };

  const response = await DELETE({ params: { id: 'missing-conversation' } });

  assert.equal(response.status, 404);
  assert.deepEqual(await response.json(), { success: false, error: 'Conversation not found' });
  assert.deepEqual(conversations, [{ id: 'another-conversation' }]);
  assert.deepEqual(messages, [{ conversation_id: 'another-conversation' }]);
});

test('DELETE existing conversation returns success', async () => {
  globalThis.deleteConversation = id => {
    assert.equal(id, 'existing-conversation');
    return { success: true };
  };

  const response = await DELETE({ params: { id: 'existing-conversation' } });

  assert.equal(response.status, 200);
  assert.deepEqual(await response.json(), { success: true });
});

test.after(() => { delete globalThis.deleteConversation; });
