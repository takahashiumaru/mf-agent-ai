import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';

const page = readFileSync(new URL('../../routes/+page.svelte', import.meta.url), 'utf8');

// Execute the actual page functions, not a duplicate of their implementation.
function pageFunction(name) {
  const start = page.indexOf(`  function ${name}(`);
  assert.notEqual(start, -1, `${name} must exist in the page`);
  const end = page.indexOf('\n  }', start);
  assert.notEqual(end, -1, `${name} must have a closing boundary`);
  return page.slice(start, end + '\n  }'.length);
}

function fixture(isStreaming) {
  const writes = [];
  const loads = [];
  const notices = [];
  const navigation = [];
  const context = vm.createContext({
    isStreaming,
    activeProject: 'visitflow',
    activeId: 'visitflow-fixture',
    activeConversation: { id: 'visitflow-fixture', project: 'visitflow' },
    messages: [{ role: 'assistant', content: 'Partial response' }],
    currentStreamingText: 'Partial response',
    currentStreamingSources: [{ title: 'Source' }],
    lastFailedPrompt: 'Earlier prompt',
    isSidebarOpen: true,
    URL,
    window: {
      location: { href: 'https://example.test/?c=visitflow-fixture' },
      matchMedia: () => ({ matches: true }),
      history: { pushState: (...args) => navigation.push(args) }
    },
    localStorage: { setItem: (...args) => writes.push(args) },
    loadConversations: (project) => loads.push(project),
    toast: { success: (message) => notices.push(message) }
  });
  vm.runInContext(`${pageFunction('startNewChat')}\n${pageFunction('handleSelectProject')}`, context);
  const snapshot = () => JSON.parse(JSON.stringify({
    activeProject: context.activeProject,
    activeId: context.activeId,
    activeConversation: context.activeConversation,
    messages: context.messages,
    currentStreamingText: context.currentStreamingText,
    currentStreamingSources: context.currentStreamingSources,
    lastFailedPrompt: context.lastFailedPrompt,
    isSidebarOpen: context.isSidebarOpen,
    writes, loads, notices, navigation
  }));
  return { context, snapshot };
}

test('project selection during streaming preserves current project/chat and has no side effects', () => {
  const { context, snapshot } = fixture(true);
  const before = snapshot();
  context.handleSelectProject('ski-compliance');
  assert.deepEqual(snapshot(), before);
});

test('idle project selection still resets chat, persists project and loads its conversations', () => {
  const { context, snapshot } = fixture(false);
  context.handleSelectProject('ski-compliance');
  const after = snapshot();
  assert.equal(after.activeProject, 'ski-compliance');
  assert.equal(after.activeId, null);
  assert.equal(after.activeConversation, null);
  assert.deepEqual(after.messages, []);
  assert.equal(after.currentStreamingText, '');
  assert.deepEqual(after.currentStreamingSources, []);
  assert.equal(after.lastFailedPrompt, '');
  assert.equal(after.isSidebarOpen, false);
  assert.deepEqual(after.writes, [['visitflow-active-project', 'ski-compliance']]);
  assert.deepEqual(after.loads, ['ski-compliance']);
  assert.deepEqual(after.notices, ['Beralih ke project Ski Compliance']);
  assert.deepEqual(after.navigation, [[{}, '', 'https://example.test/']]);
});

for (const streaming of [false, true]) {
  test(`selecting the current project is a no-op (streaming=${streaming})`, () => {
    const { context, snapshot } = fixture(streaming);
    const before = snapshot();
    context.handleSelectProject('visitflow');
    assert.deepEqual(snapshot(), before);
  });
}
