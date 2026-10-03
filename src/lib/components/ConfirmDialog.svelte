<script>
  import { onMount } from 'svelte';
  import { Trash2, AlertTriangle, X } from '@lucide/svelte';

  let {
    isOpen = false,
    title = 'Hapus percakapan?',
    description = 'Percakapan ini akan dihapus secara permanen dari database SQLite. Tindakan ini tidak dapat dibatalkan.',
    confirmLabel = 'Hapus',
    cancelLabel = 'Batal',
    isDestructive = true,
    onConfirm = () => {},
    onCancel = () => {}
  } = $props();

  let confirmBtnEl = $state(null);

  function handleKeydown(e) {
    if (!isOpen) return;
    if (e.key === 'Escape') {
      e.preventDefault();
      onCancel();
    }
  }

  $effect(() => {
    if (isOpen) {
      setTimeout(() => {
        if (confirmBtnEl) confirmBtnEl.focus();
      }, 50);
    }
  });
</script>

<svelte:window onkeydown={handleKeydown} />

{#if isOpen}
  <!-- Backdrop -->
  <div 
    class="modal-backdrop" 
    onclick={onCancel}
    role="presentation"
  >
    <!-- Modal Card -->
    <!-- svelte-ignore a11y_click_events_have_key_events -->
    <!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
    <div 
      class="modal-card" 
      onclick={(e) => e.stopPropagation()}
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
      tabindex="-1"
    >
      <div class="modal-header">
        <div class="modal-icon-wrapper {isDestructive ? 'destructive' : ''}">
          {#if isDestructive}
            <Trash2 size={18} />
          {:else}
            <AlertTriangle size={18} />
          {/if}
        </div>
        <div class="modal-header-text">
          <h3 id="modal-title" class="modal-title">{title}</h3>
          <p class="modal-description">{description}</p>
        </div>
        <button class="modal-close-btn" onclick={onCancel} aria-label="Tutup dialog">
          <X size={15} />
        </button>
      </div>

      <div class="modal-actions">
        <button class="btn-cancel" onclick={onCancel}>
          {cancelLabel}
        </button>
        <button 
          bind:this={confirmBtnEl}
          class="btn-confirm {isDestructive ? 'destructive' : ''}" 
          onclick={onConfirm}
        >
          {confirmLabel}
        </button>
      </div>
    </div>
  </div>
{/if}

<style>
  .modal-backdrop {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.7);
    backdrop-filter: blur(8px);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 90;
    padding: 1.25rem;
    animation: fadeIn 0.15s ease-out;
  }

  .modal-card {
    background: var(--bg-surface);
    border: 1px solid var(--border-medium);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-lg);
    width: 100%;
    max-width: 440px;
    padding: 1.5rem;
    animation: scaleUp 0.18s cubic-bezier(0.16, 1, 0.3, 1);
  }

  .modal-header {
    display: flex;
    align-items: flex-start;
    gap: 1rem;
    position: relative;
  }

  .modal-icon-wrapper {
    width: 38px;
    height: 38px;
    border-radius: var(--radius-md);
    background: rgba(166, 190, 121, 0.1);
    color: var(--accent-primary);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }

  .modal-icon-wrapper.destructive {
    background: rgba(244, 63, 94, 0.12);
    color: var(--danger-text);
  }

  .modal-header-text {
    flex: 1;
    min-width: 0;
  }

  .modal-title {
    font-size: 15.5px;
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 0.35rem;
  }

  .modal-description {
    font-size: 13.5px;
    color: var(--text-secondary);
    line-height: 1.5;
  }

  .modal-close-btn {
    position: absolute;
    top: -4px;
    right: -4px;
    color: var(--text-muted);
    padding: 4px;
    border-radius: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.15s ease;
  }

  .modal-close-btn:hover {
    color: var(--text-primary);
    background: var(--surface-tint-hover);
  }

  .modal-actions {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 0.6rem;
    margin-top: 1.5rem;
  }

  .btn-cancel {
    padding: 0.55rem 1rem;
    border-radius: var(--radius-sm);
    font-size: 13px;
    font-weight: 500;
    color: var(--text-secondary);
    background: var(--surface-tint);
    border: 1px solid var(--border-subtle);
    transition: all 0.15s ease;
  }

  .btn-cancel:hover {
    color: var(--text-primary);
    background: var(--surface-tint-hover);
    border-color: var(--border-medium);
  }

  .btn-confirm {
    padding: 0.55rem 1.1rem;
    border-radius: var(--radius-sm);
    font-size: 13px;
    font-weight: 600;
    color: #ffffff;
    background: linear-gradient(135deg, #426cb2, #3ac2db);
    transition: all 0.15s ease;
  }

  .btn-confirm:hover {
    background: linear-gradient(135deg, #4d7cc9, #4ecce4);
    box-shadow: 0 4px 14px rgba(58, 194, 219, 0.35);
  }

  .btn-confirm.destructive {
    background: #e11d48;
    color: #fff;
  }

  .btn-confirm.destructive:hover {
    background: #be123c;
  }

  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }

  @keyframes scaleUp {
    from { opacity: 0; transform: scale(0.95); }
    to { opacity: 1; transform: scale(1); }
  }
</style>
