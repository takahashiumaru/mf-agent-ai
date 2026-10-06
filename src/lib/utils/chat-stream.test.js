import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

test('setup: locate sendMessage source', () => {
  const page = fs.readFileSync(new URL('../../routes/+page.svelte', import.meta.url), 'utf8');
  const start = page.indexOf('  async function sendMessage(');
  const end = page.indexOf('\n  function stopStreaming', start);
  assert.ok(start >= 0 && end > start, 'locate actual sendMessage source');
});

const page = fs.readFileSync(new URL('../../routes/+page.svelte', import.meta.url), 'utf8');
const start = page.indexOf('  async function sendMessage(');
const end = page.indexOf('\n  function stopStreaming', start);
async function stream(chunks) {
  let index = 0;
  const errors = [];
  const context = vm.createContext({
    isStreaming: false, lastFailedPrompt: '', userScrolledUp: false,
    messages: [], isThinking: false, currentStreamingText: '', currentStreamingSources: [],
    activeId: null, activeConversation: null, activeModel: 'fixture', activeProject: 'visitflow',
    abortController: null, tick: async () => {}, scrollToBottom: () => {},
    AbortController, TextDecoder, Date, console, loadConversations: () => {},
    toast: { error: (message) => errors.push(message) },
    fetch: async () => ({ ok: true, body: { getReader: () => ({
      read: async () => index < chunks.length
        ? { value: new TextEncoder().encode(chunks[index++]), done: false }
        : { done: true }
    }) } })
  });
  vm.runInContext(page.slice(start, end), context);
  await context.sendMessage('fixture');
  assert.deepEqual(errors, [], 'fixture stream should not fail');
  return context;
}

test('delta event survives a read boundary between event and data lines', async () => {
  const whole = await stream(['event: delta\ndata: {"text":"hello"}\n\n']);
  assert.equal(whole.currentStreamingText, 'hello');
  const split = await stream(['event: delta\n', 'data: {"text":"hello"}\n\n']);
  assert.equal(split.currentStreamingText, 'hello');
});

test('blank event delimiter prevents an unnamed event inheriting delta', async () => {
  const result = await stream(['event: delta\ndata: {"text":"hello"}\n\ndata: {"text":"ignored"}\n\n']);
  assert.equal(result.currentStreamingText, 'hello');
});

test('sources title delta and done produce the same completed message at every byte boundary', async () => {
  const events = [
    'event: sources\ndata: {"sources":[{"name":"fixture"}]}\n\n',
    'event: title\ndata: {"conversationId":"fixture-id","title":"Fixture title"}\n\n',
    'event: delta\ndata: {"text":"hello"}\n\n',
    'event: done\ndata: {"id":"assistant-fixture","conversationId":"fixture-id"}\n\n'
  ];
  const bytes = events.join('');
  const expected = await stream([bytes]);
  assert.equal(expected.messages[1].content, 'hello');
  assert.equal(expected.messages[1].sources[0].name, 'fixture');
  assert.equal(expected.activeConversation.title, 'Fixture title');
  for (let boundary = 1; boundary < bytes.length; boundary++) {
    const actual = await stream([bytes.slice(0, boundary), bytes.slice(boundary)]);
    assert.equal(JSON.stringify(actual.messages[1].sources), JSON.stringify(expected.messages[1].sources), `sources at ${boundary}`);
    assert.equal(actual.messages[1].content, 'hello', `content at ${boundary}`);
    assert.equal(actual.messages[1].id, 'assistant-fixture', `done at ${boundary}`);
    assert.equal(actual.activeId, 'fixture-id', `id at ${boundary}`);
    assert.equal(actual.activeConversation.title, 'Fixture title', `title at ${boundary}`);
    assert.equal(actual.currentStreamingText, '', `accumulator cleared at ${boundary}`);
    assert.equal(actual.isStreaming, false, `stream completed at ${boundary}`);
  }
});
