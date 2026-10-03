<script>
  import { 
    Plus, 
    MoreHorizontal, 
    Trash2, 
    Edit2, 
    Search, 
    X, 
    Zap, 
    Sparkles,
    PanelLeftClose,
    ShieldCheck,
    ChevronsUpDown,
    Check
  } from '@lucide/svelte';

  let { 
    conversations = [], 
    activeId = null, 
    isOpen = true,
    activeModel = 'gemini-3.7-flash-low',
    activeProject = 'visitflow',
    onSelectProject = () => {},
    onSelectConversation = () => {}, 
    onNewChat = () => {}, 
    onRequestDelete = () => {},
    onRequestDeleteAll = () => {},
    onRequestRename = () => {},
    onCloseMobile = () => {}
  } = $props();

  let searchQuery = $state('');
  let openMenuId = $state(null);
  let isProjectMenuOpen = $state(false);

  const projects = [
    {
      id: 'visitflow',
      name: 'VisitFlow',
      subtitle: 'AI ASSISTANT',
      env: 'PROD',
      desc: 'Kunjungan Dokter (Call), MCL & Operasional'
    },
    {
      id: 'ski-compliance',
      name: 'Ski Compliance',
      subtitle: 'AI ASSISTANT',
      env: 'PROD',
      desc: 'Kesepakatan Dokter, Sales FF & Credit Notes'
    }
  ];

  let currentProject = $derived(
    projects.find(p => p.id === activeProject) || projects[0]
  );

  function toggleMenu(id, e) {
    e.stopPropagation();
    openMenuId = openMenuId === id ? null : id;
  }

  function handleStartRename(conv, e) {
    e.stopPropagation();
    openMenuId = null;
    onRequestRename(conv);
  }

  function handleStartDelete(conv, e) {
    e.stopPropagation();
    openMenuId = null;
    onRequestDelete(conv);
  }

  function handleSelectProject(projId) {
    onSelectProject(projId);
    isProjectMenuOpen = false;
  }

  // Close context menu and project dropdown on outside click
  function handleWindowClick() {
    openMenuId = null;
    isProjectMenuOpen = false;
  }

  let filteredConversations = $derived(
    conversations.filter(c => 
      c.title.toLowerCase().includes(searchQuery.toLowerCase())
    )
  );

  function groupConversations(list) {
    const today = [];
    const yesterday = [];
    const last7Days = [];
    const last30Days = [];
    const older = [];

    const now = new Date();
    const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime();
    const startOfYesterday = startOfToday - 86400000;
    const startOf7Days = startOfToday - (7 * 86400000);
    const startOf30Days = startOfToday - (30 * 86400000);

    for (const c of list) {
      const time = new Date(c.updated_at || c.created_at).getTime();
      if (time >= startOfToday) {
        today.push(c);
      } else if (time >= startOfYesterday) {
        yesterday.push(c);
      } else if (time >= startOf7Days) {
        last7Days.push(c);
      } else if (time >= startOf30Days) {
        last30Days.push(c);
      } else {
        older.push(c);
      }
    }

    return [
      { label: 'Hari Ini', items: today },
      { label: 'Kemarin', items: yesterday },
      { label: '7 Hari Terakhir', items: last7Days },
      { label: '30 Hari Terakhir', items: last30Days },
      { label: 'Terdahulu', items: older }
    ].filter(g => g.items.length > 0);
  }

  let grouped = $derived(groupConversations(filteredConversations));
</script>

<svelte:window onclick={handleWindowClick} />

