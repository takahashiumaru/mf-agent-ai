import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';

const page = readFileSync(new URL('../../routes/+page.svelte', import.meta.url), 'utf8');
function pageFunction(name, async = false) {
  const start = page.indexOf(`  ${async ? 'async ' : ''}function ${name}(`);
  assert.notEqual(start, -1, `${name} must exist`);
  const end = page.indexOf('\n  }', start);
  assert.notEqual(end, -1, `${name} must have a closing boundary`);
  return page.slice(start, end + '\n  }'.length);
}
const vf = [{ id: 'synthetic-vf', project: 'visitflow' }];
const ski = [{ id: 'synthetic-ski', project: 'ski-compliance' }];
function fixture() {
  const requests = [], writes = [], navigation = [], errors = [];
  const context = vm.createContext({
    conversations: structuredClone(vf), activeProject: 'visitflow', activeId: null,
    activeConversation: null, messages: [], isStreaming: false, isSidebarOpen: true,
    currentStreamingText: '', currentStreamingSources: [], lastFailedPrompt: '',
    URL, console, tick: async () => {}, scrollToBottom() {},
    window: { matchMedia: () => ({ matches: false }),
      location: { href: 'https://example.test/?c=synthetic-ski' },
      history: { pushState: (...args) => navigation.push(args) } },
    localStorage: { setItem: (...args) => writes.push(args) },
    toast: { error: message => errors.push(message) },
    fetch(url) {
      return new Promise(resolve => requests.push({ url,
        resolve: data => resolve({ json: async () => data }) }));
    }
  });
  const generations = ['conversationLoadRequest', 'conversationSelectRequest'].map(name => {
    const declaration = page.match(new RegExp(`  let ${name} = [^;]+;`));
    assert.ok(declaration, `${name} guard must exist`);
    return declaration[0];
  });
  vm.runInContext(`${generations.join('\n')}\n${pageFunction('loadConversations', true)}\n${pageFunction('selectConversation', true)}\n${pageFunction('startNewChat')}`, context);
  return { context, requests, writes, navigation, errors,
    list: () => JSON.parse(JSON.stringify(context.conversations)),
    async settle(index, data) {
      assert.ok(requests[index], `request ${index} must exist`);
      requests[index].resolve({ success: true, ...data });
      await new Promise(resolve => setImmediate(resolve));
    }
  };
}

// updateUrl=false is the actual deep-link/popstate selection entry point.
test('cross-project deep-link selection refreshes the sidebar to the detail project', async () => {
  const f = fixture();
  const selected = f.context.selectConversation('synthetic-ski', false);
  await f.settle(0, { conversation: ski[0], messages: [{ content: 'synthetic' }] });
  await selected;
  assert.equal(f.context.activeProject, 'ski-compliance');
  assert.equal(f.context.activeConversation.id, 'synthetic-ski');
  assert.deepEqual(f.navigation, []);
  assert.deepEqual(f.writes, [['visitflow-active-project', 'ski-compliance']]);
  assert.deepEqual(f.requests.map(r => r.url), [
    '/api/conversations/synthetic-ski', '/api/conversations?project=ski-compliance'
  ]);
  assert.deepEqual(f.list(), [], 'old-project sidebar must clear while replacement loads');
  await f.settle(1, { conversations: ski });
  assert.deepEqual(f.list(), ski);
  assert.deepEqual(f.errors, []);
});

test('late previous-project list cannot replace a deep-linked project sidebar', async () => {
  const f = fixture();
  const oldList = f.context.loadConversations('visitflow');
  const selected = f.context.selectConversation('synthetic-ski', false);
  await f.settle(1, { conversation: ski[0] });
  await selected;
  assert.equal(f.requests[2]?.url, '/api/conversations?project=ski-compliance');
  await f.settle(2, { conversations: ski });
  await f.settle(0, { conversations: vf });
  await oldList;
  assert.deepEqual(f.list(), ski);
});

test('history selection back to another project refreshes that project list', async () => {
  const f = fixture();
  const forward = f.context.selectConversation('synthetic-ski', false);
  await f.settle(0, { conversation: ski[0] });
  await forward;
  await f.settle(1, { conversations: ski });
  const back = f.context.selectConversation('synthetic-vf', false);
  await f.settle(2, { conversation: vf[0] });
  await back;
  assert.equal(f.requests[3]?.url, '/api/conversations?project=visitflow');
  assert.deepEqual(f.list(), []);
  await f.settle(3, { conversations: vf });
  assert.equal(f.context.activeProject, 'visitflow');
  assert.deepEqual(f.list(), vf);
  assert.deepEqual(f.navigation, []);
});

test('same-project selection preserves the sidebar without a redundant list request', async () => {
  const f = fixture();
  const selected = f.context.selectConversation('synthetic-vf', false);
  await f.settle(0, { conversation: vf[0] });
  await selected;
  assert.equal(f.requests.length, 1);
  assert.deepEqual(f.list(), vf);
  assert.deepEqual(f.writes, []);
});

test('stale cross-project detail cannot start a list refresh or change scope', async () => {
  const f = fixture();
  const old = f.context.selectConversation('synthetic-ski', false);
  const latest = f.context.selectConversation('synthetic-vf', false);
  await f.settle(1, { conversation: vf[0] });
  await latest;
  await f.settle(0, { conversation: ski[0] });
  await old;
  assert.equal(f.context.activeProject, 'visitflow');
  assert.equal(f.context.activeConversation.id, 'synthetic-vf');
  assert.equal(f.requests.length, 2);
  assert.deepEqual(f.list(), vf);
  assert.deepEqual(f.writes, []);
});

test('New Chat invalidates a pending cross-project detail before it can refresh', async () => {
  const f = fixture();
  const selected = f.context.selectConversation('synthetic-ski', false);
  f.context.startNewChat(false);
  await f.settle(0, { conversation: ski[0] });
  await selected;
  assert.equal(f.context.activeConversation, null);
  assert.equal(f.context.activeProject, 'visitflow');
  assert.equal(f.requests.length, 1);
  assert.deepEqual(f.list(), vf);
});
