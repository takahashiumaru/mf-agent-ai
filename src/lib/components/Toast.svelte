<script>
  import { toast } from '$lib/stores/toast.js';
  import { CheckCircle2, AlertCircle, Info, X } from '@lucide/svelte';

  function getIcon(type) {
    if (type === 'success') return CheckCircle2;
    if (type === 'error') return AlertCircle;
    return Info;
  }
</script>

<div class="toast-viewport" aria-live="polite">
  {#each $toast as item (item.id)}
    {@const Icon = getIcon(item.type)}
    <div class="toast-item {item.type}">
      <Icon size={16} class="toast-icon {item.type}" />
      <span class="toast-message">{item.message}</span>
      <button 
        class="toast-close" 
        onclick={() => toast.dismiss(item.id)}
        aria-label="Tutup notifikasi"
      >
        <X size={13} />
      </button>
    </div>
  {/each}
</div>

<style>
  .toast-viewport {
    position: fixed;
    bottom: 24px;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    flex-direction: column;
    gap: 8px;
    z-index: 100;
    pointer-events: none;
  }

  .toast-item {
    pointer-events: auto;
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 14px;
    background: var(--bg-surface);
    border: 1px solid var(--border-medium);
    border-radius: var(--radius-md);
    box-shadow: var(--shadow-lg);
    color: var(--text-primary);
    font-size: 13px;
    font-weight: 500;
    animation: toastSlideUp 0.2s cubic-bezier(0.16, 1, 0.3, 1);
    backdrop-filter: blur(12px);
    min-width: 240px;
    max-width: 420px;
  }

  :global(.toast-icon.success) {
    color: var(--accent-emerald);
  }
  :global(.toast-icon.error) {
    color: var(--accent-rose);
  }
  :global(.toast-icon.info) {
    color: var(--accent-blue);
  }

  .toast-message {
    flex: 1;
    line-height: 1.4;
  }

  .toast-close {
    color: var(--text-muted);
    padding: 2px;
    border-radius: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.15s ease;
  }

  .toast-close:hover {
    color: var(--text-primary);
    background: var(--surface-tint-hover);
  }

  @keyframes toastSlideUp {
    from {
      opacity: 0;
      transform: translateY(12px) scale(0.96);
    }
    to {
      opacity: 1;
      transform: translateY(0) scale(1);
    }
  }
</style>
