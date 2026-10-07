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

function fixture() {
  const requests = [];
  const context = vm.createContext({
    activeProject: 'visitflow', conversations: [], isStreaming: false,
    startNewChat() {}, toast: { success() {} }, console,
    fetch(url) {
      let resolve;
      const response = new Promise(r => { resolve = r; });
      requests.push({ url, resolve: data => resolve({ json: async () => data }) });
      return response;
    }
  });
  // Include the real page's request-generation declaration when present.
  const generation = page.match(/  let conversationLoadRequest = [^;]+;/)?.[0] || '';
  vm.runInContext(`${generation}\n${pageFunction('loadConversations', true)}\n${pageFunction('handleSelectProject')}`, context);
  return {
    context, requests,
    list: () => JSON.parse(JSON.stringify(context.conversations)),
    async settle(index, conversations) {
      requests[index].resolve({ success: true, conversations });
      // Drain fetch/json/assignment continuations, including fire-and-forget switch loads.
      await new Promise(resolve => setImmediate(resolve));
    }
  };
}

test('slower previous-project response cannot replace the selected project list', async () => {
  const f = fixture();
  const oldLoad = f.context.loadConversations();
  f.context.handleSelectProject('ski-compliance');
  assert.equal(f.context.activeProject, 'ski-compliance');
  assert.deepEqual(f.requests.map(r => r.url), [
    '/api/conversations?project=visitflow', '/api/conversations?project=ski-compliance'
  ]);
  await f.settle(1, [{ id: 'ski' }]);
  assert.deepEqual(f.list(), [{ id: 'ski' }]);
  await f.settle(0, [{ id: 'vf' }]);
  await oldLoad;
  assert.deepEqual(f.list(), [{ id: 'ski' }]);
});

test('latest-started refresh wins when requests target the same project', async () => {
  const f = fixture();
  const oldLoad = f.context.loadConversations();
  const latestLoad = f.context.loadConversations();
  await f.settle(1, [{ id: 'new' }]);
  await latestLoad;
  assert.deepEqual(f.list(), [{ id: 'new' }]);
  await f.settle(0, [{ id: 'old' }]);
  await oldLoad;
  assert.deepEqual(f.list(), [{ id: 'new' }]);
});
