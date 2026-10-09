import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, copyFileSync, rmSync } from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { spawnSync } from 'node:child_process';

function runIsolated(body) {
  const cwd = mkdtempSync(path.join(os.tmpdir(), 'mf-client-save-'));
  try {
    copyFileSync(new URL('./client.js', import.meta.url), path.join(cwd, 'client.mjs'));
    const child = spawnSync(process.execPath, ['--input-type=module', '-e', `
      import assert from 'node:assert/strict';
      import fs from 'node:fs';
      import { getDbStore } from './client.mjs';
      const store = getDbStore();
      const original = { conversations: [{ id: 'synthetic', title: 'Before' }], messages: [] };
      const updated = { conversations: [{ id: 'synthetic', title: 'After' }], messages: [] };
      store.save(original);
      ${body}
    `], { cwd, encoding: 'utf8' });
    assert.equal(child.status, 0, `Isolated child failed:\n${child.stdout}${child.stderr}`);
  } finally {
    rmSync(cwd, { recursive: true, force: true });
  }
}

test('healthy save roundtrips synthetic contents', () => {
  runIsolated(`store.save(updated); assert.deepEqual(store.get(), updated);`);
});

test('write failure propagates original filesystem error and preserves prior contents', () => {
  runIsolated(`
    const before = fs.readFileSync('data/conversations_store.json', 'utf8');
    fs.mkdirSync('data/conversations_store.json.tmp');
    let caught;
    try { store.save(updated); } catch (err) { caught = err; }
    assert.equal(fs.readFileSync('data/conversations_store.json', 'utf8'), before);
    assert.deepEqual(store.get(), original);
    assert.ok(caught, 'save must throw instead of reporting success');
    assert.equal(caught.code, 'EISDIR');
    assert.equal(caught.syscall, 'open');
    assert.ok(caught.path.endsWith('conversations_store.json.tmp'));
  `);
});

test('rename failure propagates original filesystem error', () => {
  runIsolated(`
    fs.unlinkSync('data/conversations_store.json');
    fs.mkdirSync('data/conversations_store.json');
    let caught;
    try { store.save(updated); } catch (err) { caught = err; }
    assert.ok(caught, 'save must throw when atomic rename fails');
    assert.equal(caught.code, 'EISDIR');
    assert.equal(caught.syscall, 'rename');
    assert.ok(caught.dest.endsWith('conversations_store.json'));
    assert.ok(fs.statSync('data/conversations_store.json').isDirectory());
  `);
});
