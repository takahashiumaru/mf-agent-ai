import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { normalizeConversationTitle } from './conversation-title.js';

// Execute the actual route handler without importing its persistent DB module.
const route = readFileSync(new URL('../../routes/api/conversations/[id]/+server.js', import.meta.url), 'utf8');
const start = route.indexOf('export async function PATCH(');
const end = route.indexOf('\nexport async function DELETE', start);
assert.ok(start >= 0 && end > start, 'PATCH handler boundaries must exist');
const patchSource = route.slice(start, end).replace('export async function', 'async function');

async function patch(title, updateConversationTitle) {
  const context = vm.createContext({
    normalizeConversationTitle,
    updateConversationTitle,
    json: (body, options = {}) => new Response(JSON.stringify(body), {
      status: options.status ?? 200,
      headers: { 'content-type': 'application/json' }
    })
  });
  vm.runInContext(patchSource, context);
  return context.PATCH({
    params: { id: 'fixture-conversation' },
    request: { json: async () => ({ title }) }
  });
}

test('PATCH missing conversation returns 404 rather than false success', async () => {
  const response = await patch('Valid title', (id, title) => {
    assert.equal(id, 'fixture-conversation');
    assert.equal(title, 'Valid title');
    return null;
  });
  assert.equal(response.status, 404);
  assert.deepEqual(await response.json(), { success: false, error: 'Conversation not found' });
});

test('PATCH existing conversation returns the updated record', async () => {
  const record = { id: 'fixture-conversation', title: 'Valid title', updated_at: 'fixture-time' };
  const response = await patch('  Valid title  ', (id, title) => {
    assert.equal(id, record.id);
    assert.equal(title, record.title);
    return record;
  });
  assert.equal(response.status, 200);
  assert.deepEqual(await response.json(), { success: true, conversation: record });
});

test('PATCH blank title remains 400 without updating the store', async () => {
  const response = await patch('   ', () => assert.fail('Invalid title must not reach the store'));
  assert.equal(response.status, 400);
  assert.deepEqual(await response.json(), { success: false, error: 'Title is required' });
});
