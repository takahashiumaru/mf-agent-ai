import { getDb } from './client.js';

export function createConversation(id, title = 'Percakapan Baru') {
  const db = getDb();
  const now = new Date().toISOString();
  const stmt = db.prepare(`
    INSERT INTO conversations (id, title, created_at, updated_at)
    VALUES (?, ?, ?, ?)
  `);
  stmt.run(id, title, now, now);
  return { id, title, created_at: now, updated_at: now };
}

export function getConversations() {
  const db = getDb();
  const stmt = db.prepare(`
    SELECT c.*, 
      (SELECT content FROM messages WHERE conversation_id = c.id ORDER BY created_at ASC LIMIT 1) as first_message,
      (SELECT COUNT(*) FROM messages WHERE conversation_id = c.id) as message_count
    FROM conversations c
    ORDER BY updated_at DESC
  `);
  return stmt.all();
}

export function getConversationById(id) {
  const db = getDb();
  const stmt = db.prepare('SELECT * FROM conversations WHERE id = ?');
  const conv = stmt.all(id)[0];
  if (!conv) return null;
  return conv;
}

export function updateConversationTitle(id, title) {
  const db = getDb();
  const now = new Date().toISOString();
  const stmt = db.prepare(`
    UPDATE conversations 
    SET title = ?, updated_at = ?
    WHERE id = ?
  `);
  stmt.run(title, now, id);
  return { id, title, updated_at: now };
}

export function touchConversation(id) {
  const db = getDb();
  const now = new Date().toISOString();
  const stmt = db.prepare(`
    UPDATE conversations 
    SET updated_at = ?
    WHERE id = ?
  `);
  stmt.run(now, id);
}

export function deleteConversation(id) {
  const db = getDb();
  const stmt = db.prepare('DELETE FROM conversations WHERE id = ?');
  stmt.run(id);
  return { success: true };
}

export function deleteAllConversations() {
  const db = getDb();
  db.prepare('DELETE FROM messages').run();
  db.prepare('DELETE FROM conversations').run();
  return { success: true };
}

export function addMessage(id, conversationId, role, content, sources = null) {
  const db = getDb();
  const now = new Date().toISOString();
  const sourcesJson = sources ? JSON.stringify(sources) : null;
  
  const stmt = db.prepare(`
    INSERT INTO messages (id, conversation_id, role, content, sources, created_at)
    VALUES (?, ?, ?, ?, ?, ?)
  `);
  stmt.run(id, conversationId, role, content, sourcesJson, now);
  
  touchConversation(conversationId);
  
  return {
    id,
    conversation_id: conversationId,
    role,
    content,
    sources,
    created_at: now
  };
}

export function getMessagesByConversationId(conversationId) {
  const db = getDb();
  const stmt = db.prepare(`
    SELECT * FROM messages 
    WHERE conversation_id = ? 
    ORDER BY created_at ASC, rowid ASC
  `);
  const rows = stmt.all(conversationId);
  return rows.map(row => {
    let parsedSources = null;
    if (row.sources) {
      try {
        parsedSources = JSON.parse(row.sources);
      } catch (e) {
        parsedSources = null;
      }
    }
    return {
      ...row,
      sources: parsedSources
    };
  });
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
