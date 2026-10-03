import { json } from '@sveltejs/kit';
import { getConversations, createConversation, deleteAllConversations } from '$lib/db/conversations.js';
import crypto from 'node:crypto';

export async function GET() {
  try {
    const list = getConversations();
    return json({ success: true, conversations: list });
  } catch (err) {
    return json({ success: false, error: err.message }, { status: 500 });
  }
}

export async function POST({ request }) {
  try {
    const body = await request.json().catch(() => ({}));
    const id = body.id || crypto.randomUUID();
    const title = body.title || 'Percakapan Baru';
    
    const conv = createConversation(id, title);
    return json({ success: true, conversation: conv });
  } catch (err) {
    return json({ success: false, error: err.message }, { status: 500 });
  }
}

export async function DELETE() {
  try {
    deleteAllConversations();
    return json({ success: true, message: 'All conversations cleared' });
  } catch (err) {
    return json({ success: false, error: err.message }, { status: 500 });
  }
}
