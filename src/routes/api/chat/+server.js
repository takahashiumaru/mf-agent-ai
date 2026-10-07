import { 
  getConversationById, 
  createConversation, 
  addMessage, 
  getMessagesByConversationId, 
  updateConversationTitle, 
  generateTitleFromPrompt 
} from '$lib/db/conversations.js';
import { runAgentStream } from '$lib/agent/runner.js';
import crypto from 'node:crypto';

export async function POST({ request }) {
  try {
    const { conversationId: rawConvId, message, model, project = 'visitflow' } = await request.json();

    if (!message || typeof message !== 'string' || message.trim().length === 0) {
      return new Response(JSON.stringify({ error: 'Message cannot be empty' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    const trimmedMessage = message.trim();
    let conversationId = rawConvId;
    let effectiveProject = project;
    let isNewConversation = false;

    // Ensure conversation exists
    if (!conversationId) {
      conversationId = crypto.randomUUID();
      createConversation(conversationId, 'Percakapan Baru', project);
      isNewConversation = true;
    } else {
      const existing = getConversationById(conversationId);
      if (!existing) {
        createConversation(conversationId, 'Percakapan Baru', project);
        isNewConversation = true;
      } else {
        // Continued chats inherit their persisted domain, not the caller's selection.
        effectiveProject = existing.project || 'visitflow';
      }
    }

    // Get previous messages before adding new user message
    const priorMessages = getMessagesByConversationId(conversationId);
    if (priorMessages.length === 0) {
      isNewConversation = true;
    }

    // Save user message
    const userMessageId = crypto.randomUUID();
    addMessage(userMessageId, conversationId, 'user', trimmedMessage);

    // Auto generate title if it's the first message
    let generatedTitle = null;
    if (isNewConversation || priorMessages.length === 0) {
      generatedTitle = generateTitleFromPrompt(trimmedMessage);
      updateConversationTitle(conversationId, generatedTitle);
    }

    // Setup SSE Stream
    const stream = new ReadableStream({
      async start(controller) {
        const encoder = new TextEncoder();
        
        let isClosed = false;
        function sendEvent(event, data) {
          if (isClosed) return;
          try {
            controller.enqueue(encoder.encode(`event: ${event}\ndata: ${JSON.stringify(data)}\n\n`));
          } catch (e) {
            isClosed = true;
          }
        }

        let fullAssistantText = '';
        let capturedSources = null;

        try {
          if (generatedTitle) {
            sendEvent('title', { conversationId, title: generatedTitle });
          }

          const agentStream = runAgentStream(trimmedMessage, priorMessages, {
            model: model || process.env.AGENT_MODEL || 'gemini-3.7-flash-low',
            project: effectiveProject,
            signal: request.signal
          });

          for await (const chunk of agentStream) {
            if (chunk.type === 'sources') {
              capturedSources = chunk.sources;
              sendEvent('sources', { sources: capturedSources });
            } else if (chunk.type === 'chunk') {
              fullAssistantText += chunk.text;
              sendEvent('delta', { text: chunk.text });
            } else if (chunk.type === 'error') {
              sendEvent('error', { error: chunk.text });
              fullAssistantText += `\n\n_${chunk.text}_`;
            }
          }

          // Save assistant message to SQLite
          const assistantMessageId = crypto.randomUUID();
          addMessage(
            assistantMessageId, 
            conversationId, 
            'assistant', 
            fullAssistantText, 
            capturedSources
          );

          sendEvent('done', {
            id: assistantMessageId,
            conversationId,
            sources: capturedSources
          });

          if (!isClosed) {
            isClosed = true;
            controller.close();
          }
        } catch (err) {
          console.error('[SSE Chat Stream Error]:', err);
          sendEvent('error', { error: err.message });
          if (!isClosed) {
            isClosed = true;
            controller.close();
          }
        }
      }
    });

    return new Response(stream, {
      headers: {
        'Content-Type': 'text/event-stream; charset=utf-8',
        'Cache-Control': 'no-cache, no-transform',
        'Connection': 'keep-alive',
        'X-Accel-Buffering': 'no'
      }
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
}
