import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import crypto from 'node:crypto';

const route = readFileSync(new URL('../../routes/api/chat/+server.js', import.meta.url), 'utf8');
const start = route.indexOf('export async function POST(');
assert.ok(start >= 0, 'POST handler must exist');
const postSource = route.slice(start).replace('export async function', 'async function');
const dbSource = readFileSync(new URL('../db/conversations.js', import.meta.url), 'utf8')
  .replace(/^import .*;\n/, '').replaceAll('export function', 'function');

async function chat(body, existing, history = []) {
  // Execute actual persistence functions against an isolated in-memory store.
  // Never import the DB client, open real storage, or invoke a provider.
  const data = { conversations: existing ? [{ ...existing }] : [], messages: history.map(m => ({ ...m })) };
  const calls = [];
  const context = vm.createContext({
    getDbStore: () => ({ get: () => data, save: () => {} }),
    crypto, Response, ReadableStream, TextEncoder, console,
    process: { env: {} },
    runAgentStream: async function* (message, priorMessages, options) {
      calls.push({ message, priorMessages, options });
      yield { type: 'chunk', text: 'fixture response' };
    }
  });
  vm.runInContext(dbSource + '\n' + postSource, context);
  const request = new Request('http://fixture.invalid/api/chat', {
    method: 'POST', body: JSON.stringify(body), headers: { 'Content-Type': 'application/json' }
  });
  const response = await context.POST({ request });
  const stream = await response.text();
  assert.equal(response.status, 200);
  assert.match(stream, /event: done/);
  assert.equal(calls.length, 1);
  assert.equal(data.messages.at(-2).role, 'user');
  assert.equal(data.messages.at(-1).content, 'fixture response');
  return { data, call: calls[0] };
}

const history = [{ id: 'old', conversation_id: 'existing', role: 'user', content: 'stored domain history', created_at: '2026-01-01' }];

test('continued chat uses stored project despite conflicting caller project', async () => {
  const { call, data } = await chat({ conversationId: 'existing', message: 'next', project: 'visitflow' },
    { id: 'existing', project: 'ski-compliance' }, history);
  assert.equal(call.priorMessages[0].content, 'stored domain history');
  assert.equal(data.conversations[0].project, 'ski-compliance');
  assert.equal(call.options.project, 'ski-compliance');
});

test('continued chat with omitted project uses stored project', async () => {
  const { call } = await chat({ conversationId: 'existing', message: 'next' }, { id: 'existing', project: 'ski-compliance' });
  assert.equal(call.options.project, 'ski-compliance');
});

test('legacy conversation without project remains visitflow', async () => {
  const { call } = await chat({ conversationId: 'existing', message: 'next', project: 'ski-compliance' }, { id: 'existing' });
  assert.equal(call.options.project, 'visitflow');
});

for (const project of ['visitflow', 'ski-compliance']) {
  test(`new ${project} conversation retains requested project`, async () => {
    const { call, data } = await chat({ message: 'first', project });
    assert.equal(data.conversations.length, 1);
    assert.equal(data.conversations[0].project, project);
    assert.equal(call.options.project, project);
  });
  test(`unknown conversation ID retains creation behavior for ${project}`, async () => {
    const { call, data } = await chat({ conversationId: 'unknown', message: 'first', project });
    assert.equal(data.conversations[0].id, 'unknown');
    assert.equal(data.conversations[0].project, project);
    assert.equal(call.options.project, project);
  });
}

test('new conversation with omitted project defaults to visitflow', async () => {
  const { call, data } = await chat({ message: 'first' });
  assert.equal(data.conversations[0].project, 'visitflow');
  assert.equal(call.options.project, 'visitflow');
});

test('stored visitflow also overrides caller ski-compliance', async () => {
  const { call } = await chat({ conversationId: 'existing', message: 'next', project: 'ski-compliance' },
    { id: 'existing', project: 'visitflow' });
  assert.equal(call.options.project, 'visitflow');
});
