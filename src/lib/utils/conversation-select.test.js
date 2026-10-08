import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';

const page = readFileSync(new URL('../../routes/+page.svelte', import.meta.url), 'utf8');
function pageFunction(name, async = false) {
  const start = page.indexOf(`  ${async ? 'async ' : ''}function ${name}(`);
  assert.notEqual(start, -1);
  const end = page.indexOf('\n  }', start);
  assert.notEqual(end, -1);
  return page.slice(start, end + '\n  }'.length);
}
function fixture({ streaming = false, tick = async () => {} } = {}) {
  const requests = [], writes = [], errors = [], navigation = [], scrolls = [];
  const context = vm.createContext({
    activeId: null, activeConversation: null, messages: [], activeProject: 'visitflow',
    isStreaming: streaming, isSidebarOpen: true, currentStreamingText: '',
    currentStreamingSources: [], lastFailedPrompt: '', URL, tick,
    window: { matchMedia: () => ({ matches: true }), location: { href: 'https://example.test/' },
      history: { pushState: (...args) => navigation.push(args) } },
    localStorage: { setItem: (...args) => writes.push(args) },
    toast: { error: message => errors.push(message) },
    scrollToBottom: value => scrolls.push(value),
    fetch(url) {
      return new Promise((resolve, reject) => requests.push({ url, reject,
        resolve: data => resolve({ json: async () => data }) }));
    }
  });
  const generation = page.match(/  let conversationSelectRequest = [^;]+;/)?.[0] || '';
  vm.runInContext(`${generation}\n${pageFunction('selectConversation', true)}\n${pageFunction('startNewChat')}`, context);
  const snapshot = () => JSON.parse(JSON.stringify({
    activeId: context.activeId, detail: context.activeConversation, messages: context.messages,
    project: context.activeProject, sidebar: context.isSidebarOpen, writes, errors, navigation, scrolls
  }));
  return { context, requests, snapshot, resolve(index, id, content = id, project = 'visitflow') {
    requests[index].resolve({ success: true, conversation: { id, project }, messages: [{ content }] });
  } };
}

test('newest A wins in an A to B to A race', async () => {
  const f = fixture();
  const oldA = f.context.selectConversation('A');
  const b = f.context.selectConversation('B');
  const newA = f.context.selectConversation('A');
  f.resolve(2, 'A', 'newest'); await newA;
  const before = f.snapshot();
  f.resolve(1, 'B'); await b;
  f.resolve(0, 'A', 'oldest'); await oldA;
  assert.deepEqual(f.snapshot(), before);
});

test('latest success applies detail, messages, project and navigation', async () => {
  const f = fixture();
  const selected = f.context.selectConversation('A');
  f.resolve(0, 'A', 'latest', 'ski-compliance'); await selected;
  const s = f.snapshot();
  assert.equal(s.activeId, 'A');
  assert.deepEqual(s.detail, { id: 'A', project: 'ski-compliance' });
  assert.deepEqual(s.messages, [{ content: 'latest' }]);
  assert.equal(s.project, 'ski-compliance');
  assert.deepEqual(s.writes, [['visitflow-active-project', 'ski-compliance']]);
  assert.deepEqual(s.navigation, [[{ conversationId: 'A' }, '', 'https://example.test/?c=A']]);
  assert.deepEqual(s.scrolls, [true]);
});

test('streaming selection and New Chat remain no-ops', async () => {
  const f = fixture({ streaming: true });
  const before = f.snapshot();
  await f.context.selectConversation('A');
  f.context.startNewChat();
  assert.deepEqual(f.snapshot(), before);
  assert.equal(f.requests.length, 0);
});

test('updateUrl false suppresses selection and reset navigation', async () => {
  const f = fixture();
  const selected = f.context.selectConversation('A', false);
  f.resolve(0, 'A'); await selected;
  f.context.startNewChat(false);
  assert.deepEqual(f.snapshot().navigation, []);
});

test('invalidating selection while tick is pending prevents stale scroll', async () => {
  let releaseTick;
  const f = fixture({ tick: () => new Promise(resolve => { releaseTick = resolve; }) });
  const a = f.context.selectConversation('A');
  f.resolve(0, 'A');
  await new Promise(resolve => setImmediate(resolve));
  f.context.startNewChat();
  const before = f.snapshot();
  releaseTick(); await a;
  assert.deepEqual(f.snapshot(), before);
});

test('stale rejection is silent but latest rejection reports an error', async () => {
  const f = fixture();
  const a = f.context.selectConversation('A');
  const b = f.context.selectConversation('B');
  f.requests[0].reject(new Error('old')); await a;
  assert.deepEqual(f.snapshot().errors, []);
  f.requests[1].reject(new Error('latest')); await b;
  assert.deepEqual(f.snapshot().errors, ['Gagal memuat detail percakapan']);
});

test('New Chat invalidates pending detail without changing project or storage', async () => {
  const f = fixture();
  const a = f.context.selectConversation('A');
  f.context.startNewChat();
  const before = f.snapshot();
  f.resolve(0, 'A', 'stale', 'ski-compliance'); await a;
  assert.deepEqual(f.snapshot(), before);
});

test('slower cross-project detail cannot overwrite newer selection or storage', async () => {
  const f = fixture();
  const a = f.context.selectConversation('A');
  const b = f.context.selectConversation('B');
  f.resolve(1, 'B'); await b;
  const before = f.snapshot();
  f.resolve(0, 'A', 'stale', 'ski-compliance'); await a;
  assert.deepEqual(f.snapshot(), before);
});
