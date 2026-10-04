import { json } from '@sveltejs/kit';
import { getConversations, createConversation, deleteAllConversations } from '$lib/db/conversations.js';
import crypto from 'node:crypto';

export async function GET({ url }) {
  try {
    const project = url.searchParams.get('project') || null;
    const list = getConversations(project);
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
    const project = body.project || 'visitflow';
    
    const conv = createConversation(id, title, project);
    return json({ success: true, conversation: conv });
  } catch (err) {
    return json({ success: false, error: err.message }, { status: 500 });
  }
}

export async function DELETE({ url }) {
  try {
    const project = url.searchParams.get('project') || null;
    deleteAllConversations(project);
    return json({ success: true, message: project ? `Conversations for ${project} cleared` : 'All conversations cleared' });
  } catch (err) {
    return json({ success: false, error: err.message }, { status: 500 });
  }
}
