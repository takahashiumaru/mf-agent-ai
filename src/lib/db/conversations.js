import { getDbStore } from './client.js';

export function createConversation(id, title = 'Percakapan Baru') {
  const store = getDbStore();
  const data = store.get();
  const now = new Date().toISOString();
  
  const newConv = { id, title, created_at: now, updated_at: now };
  data.conversations = data.conversations || [];
  data.conversations.push(newConv);
  store.save(data);
  return newConv;
}

export function getConversations() {
  const store = getDbStore();
  const data = store.get();
  const conversations = data.conversations || [];
  const messages = data.messages || [];

  return conversations
    .map(c => {
      const msgs = messages.filter(m => m.conversation_id === c.id);
      const sorted = [...msgs].sort((a, b) => a.created_at.localeCompare(b.created_at));
      const firstMsg = sorted[0];
      return {
        ...c,
        first_message: firstMsg ? firstMsg.content : '',
        message_count: msgs.length
      };
    })
    .sort((a, b) => b.updated_at.localeCompare(a.updated_at));
}

export function getConversationById(id) {
  const store = getDbStore();
  const data = store.get();
  const conversations = data.conversations || [];
  return conversations.find(c => c.id === id) || null;
}

export function updateConversationTitle(id, title) {
  const store = getDbStore();
  const data = store.get();
  const now = new Date().toISOString();
  const conversations = data.conversations || [];
  
  const conv = conversations.find(c => c.id === id);
  if (conv) {
    conv.title = title;
    conv.updated_at = now;
    store.save(data);
    return { id, title, updated_at: now };
  }
  return null;
}

export function touchConversation(id) {
  const store = getDbStore();
  const data = store.get();
  const now = new Date().toISOString();
  const conversations = data.conversations || [];
  
  const conv = conversations.find(c => c.id === id);
  if (conv) {
    conv.updated_at = now;
    store.save(data);
  }
}

export function deleteConversation(id) {
  const store = getDbStore();
  const data = store.get();
  
  data.conversations = (data.conversations || []).filter(c => c.id !== id);
  data.messages = (data.messages || []).filter(m => m.conversation_id !== id);
  store.save(data);
  return { success: true };
}

export function deleteAllConversations() {
  const store = getDbStore();
  const data = { conversations: [], messages: [] };
  store.save(data);
  return { success: true };
}

export function addMessage(id, conversationId, role, content, sources = null) {
  const store = getDbStore();
  const data = store.get();
  const now = new Date().toISOString();

  data.conversations = data.conversations || [];
  data.messages = data.messages || [];

  const msg = {
    id,
    conversation_id: conversationId,
    role,
    content,
    sources: sources || null,
    created_at: now
  };

  data.messages.push(msg);
  
  // Touch conversation updated_at
  const conv = data.conversations.find(c => c.id === conversationId);
  if (conv) {
    conv.updated_at = now;
  }

  store.save(data);
  return msg;
}

export function getMessagesByConversationId(conversationId) {
  const store = getDbStore();
  const data = store.get();
  const messages = data.messages || [];
  
  return messages
    .filter(m => m.conversation_id === conversationId)
    .sort((a, b) => a.created_at.localeCompare(b.created_at));
}

/**
 * Cleanly generates a concise conversation title from the initial user prompt.
 */
export function generateTitleFromPrompt(prompt) {
  if (!prompt) return 'Percakapan Baru';
  // Strip special markdown/newlines
  let clean = prompt.replace(/[#*`_>\[\]]/g, ' ').replace(/\s+/g, ' ').trim();
  if (clean.length === 0) return 'Percakapan Baru';
  
  // Truncate to first sentence or 40 characters
  const firstSentence = clean.split(/[.?!]/)[0].trim();
  if (firstSentence.length > 40) {
    return firstSentence.substring(0, 37) + '...';
  }
  return firstSentence || clean.substring(0, 40);
}