{#if isOpen}
  <button 
    class="mobile-backdrop" 
    onclick={onCloseMobile} 
    aria-label="Tutup menu sidebar"
  ></button>
{/if}

<aside id="conversation-sidebar" class="sidebar {isOpen ? 'open' : 'closed'}" inert={!isOpen} aria-label="Riwayat percakapan">
  <!-- Top Branding Header with Project Switcher -->
  <div class="sidebar-header">
    <div class="project-switcher-wrapper">
      <button 
        class="logo-area project-trigger-btn"
        onclick={(e) => { e.stopPropagation(); isProjectMenuOpen = !isProjectMenuOpen; }}
        aria-expanded={isProjectMenuOpen}
        aria-haspopup="true"
        title="Ganti project ({currentProject.name})"
      >
        <div class="brand-logo-frame">
          {#if currentProject.id === 'visitflow'}
            <img src="/logo.svg" alt="VisitFlow" class="brand-logo-img" />
          {:else}
            <img src="/ski.png" alt="Ski Compliance" class="brand-logo-img" />
          {/if}
        </div>
        <div class="logo-text-wrapper">
          <span class="logo-title">{currentProject.name}</span>
          <span class="logo-subtitle">{currentProject.subtitle}</span>
        </div>
        <div class="logo-badge-group">
          <span class="logo-badge-subtle {currentProject.id}">{currentProject.env}</span>
          <ChevronsUpDown size={13} class="project-switch-chevron" />
        </div>
      </button>

      {#if isProjectMenuOpen}
        <div class="project-dropdown-menu" role="menu" aria-label="Daftar Project">
          <div class="project-dropdown-header">SWITCH PROJECT</div>
          {#each projects as proj}
            <button 
              role="menuitem"
              class="project-option {proj.id === activeProject ? 'active' : ''}"
              onclick={() => handleSelectProject(proj.id)}
            >
              <div class="proj-icon-frame">
                {#if proj.id === 'visitflow'}
                  <img src="/logo.svg" alt={proj.name} class="proj-thumb-img" />
                {:else}
                  <img src="/ski.png" alt={proj.name} class="proj-thumb-img" />
                {/if}
              </div>
              <div class="proj-info">
                <div class="proj-name-line">
                  <span class="proj-name">{proj.name}</span>
                  <span class="proj-tag">{proj.env}</span>
                </div>
                <span class="proj-desc">{proj.desc}</span>
              </div>
              {#if proj.id === activeProject}
                <Check size={14} class="proj-check" />
              {/if}
            </button>
          {/each}
        </div>
      {/if}
    </div>
    
    <button class="close-sidebar-btn" onclick={onCloseMobile} aria-label="Tutup sidebar">
      <PanelLeftClose size={16} />
    </button>
  </div>

  <!-- New Chat Action -->
  <div class="new-chat-container">
    <button class="new-chat-btn" onclick={onNewChat}>
      <Plus size={14} />
      <span>New Chat</span>
      <span class="kbd-shortcut">⌘K</span>
    </button>
  </div>

  <!-- Search Filter -->
  <div class="search-container">
    <Search size={13} class="search-icon" />
    <input 
      type="text" 
      bind:value={searchQuery} 
      placeholder="Cari percakapan..."
      aria-label="Cari percakapan" 
      class="search-input"
    />
    {#if searchQuery}
      <button class="clear-search-btn" onclick={() => searchQuery = ''} aria-label="Hapus pencarian">
        <X size={12} />
      </button>
    {/if}
  </div>

  <!-- Conversation History List (Clean, No noisy icons) -->
  <div class="history-heading">
    <div class="heading-left">
      <span>Percakapan</span>
      <span class="count-badge">{conversations.length}</span>
    </div>
    {#if conversations.length > 0}
      <button 
        class="clear-all-btn" 
        onclick={() => onRequestDeleteAll()}
        title="Hapus semua percakapan"
        aria-label="Hapus semua percakapan"
      >
        <Trash2 size={11} />
        <span>Clear All</span>
      </button>
    {/if}
  </div>
  <div class="history-list">
    {#if filteredConversations.length === 0}
      <div class="empty-history">
        <span>{searchQuery ? 'Tidak ada hasil pencarian' : 'Ruang untuk ide berikutnya.'}</span>
        <p>{searchQuery ? 'Coba kata kunci lain.' : 'Mulai chat baru. Riwayat percakapanmu akan muncul di sini.'}</p>
      </div>
    {:else}
      {#each grouped as group}
        <div class="history-group">
          <div class="group-label">{group.label}</div>
          {#each group.items as conv}
            <div 
              class="history-item {conv.id === activeId ? 'active' : ''}"
              onclick={() => onSelectConversation(conv.id)}
              role="button"
              tabindex="0"
              onkeydown={(e) => e.key === 'Enter' && onSelectConversation(conv.id)}
            >
              <span class="item-title" title={conv.title}>{conv.title}</span>

              <!-- Hover Menu Button -->
              <div class="item-menu-container">
                <button 
                  class="more-btn {openMenuId === conv.id ? 'active' : ''}" 
                  onclick={(e) => toggleMenu(conv.id, e)} 
                  aria-label="Opsi percakapan"
                >
                  <MoreHorizontal size={14} />
                </button>

                {#if openMenuId === conv.id}
                  <!-- svelte-ignore a11y_click_events_have_key_events -->
                  <!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
                  <div class="context-dropdown" onclick={(e) => e.stopPropagation()} role="menu" tabindex="-1">
                    <button class="dropdown-action" onclick={(e) => handleStartRename(conv, e)} role="menuitem">
                      <Edit2 size={13} />
                      <span>Ubah judul</span>
                    </button>
                    <button class="dropdown-action delete" onclick={(e) => handleStartDelete(conv, e)} role="menuitem">
                      <Trash2 size={13} />
                      <span>Hapus</span>
                    </button>
                  </div>
                {/if}
              </div>
            </div>
          {/each}
        </div>
      {/each}
    {/if}
  </div>

  <!-- Footer Info -->
  <div class="sidebar-footer">
    <div class="footer-model-info">
      <Zap size={13} class="footer-icon" />
      <div class="footer-text">
        <span class="model-name">
          {activeModel === 'codex-luna-6-low' ? 'Codex Luna 6 Low' : (activeModel === 'codex-sol-6.1-low' ? 'Codex Sol 6.1 Low' : (activeModel.includes('flash-low') ? 'Gemini 3.7 Flash Low' : (activeModel.includes('medium') ? 'Gemini 3.7 Flash Med' : (activeModel.includes('high') ? 'Gemini 3.7 Flash High' : activeModel))))}
        </span>
        <span class="status-indicator">
          
          Dokumentasi internal
        </span>
      </div>
    </div>
  </div>
</aside>

<style>
  .mobile-backdrop {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.7);
    backdrop-filter: blur(4px);
    z-index: 40;
    display: none;
  }

  .sidebar {
    width: 264px;
    height: 100dvh;
    background: var(--bg-sidebar);
    border-right: 1px solid var(--border-subtle);
    display: flex;
    flex-direction: column;
    flex-shrink: 0;
    z-index: 50;
    transition: transform 0.22s cubic-bezier(0.16, 1, 0.3, 1), width 0.22s ease;
  }

  @media (max-width: 768px) {
    .sidebar {
      position: fixed;
      top: 0;
      bottom: 0;
      left: 0;
      width: 260px;
      transform: translateX(-100%);
    }

    .sidebar.open {
      transform: translateX(0);
    }

    .mobile-backdrop {
      display: block;
    }
  }

  .sidebar-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0.85rem 0.9rem;
    border-bottom: 1px solid var(--border-subtle);
  }

  .project-switcher-wrapper {
    position: relative;
    flex: 1;
    min-width: 0;
  }

  .project-trigger-btn {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    width: 100%;
    padding: 0.35rem 0.45rem;
    margin: -0.35rem -0.45rem;
    border-radius: var(--radius-sm);
    background: transparent;
    border: 1px solid transparent;
    text-align: left;
    cursor: pointer;
    transition: all 0.15s ease;
  }

  .project-trigger-btn:hover {
    background: rgba(66, 108, 178, 0.08);
    border-color: var(--border-subtle);
  }

  .brand-logo-frame {
    width: 28px;
    height: 28px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }

  .brand-logo-img {
    width: 26px;
    height: 26px;
    object-fit: contain;
    flex-shrink: 0;
  }

  .compliance-logo-icon {
    width: 26px;
    height: 26px;
    border-radius: 7px;
    background: linear-gradient(135deg, rgba(16, 185, 129, 0.2), rgba(6, 182, 212, 0.2));
    border: 1px solid rgba(16, 185, 129, 0.4);
    color: #10b981;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .logo-text-wrapper {
    display: flex;
    flex-direction: column;
    line-height: 1.15;
    min-width: 0;
  }

  .logo-title {
    font-size: 13.5px;
    font-weight: 700;
    color: var(--text-primary);
    letter-spacing: -0.01em;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .logo-subtitle {
    font-size: 8.5px;
    font-weight: 600;
    color: var(--accent-primary);
    letter-spacing: 0.08em;
  }

  .logo-badge-group {
    display: flex;
    align-items: center;
    gap: 0.25rem;
    margin-left: auto;
    flex-shrink: 0;
  }

  .logo-badge-subtle {
    font-size: 8.5px;
    background: rgba(66, 108, 178, 0.15);
    color: var(--accent-primary);
    border: 1px solid rgba(58, 194, 219, 0.3);
    padding: 0.05rem 0.25rem;
    border-radius: 3px;
    font-weight: 600;
    letter-spacing: 0.04em;
  }

  .logo-badge-subtle.ski-compliance {
    background: rgba(56, 189, 248, 0.15);
    color: #38bdf8;
    border-color: rgba(56, 189, 248, 0.4);
  }

  :global(.project-switch-chevron) {
    color: var(--text-muted);
    opacity: 0.7;
    transition: color 0.15s ease, opacity 0.15s ease;
  }

  .project-trigger-btn:hover :global(.project-switch-chevron) {
    color: var(--accent-primary);
    opacity: 1;
  }

  .project-dropdown-menu {
    position: absolute;
    top: calc(100% + 8px);
    left: 0;
    width: 240px;
    background: var(--bg-surface);
    border: 1px solid var(--border-strong);
    border-radius: var(--radius-md);
    padding: 0.4rem;
    box-shadow: 0 12px 32px rgba(0, 0, 0, 0.65), 0 0 16px rgba(66, 108, 178, 0.2);
    z-index: 100;
    animation: menu-pop 140ms cubic-bezier(0.16, 1, 0.3, 1);
  }

  .project-dropdown-header {
    font-family: var(--font-mono);
    font-size: 9px;
    font-weight: 700;
    color: var(--text-dim);
    letter-spacing: 0.08em;
    padding: 0.35rem 0.55rem 0.25rem;
  }

  .project-option {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 0.6rem;
    padding: 0.5rem 0.55rem;
    border-radius: var(--radius-sm);
    border: 1px solid transparent;
    background: transparent;
    text-align: left;
    cursor: pointer;
    transition: all 0.15s ease;
  }

  .project-option:hover {
    background: var(--bg-surface-hover);
  }

  .project-option.active {
    background: rgba(66, 108, 178, 0.12);
    border-color: rgba(58, 194, 219, 0.3);
  }

  .proj-icon-frame {
    width: 28px;
    height: 28px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }

  .proj-thumb-img {
    width: 22px;
    height: 22px;
    object-fit: contain;
  }

  .proj-compliance-icon {
    width: 24px;
    height: 24px;
    border-radius: 6px;
    background: rgba(16, 185, 129, 0.15);
    border: 1px solid rgba(16, 185, 129, 0.3);
    color: #10b981;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .proj-info {
    display: flex;
    flex-direction: column;
    min-width: 0;
    flex: 1;
  }

  .proj-name-line {
    display: flex;
    align-items: center;
    gap: 0.35rem;
  }

  .proj-name {
    font-size: 12.5px;
    font-weight: 600;
    color: var(--text-primary);
  }

  .proj-tag {
    font-size: 8px;
    font-weight: 700;
    color: var(--accent-primary);
    background: rgba(58, 194, 219, 0.12);
    border: 1px solid rgba(58, 194, 219, 0.25);
    padding: 0 0.25rem;
    border-radius: 3px;
  }

  .proj-desc {
    font-size: 10px;
    color: var(--text-muted);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    margin-top: 1px;
  }

  :global(.proj-check) {
    color: var(--accent-primary);
    flex-shrink: 0;
  }

  .close-sidebar-btn {
    color: var(--text-muted);
    padding: 0.2rem;
    border-radius: var(--radius-xs);
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .close-sidebar-btn:hover {
    color: var(--text-primary);
    background: var(--bg-surface-hover);
  }

  @keyframes menu-pop {
    from { opacity: 0; transform: translateY(-4px) scale(0.97); }
    to { opacity: 1; transform: translateY(0) scale(1); }
  }

  @media (min-width: 769px) {
    .close-sidebar-btn {
      display: none;
    }
  }

  .new-chat-container {
    padding: 0.65rem 0.65rem 0.3rem 0.65rem;
  }

  .new-chat-btn {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 0.45rem;
    padding: 0.5rem 0.65rem;
    background: var(--surface-tint);
    border: 1px solid var(--border-medium);
    border-radius: var(--radius-sm);
    color: var(--text-primary);
    font-size: 13px;
    font-weight: 500;
    transition: all 0.15s ease;
  }

  .new-chat-btn:hover {
    background: var(--surface-tint-hover);
    border-color: var(--border-strong);
  }

  .kbd-shortcut {
    margin-left: auto;
    font-size: 10px;
    color: var(--text-muted);
    background: var(--surface-tint);
    padding: 0.08rem 0.3rem;
    border-radius: 3px;
    font-family: var(--font-mono);
  }

  .search-container {
    margin: 0.3rem 0.65rem;
    position: relative;
    display: flex;
    align-items: center;
  }

  :global(.search-icon) {
    position: absolute;
    left: 0.6rem;
    color: var(--text-muted);
    pointer-events: none;
  }

  .search-input {
    width: 100%;
    background: var(--surface-tint);
    border: 1px solid var(--border-subtle);
    border-radius: var(--radius-xs);
    padding: 0.35rem 1.4rem 0.35rem 1.65rem;
    font-size: 12px;
    color: var(--text-primary);
    transition: all 0.15s ease;
  }

  .search-input:focus {
    background: var(--surface-tint);
    border-color: var(--border-focus);
  }

  .clear-search-btn {
    position: absolute;
    right: 0.35rem;
    color: var(--text-muted);
  }

  .history-list {
    flex: 1;
    overflow-y: auto;
    padding: 0.35rem 0.45rem;
  }

  .empty-history {
    padding: 2rem 0.5rem;
    text-align: center;
    color: var(--text-dim);
    font-size: 12px;
  }

  .history-group {
    margin-bottom: 0.8rem;
  }

  .group-label {
    font-size: 10.5px;
    font-weight: 600;
    color: var(--text-dim);
    letter-spacing: 0.03em;
    padding: 0.2rem 0.45rem;
  }

  .history-item {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0.4rem 0.55rem;
    border-radius: var(--radius-xs);
    color: var(--text-secondary);
    font-size: 13px;
    margin-bottom: 1px;
    cursor: pointer;
    transition: all 0.12s ease;
    user-select: none;
  }

  .history-item:hover {
    background: var(--bg-surface-hover);
    color: var(--text-primary);
  }

  .history-item.active {
    background: var(--bg-surface-active);
    color: var(--text-primary);
    font-weight: 500;
  }

  .item-title {
    flex: 1;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    padding-right: 0.3rem;
  }

  .item-menu-container {
    position: relative;
    display: flex;
    align-items: center;
  }

  .more-btn {
    opacity: 0;
    padding: 0.15rem;
    border-radius: 3px;
    color: var(--text-muted);
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.12s ease;
  }

  .history-item:hover .more-btn,
  .more-btn.active {
    opacity: 1;
  }

  .more-btn:hover {
    color: var(--text-primary);
    background: var(--surface-tint-hover);
  }

  /* Dropdown context menu */
  .context-dropdown {
    position: absolute;
    top: calc(100% + 4px);
    right: 0;
    width: 130px;
    background: var(--bg-surface);
    border: 1px solid var(--border-medium);
    border-radius: var(--radius-sm);
    box-shadow: 0 10px 24px rgba(0, 0, 0, 0.6);
    padding: 0.25rem;
    z-index: 60;
  }

  .dropdown-action {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 0.45rem;
    padding: 0.35rem 0.5rem;
    border-radius: var(--radius-xs);
    font-size: 12px;
    color: var(--text-secondary);
    transition: all 0.1s ease;
    text-align: left;
  }

  .dropdown-action:hover {
    color: var(--text-primary);
    background: var(--surface-tint-hover);
  }

  .dropdown-action.delete:hover {
    color: var(--danger-text);
    background: rgba(244, 63, 94, 0.1);
  }

  .sidebar-footer {
    padding: 0.65rem 0.8rem;
    border-top: 1px solid var(--border-subtle);
    background: rgba(0, 0, 0, 0.15);
  }

  .footer-model-info {
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  :global(.footer-icon) {
    color: #fbbf24;
    flex-shrink: 0;
  }

  .footer-text {
    display: flex;
    flex-direction: column;
    min-width: 0;
  }

  .model-name {
    font-size: 11px;
    font-weight: 600;
    color: var(--text-primary);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .status-indicator {
    display: flex;
    align-items: center;
    gap: 0.3rem;
    font-size: 9.5px;
    color: var(--accent-emerald);
  }


  .sidebar-header { min-height: 78px; padding: 20px; border-bottom: 0; }
  .logo-title { font-family: var(--font-display); font-size: 16px; letter-spacing: -.03em; }
  .new-chat-container { padding: 12px 18px; }
  .new-chat-btn { padding: 12px; background: linear-gradient(135deg, #426cb2, #3ac2db); border: 1px solid rgba(58, 194, 219, 0.4); color: #ffffff; font-weight: 600; box-shadow: 0 4px 14px rgba(66, 108, 178, 0.25); }
  .new-chat-btn:hover { background: linear-gradient(135deg, #4d7cc9, #4ecce4); border-color: #5dbfda; transform: translateY(-1px); box-shadow: 0 6px 18px rgba(66, 108, 178, 0.35); }
  .kbd-shortcut { color: rgba(255, 255, 255, 0.85); background: rgba(0, 0, 0, 0.2); }
  .search-container { margin: 0 18px 23px; }
  .search-input { padding-top: 10px; padding-bottom: 10px; background: transparent; border-color: transparent; }
  .history-heading { display: flex; align-items: center; justify-content: space-between; padding: 0 18px 10px; font-size: 11px; color: var(--text-muted); }
  .heading-left { display: flex; align-items: center; gap: 6px; }
  .count-badge { font-family: var(--font-mono); font-size: 10px; background: var(--surface-tint); padding: 1px 5px; border-radius: 4px; }
  .clear-all-btn { display: inline-flex; align-items: center; gap: 4px; font-size: 10.5px; color: var(--text-muted); padding: 2px 6px; border-radius: 4px; transition: all 0.15s ease; background: transparent; border: 1px solid transparent; }
  .clear-all-btn:hover { color: var(--danger-text, #f43f5e); background: rgba(244, 63, 94, 0.1); border-color: rgba(244, 63, 94, 0.2); }
  .history-list { padding: 0 13px; }
  .empty-history { text-align: left; border-top: 1px solid var(--border-subtle); padding: 24px 10px; }
  .empty-history > span { color: var(--text-secondary); font-size: 12px; }
  .empty-history p { margin-top: 7px; font-size: 11px; line-height: 1.8; }
  .history-item { padding: 10px; border-radius: 7px; }
  .history-item:focus-within .more-btn { opacity: 1; }
  .sidebar-footer { padding: 22px; background: transparent; }
  @media (min-width: 769px) { .sidebar.closed { width: 0; transform: translateX(-100%); overflow: hidden; border: 0; visibility: hidden; } }
  @media (hover: none) { .more-btn { opacity: 1; min-width: 32px; min-height: 32px; } }
</style>
