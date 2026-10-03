<script>
  import { ArrowUp, Square } from '@lucide/svelte';

  let { 
    value = $bindable(''), 
    isStreaming = false, 
    project = 'visitflow',
    onSend = () => {}, 
    onStop = () => {} 
  } = $props();

  let textareaEl = $state(null);

  function adjustHeight() {
    if (!textareaEl) return;
    textareaEl.style.height = 'auto';
    const newHeight = Math.min(textareaEl.scrollHeight, 180);
    textareaEl.style.height = `${newHeight}px`;
  }

  function handleInput() {
    adjustHeight();
  }

  function handleKeyDown(e) {
    if (e.key === 'Enter' && !e.shiftKey && !e.isComposing) {
      e.preventDefault();
      if (!isStreaming && value.trim()) {
        handleSubmit();
      }
    }
  }

  function handleSubmit() {
    if (isStreaming) {
      onStop();
      return;
    }
    if (!value.trim()) return;
    onSend(value);
    value = '';
    if (textareaEl) {
      setTimeout(() => {
        textareaEl.style.height = 'auto';
      }, 0);
    }
  }

  $effect(() => {
    if (value === '' && textareaEl) {
      textareaEl.style.height = 'auto';
    }
  });

  let isCompliance = $derived(project === 'ski-compliance');
</script>

<div class="chat-input-wrapper">
  <div class="input-card">
    <textarea
      bind:this={textareaEl}
      bind:value={value}
      oninput={handleInput}
      onkeydown={handleKeyDown}
      placeholder={isCompliance ? 'Tanyakan kesepakatan dokter (SKI), sales FF, SPC, bridging...' : 'Tanyakan seputar call kunjungan, MCL, jadwal, profil dokter...'}
      aria-label={isCompliance ? 'Pertanyaan untuk Ski Compliance AI' : 'Pertanyaan untuk VisitFlow AI'}
      rows="1"
      disabled={isStreaming}
    ></textarea>

    <div class="input-actions">
      <span class="enter-hint">Enter ↵</span>
      {#if isStreaming}
        <button 
          class="send-circle-btn stop" 
          onclick={onStop} 
          title="Hentikan pembuatan respon"
        >
          <Square size={13} fill="currentColor" />
        </button>
      {:else}
        <button 
          class="send-circle-btn {isCompliance ? 'ski' : 'vf'}" 
          disabled={!value.trim()} 
          onclick={handleSubmit} 
          title="Kirim (Enter)"
        >
          <ArrowUp size={16} />
        </button>
      {/if}
    </div>
  </div>
  <div class="input-disclaimer">
    {isCompliance 
      ? 'Ski Compliance AI menjawab berdasarkan kesepakatan dokter (SKI), sales FF, SPC (Credit Notes), dan database SKI.' 
      : 'VisitFlow AI menjawab berdasarkan dokumentasi dan data kunjungan lapangan (call, MCL & dokter).'}
  </div>
</div>

<style>
  .chat-input-wrapper {
    width: 100%;
    max-width: 860px;
    margin: 0 auto;
    padding: 0 24px 16px;
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .input-card {
    width: 100%;
    min-height: 52px;
    background: var(--composer-fill);
    border: 1px solid var(--border-medium);
    border-radius: 14px;
    padding: 8px 10px 8px 16px;
    display: flex;
    align-items: center;
    gap: 10px;
    box-shadow: var(--composer-shadow);
    transition: border-color 0.2s cubic-bezier(0.16, 1, 0.3, 1), box-shadow 0.2s cubic-bezier(0.16, 1, 0.3, 1);
  }

  .input-card:focus-within {
    border-color: var(--border-focus);
    box-shadow: 0 0 0 3px rgba(66, 108, 178, 0.18), var(--shadow-md);
  }

  textarea {
    flex: 1;
    min-width: 0;
    background: transparent;
    border: none;
    outline: none;
    color: var(--text-primary);
    font-family: var(--font-sans);
    font-size: 14px;
    line-height: 1.45;
    resize: none;
    max-height: 160px;
    padding: 4px 0;
    margin: 0;
  }

  textarea::placeholder {
    color: var(--text-muted);
  }

  textarea:disabled {
    opacity: 0.6;
  }

  .input-actions {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-shrink: 0;
  }

  .enter-hint {
    color: var(--text-dim);
    font: 11px var(--font-mono);
    user-select: none;
  }

  .send-circle-btn {
    width: 34px;
    height: 34px;
    border-radius: 10px;
    background: linear-gradient(135deg, #426cb2, #3ac2db);
    color: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    border: none;
    cursor: pointer;
    transition: all 0.15s ease;
    flex-shrink: 0;
  }

  .send-circle-btn.ski {
    background: linear-gradient(135deg, #1d4ed8, #38bdf8);
  }

  .send-circle-btn:hover:not(:disabled) {
    background: linear-gradient(135deg, #4d7cc9, #4ecce4);
    box-shadow: 0 2px 10px rgba(58, 194, 219, 0.35);
    transform: translateY(-1px);
  }

  .send-circle-btn.ski:hover:not(:disabled) {
    background: linear-gradient(135deg, #2563eb, #60a5fa);
    box-shadow: 0 2px 10px rgba(56, 189, 248, 0.4);
  }

  .send-circle-btn:active:not(:disabled) {
    transform: translateY(0);
  }

  .send-circle-btn:disabled {
    background: var(--surface-tint-hover);
    color: var(--text-muted);
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
  }

  .send-circle-btn.stop {
    background: #e11d48;
    color: #fff;
  }

  .input-disclaimer {
    margin-top: 8px;
    font-size: 11px;
    color: var(--text-dim);
    text-align: center;
    letter-spacing: -0.01em;
  }

  @media (max-width: 1100px) {
    .chat-input-wrapper {
      padding-left: 20px;
      padding-right: 20px;
    }
  }

  @media (max-width: 600px) {
    .chat-input-wrapper {
      padding: 0 12px max(10px, env(safe-area-inset-bottom));
    }
    .input-card {
      min-height: 46px;
      padding: 6px 8px 6px 12px;
      border-radius: 12px;
    }
    .enter-hint {
      display: none;
    }
    textarea {
      font-size: 13.5px;
    }
    .send-circle-btn {
      width: 32px;
      height: 32px;
    }
    .input-disclaimer {
      font-size: 10px;
    }
  }
</style>
