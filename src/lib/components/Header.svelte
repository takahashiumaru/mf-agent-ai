<script>
  import ThemeToggle from './ThemeToggle.svelte';
  import { PanelLeft, ChevronDown, Cpu } from '@lucide/svelte';
  import { AVAILABLE_MODELS, formatModelName } from '$lib/utils/model.js';

  let { 
    title = 'Percakapan Baru', 
    activeModel = 'codex-luna-6-low',
    onToggleSidebar = () => {},
    onSelectModel = () => {},
    isSidebarOpen = true
  } = $props();

  let showModelDropdown = $state(false);

  const models = AVAILABLE_MODELS;

  function getModelLabel(id) {
    return formatModelName(id);
  }
  function handleModelChange(id) {
    onSelectModel(id);
    showModelDropdown = false;
  }
</script>

<svelte:window onkeydown={(e) => { if (e.key === 'Escape') showModelDropdown = false; }} onclick={() => showModelDropdown = false} />

<header class="chat-header">
  <div class="header-left">
    <button class="icon-btn-toggle" onclick={onToggleSidebar} title="Buka/Tutup Sidebar" aria-label="Buka atau tutup sidebar" aria-expanded={isSidebarOpen} aria-controls="conversation-sidebar">
      <PanelLeft size={17} />
    </button>
    <div class="header-title-container">
      <span class="header-breadcrumb">Workspace <span>/</span></span><span class="header-title">{title}</span>
    </div>
  </div>

  <div class="header-right">
    <ThemeToggle />
    <!-- Model Selector Dropdown -->
    <div class="model-dropdown-container">
      <button 
        class="model-pill-btn" 
        onclick={(e) => { e.stopPropagation(); showModelDropdown = !showModelDropdown; }}
        aria-expanded={showModelDropdown}
        aria-controls="model-options"
        title="Pilih model AI"
      >
        
        <span class="model-name-text">{getModelLabel(activeModel)}</span>
        <ChevronDown size={12} class="chevron-icon {showModelDropdown ? 'open' : ''}" />
      </button>

      {#if showModelDropdown}
        <div class="dropdown-menu" id="model-options">
          <div class="dropdown-header">MODEL AGENT</div>
          {#each models as m}
            <button 
              class="dropdown-item {m.id === activeModel ? 'active' : ''}" 
              onclick={() => handleModelChange(m.id)}
            >
              <div class="item-main">
                <span class="item-name">{m.label}</span>
                <span class="item-speed">{m.speed}</span>
              </div>
              {#if m.id === activeModel}
                <div class="active-dot"></div>
              {/if}
            </button>
          {/each}
        </div>
      {/if}
    </div>
  </div>
</header>

<style>
  .chat-header {
    height: 52px;
    padding: 0 1.25rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-bottom: 1px solid var(--border-subtle);
    background: rgba(13, 15, 20, 0.85);
    backdrop-filter: blur(12px);
    z-index: 20;
    flex-shrink: 0;
  }

  .header-left {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    min-width: 0;
  }

  .icon-btn-toggle {
    width: 32px;
    height: 32px;
    border-radius: var(--radius-xs);
    color: var(--text-secondary);
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.15s ease;
  }

  .icon-btn-toggle:hover {
    color: var(--text-primary);
    background: var(--bg-surface-hover);
  }

  .header-title-container {
    min-width: 0;
  }

  .header-title {
    font-size: 13.5px;
    font-weight: 600;
    color: var(--text-primary);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    display: block;
    max-width: 320px;
  }

  .header-right {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    flex-shrink: 0;
  }

  /* Model Dropdown */
  .model-dropdown-container {
    position: relative;
  }

  .model-pill-btn {
    display: flex;
    align-items: center;
    gap: 0.35rem;
    background: var(--surface-tint);
    border: 1px solid var(--border-medium);
    padding: 0.3rem 0.65rem;
    border-radius: var(--radius-full);
    font-size: 12px;
    font-weight: 500;
    color: var(--text-primary);
    transition: all 0.15s ease;
  }

  .model-pill-btn:hover {
    background: var(--surface-tint-hover);
    border-color: var(--border-strong);
    color: var(--text-primary);
  }


  .model-name-text {
    white-space: nowrap;
  }

  :global(.chevron-icon) {
    color: var(--text-muted);
    transition: transform 0.2s ease;
  }

  :global(.chevron-icon.open) {
    transform: rotate(180deg);
  }

  .dropdown-menu {
    position: absolute;
    top: calc(100% + 6px);
    right: 0;
    width: 220px;
    background: var(--bg-surface);
    border: 1px solid var(--border-strong);
    border-radius: var(--radius-md);
    box-shadow: var(--shadow-lg);
    padding: 0.35rem;
    z-index: 30;
    animation: fadeIn 0.15s ease;
  }

  .dropdown-header {
    font-size: 10px;
    font-weight: 600;
    color: var(--text-muted);
    padding: 0.35rem 0.55rem 0.25rem 0.55rem;
    letter-spacing: 0.05em;
  }

  .dropdown-item {
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0.45rem 0.55rem;
    border-radius: var(--radius-xs);
    text-align: left;
    transition: background 0.12s ease;
  }

  .dropdown-item:hover {
    background: var(--surface-tint-hover);
  }

  .dropdown-item.active {
    background: rgba(66, 108, 178, 0.2);
  }

  .item-main {
    display: flex;
    flex-direction: column;
  }

  .item-name {
    font-size: 12.5px;
    font-weight: 500;
    color: var(--text-primary);
  }

  .item-speed {
    font-size: 10.5px;
    color: var(--text-muted);
  }

  .active-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: var(--accent-cyan);
  }

  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(-4px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .chat-header { height: 78px; padding: 0 32px; background: var(--bg-app); backdrop-filter: none; }
  .header-title-container { display: flex; align-items: center; gap: 15px; }
  .header-breadcrumb { display: flex; gap: 15px; color: var(--text-muted); font-size: 12px; }
  .header-breadcrumb > span { color: var(--text-dim); }
  .header-title { font-size: 12px; font-weight: 500; }
  .icon-btn-toggle { margin-right: 8px; width: 36px; height: 36px; }
  .model-pill-btn { border-radius: 8px; padding: 9px 12px; font-size: 11px; background: transparent; color: var(--text-secondary); }
  .dropdown-item { padding: 10px; }
  @media (max-width: 900px) { .header-breadcrumb { display: none; } .header-title { max-width: 160px; } }
  @media (max-width: 600px) { .chat-header { height: 62px; padding: 0 14px; gap: 8px; } .header-title { max-width: 110px; } .model-pill-btn { font-size: 10px; padding: 8px; } .icon-btn-toggle { margin-right: 0; } .header-left { gap: 5px; } }
  @media (max-width: 380px) { .header-title { max-width: 65px; } .header-right { gap: 5px; } .model-pill-btn { padding: 8px 5px; font-size: 9px; } }
</style>
