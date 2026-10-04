import { json } from '@sveltejs/kit';
import { normalizeConversationTitle } from '$lib/utils/conversation-title.js';
import { 
  getConversationById, 
  getMessagesByConversationId, 
  updateConversationTitle, 
  deleteConversation 
} from '$lib/db/conversations.js';

export async function GET({ params }) {
  try {
    const conv = getConversationById(params.id);
    if (!conv) {
      return json({ success: false, error: 'Conversation not found' }, { status: 404 });
    }
    const messages = getMessagesByConversationId(params.id);
    return json({ success: true, conversation: conv, messages });
  } catch (err) {
    return json({ success: false, error: err.message }, { status: 500 });
  }
}

export async function PATCH({ params, request }) {
  try {
    const body = await request.json();
    const title = normalizeConversationTitle(body.title);
    if (!title) {
      return json({ success: false, error: 'Title is required' }, { status: 400 });
    }
    const updated = updateConversationTitle(params.id, title);
    return json({ success: true, conversation: updated });
  } catch (err) {
    return json({ success: false, error: err.message }, { status: 500 });
  }
}

export async function DELETE({ params }) {
  try {
    deleteConversation(params.id);
    return json({ success: true });
  } catch (err) {
    return json({ success: false, error: err.message }, { status: 500 });
  }
}
