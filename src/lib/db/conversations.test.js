import { test, describe, beforeEach } from 'node:test';
import assert from 'node:assert/strict';
import { 
  createConversation, 
  getConversations, 
  getConversationById, 
  updateConversationTitle,
  deleteAllConversations 
} from './conversations.js';
import { getDbStore } from './client.js';

describe('Database Project Isolation & Conversation Scoping', () => {
  beforeEach(() => {
    deleteAllConversations();
  });

  test('createConversation assigns project and defaults to visitflow', () => {
    const c1 = createConversation('c-vf-1', 'VisitFlow Chat', 'visitflow');
    assert.equal(c1.project, 'visitflow');

    const c2 = createConversation('c-ski-1', 'Ski Chat', 'ski-compliance');
    assert.equal(c2.project, 'ski-compliance');

    const c3 = createConversation('c-default', 'Default Chat');
    assert.equal(c3.project, 'visitflow');
  });

  test('getConversations filters by project while maintaining backward compatibility', () => {
    createConversation('c1', 'VF Chat 1', 'visitflow');
    createConversation('c2', 'VF Chat 2', 'visitflow');
    createConversation('c3', 'SKI Chat 1', 'ski-compliance');

    const all = getConversations();
    assert.equal(all.length, 3);

    const vfOnly = getConversations('visitflow');
    assert.equal(vfOnly.length, 2);
    assert.ok(vfOnly.every(c => c.project === 'visitflow'));

    const skiOnly = getConversations('ski-compliance');
    assert.equal(skiOnly.length, 1);
    assert.equal(skiOnly[0].id, 'c3');
    assert.equal(skiOnly[0].project, 'ski-compliance');
  });

  test('deleteAllConversations can selectively clear by project or clear all', () => {
    createConversation('c1', 'VF Chat 1', 'visitflow');
    createConversation('c2', 'SKI Chat 1', 'ski-compliance');

    deleteAllConversations('visitflow');
    assert.equal(getConversations('visitflow').length, 0);
    assert.equal(getConversations('ski-compliance').length, 1);

    deleteAllConversations();
    assert.equal(getConversations().length, 0);
  });
});
