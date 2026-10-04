<script>
  import { Sparkles, Copy, Check, Cpu } from '@lucide/svelte';
  import { renderMarkdown } from '$lib/utils/markdown.js';
  import { formatModelName } from '$lib/utils/model.js';
  import SourceBadge from './SourceBadge.svelte';
  import ChatVisualization from './ChatVisualization.svelte';
  import { parseAssistantContent } from '$lib/utils/visualizations.js';

  let { message, isStreaming = false, project = 'visitflow', model = '' } = $props();

  let copied = $state(false);

  function copyMessageContent() {
    if (!message.content) return;
    navigator.clipboard.writeText(message.content).then(() => {
      copied = true;
      setTimeout(() => { copied = false; }, 2000);
    });
  }

  function formatTime(dateStr) {
    if (!dateStr) return '';
    try {
      const d = new Date(dateStr);
      return d.toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' });
    } catch {
      return '';
    }
  }

  let isCompliance = $derived(project === 'ski-compliance');
  let modelLabel = $derived(formatModelName(message.model || model));
  let contentParts = $derived(
    message.role === 'assistant' ? parseAssistantContent(message.content) : []
  );
</script>

<div class="message-row {message.role}">
  {#if message.role === 'user'}
    <!-- User Bubble (Right-aligned, ChatGPT style) -->
    <div class="user-bubble-container">
      <div class="user-bubble">
        <div class="user-bubble-text">{message.content}</div>
      </div>
      <div class="user-footer">
        {#if message.created_at}
          <span class="user-time">{formatTime(message.created_at)}</span>
        {/if}
        {#if message.content}
          <button class="user-copy-btn" onclick={copyMessageContent} title="Salin pesan">
            {#if copied}
              <Check size={12} class="copied-icon" />
              <span>Tersalin</span>
            {:else}
              <Copy size={12} />
              <span>Salin</span>
            {/if}
          </button>
        {/if}
      </div>
    </div>
  {:else}
    <!-- Assistant Message (Spacious left-aligned layout) -->
    <div class="assistant-container">
      <div class="assistant-content">
        <div class="assistant-header">
          <span class="assistant-name">{isCompliance ? 'Ski Compliance AI' : 'VisitFlow AI'}</span>
          <span class="assistant-tag {isCompliance ? 'ski' : 'vf'}">Asisten</span>
          {#if modelLabel}
            <span class="model-tag {isCompliance ? 'ski' : 'vf'}" title="Model AI: {modelLabel}">
              <Cpu size={10.5} class="model-tag-icon" />
              <span>{modelLabel}</span>
            </span>
          {/if}
          {#if message.created_at}
            <span class="assistant-time">{formatTime(message.created_at)}</span>
          {/if}
        </div>

        {#if message.sources && message.sources.length > 0}
          <SourceBadge sources={message.sources} />
        {/if}

        {#each contentParts as part}
          {#if part.type === 'visualization'}
            <ChatVisualization chart={part.chart} />
          {:else}
            <div class="prose">{@html renderMarkdown(part.content)}</div>
          {/if}
        {/each}
        {#if isStreaming}<span class="streaming-cursor"></span>{/if}

        {#if !isStreaming && message.content}
          <div class="assistant-actions">
            <button class="action-btn" onclick={copyMessageContent} title="Salin seluruh jawaban">
              {#if copied}
                <Check size={13} class="copied-icon" />
                <span>Tersalin</span>
              {:else}
                <Copy size={13} />
                <span>Salin</span>
              {/if}
            </button>
          </div>
        {/if}
      </div>
    </div>
  {/if}
</div>

<style>
  .message-row {
    width: 100%;
    max-width: 860px;
    margin: 0 auto;
    padding: 0.75rem 1rem;
    display: flex;
    box-sizing: border-box;
  }

  @media (max-width: 640px) {
    .message-row {
      padding: 0.6rem 1rem;
    }
    .assistant-container {
      gap: 0;
    }
  }

  .message-row.user {
    justify-content: flex-end;
  }

  .message-row.assistant {
    justify-content: flex-start;
  }

  /* User Bubble Styling */
  .user-bubble-container {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    max-width: 78%;
  }

  .user-bubble {
    background: var(--bg-user-msg);
    color: var(--text-primary);
    padding: 0.75rem 1.1rem;
    border-radius: 18px 18px 4px 18px;
    border: 1px solid var(--border-medium);
    box-shadow: var(--shadow-sm);
    word-break: break-word;
  }

  .user-bubble-text {
    font-size: 15.5px;
    line-height: 1.58;
    white-space: pre-wrap;
  }

  .user-footer {
    display: flex;
    align-items: center;
    gap: 0.45rem;
    margin-top: 0.3rem;
    margin-right: 0.25rem;
    opacity: 0.75;
    transition: opacity 0.15s ease;
  }

  .user-footer:hover {
    opacity: 1;
  }

  .user-time {
    font-size: 11px;
    color: var(--text-dim);
  }

  .user-copy-btn {
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
    padding: 0.15rem 0.45rem;
    border-radius: var(--radius-xs);
    font-size: 11px;
    color: var(--text-muted);
    background: var(--surface-tint);
    border: 1px solid var(--border-subtle);
    transition: all 0.15s ease;
    cursor: pointer;
  }

  .user-copy-btn:hover {
    color: var(--text-primary);
    background: var(--surface-tint-hover);
  }
  /* Assistant Layout */
  .assistant-container {
    display: flex;
    gap: 0.9rem;
    width: 100%;
    align-items: flex-start;
  }

  .assistant-avatar {
    width: 30px;
    height: 30px;
    border-radius: var(--radius-sm);
    background: rgba(66, 108, 178, 0.15);
    border: 1px solid rgba(58, 194, 219, 0.35);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    margin-top: 2px;
    box-shadow: 0 2px 10px rgba(66, 108, 178, 0.2);
  }

  .avatar-logo-img {
    width: 20px;
    height: 20px;
    object-fit: contain;
  }

  .assistant-content {
    flex: 1;
    min-width: 0;
  }

  .assistant-header {
    display: flex;
    align-items: center;
    gap: 0.45rem;
    margin-bottom: 0.35rem;
  }

  .assistant-name {
    font-size: 13.5px;
    font-weight: 600;
    color: var(--text-primary);
  }

  .assistant-tag {
    font-size: 10px;
    padding: 0.05rem 0.35rem;
    background: rgba(66, 108, 178, 0.15);
    border: 1px solid rgba(58, 194, 219, 0.3);
    border-radius: 4px;
    color: var(--accent-primary);
    font-weight: 600;
    text-transform: uppercase;
  }

  .assistant-tag.ski {
    background: rgba(37, 99, 235, 0.15);
    border-color: rgba(56, 189, 248, 0.35);
    color: #38bdf8;
  }

  .model-tag {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    font-size: 10px;
    font-weight: 600;
    font-family: var(--font-mono);
    color: var(--text-muted);
    background: var(--surface-tint);
    border: 1px solid var(--border-subtle);
    padding: 0.08rem 0.4rem;
    border-radius: 4px;
    letter-spacing: 0.01em;
  }

  .model-tag.ski {
    border-color: rgba(56, 189, 248, 0.2);
  }

  :global(.model-tag-icon) {
    color: var(--accent-primary);
    opacity: 0.85;
  }

  .assistant-time {
    font-size: 11px;
    color: var(--text-dim);
    margin-left: 0.2rem;
  }

  .assistant-actions {
    display: flex;
    align-items: center;
    gap: 0.4rem;
    margin-top: 0.6rem;
    opacity: 0.7;
    transition: opacity 0.15s ease;
  }

  .assistant-actions:hover {
    opacity: 1;
  }

  .action-btn {
    display: inline-flex;
    align-items: center;
    gap: 0.3rem;
    padding: 0.25rem 0.55rem;
    border-radius: var(--radius-xs);
    font-size: 11.5px;
    color: var(--text-muted);
    background: var(--surface-tint);
    border: 1px solid var(--border-subtle);
    transition: all 0.15s ease;
  }

  .action-btn:hover {
    color: var(--text-primary);
    background: var(--surface-tint-hover);
  }

  :global(.copied-icon) {
    color: var(--accent-emerald);
  }

  .message-row { animation: message-enter 350ms ease both; padding-top: 18px; padding-bottom: 18px; }
  .assistant-avatar { color: #29361f; }
  .assistant-tag { font-size: 9px; letter-spacing: .03em; }
</style>
