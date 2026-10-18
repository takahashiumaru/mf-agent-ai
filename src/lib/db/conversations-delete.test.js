import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, copyFileSync, rmSync } from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { spawnSync } from 'node:child_process';

function runIsolated(body) {
  const cwd = mkdtempSync(path.join(os.tmpdir(), 'mf-conversation-delete-'));
  try {
    copyFileSync(new URL('./client.js', import.meta.url), path.join(cwd, 'client.js'));
    copyFileSync(new URL('./conversations.js', import.meta.url), path.join(cwd, 'conversations.js'));
    const imports = `
      import assert from 'node:assert/strict';
      import fs from 'node:fs';
      import { getDbStore } from './client.js';
      import { deleteConversation } from './conversations.js';
      const store = getDbStore();
      const initial = {
        conversations: [
          { id: 'target', title: 'Delete me' },
          { id: 'keep', title: 'Keep me' }
        ],
        messages: [
          { id: 'target-message', conversation_id: 'target', content: 'Remove me' },
          { id: 'other-message', conversation_id: 'keep', content: 'Keep me' }
        ]
      };
      store.save(initial);
    `;
    const child = spawnSync(process.execPath, ['--input-type=module', '-e', `${imports}\n${body}`], { cwd, encoding: 'utf8' });
    assert.equal(child.status, 0, `Isolated child failed:\n${child.stdout}${child.stderr}`);
  } finally {
    rmSync(cwd, { recursive: true, force: true });
  }
}

test('deleteConversation removes and persists the conversation and its messages', () => {
  runIsolated(`
    const result = deleteConversation('target');
    assert.deepEqual(result, { success: true, id: 'target' });
    assert.deepEqual(store.get(), {
      conversations: [{ id: 'keep', title: 'Keep me' }],
      messages: [{ id: 'other-message', conversation_id: 'keep', content: 'Keep me' }]
    });
    const persisted = JSON.parse(fs.readFileSync('data/conversations_store.json', 'utf8'));
    assert.deepEqual(persisted, store.get());
  `);
});

test('deleteConversation returns null for a missing ID without saving', () => {
  runIsolated(`
    const before = fs.readFileSync('data/conversations_store.json', 'utf8');
    let saveCalls = 0;
    const originalSave = store.save.bind(store);
    store.save = (...args) => { saveCalls += 1; return originalSave(...args); };
    assert.equal(deleteConversation('missing'), null);
    assert.equal(saveCalls, 0);
    assert.equal(fs.readFileSync('data/conversations_store.json', 'utf8'), before);
  `);
});
