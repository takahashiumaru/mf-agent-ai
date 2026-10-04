<script>
  import { onMount, tick } from 'svelte';
  import { toast } from '$lib/stores/toast.js';
  import Sidebar from '$lib/components/Sidebar.svelte';
  import Header from '$lib/components/Header.svelte';
  import MessageItem from '$lib/components/MessageItem.svelte';
  import WelcomeScreen from '$lib/components/WelcomeScreen.svelte';
  import ChatInput from '$lib/components/ChatInput.svelte';
  import ConfirmDialog from '$lib/components/ConfirmDialog.svelte';
  import RenameDialog from '$lib/components/RenameDialog.svelte';
  import { Sparkles, AlertCircle, RefreshCw, Cpu } from '@lucide/svelte';
  import { formatModelName } from '$lib/utils/model.js';

  let conversations = $state([]);
  let activeId = $state(null);
  let activeConversation = $state(null);
  let messages = $state([]);
  let inputValue = $state('');
  let isStreaming = $state(false);
  let isThinking = $state(false);
  let isSidebarOpen = $state(false);
  let activeModel = $state('gemini-3.7-flash-low');
  let activeProject = $state('visitflow');

  // Streaming assistant message accumulator
  let currentStreamingText = $state('');
  let currentStreamingSources = $state([]);
  let lastFailedPrompt = $state('');

  // Modals state
  let deleteModalOpen = $state(false);
  let conversationToDelete = $state(null);
  let clearAllModalOpen = $state(false);

  let renameModalOpen = $state(false);
  let conversationToRename = $state(null);
  let chatContainerEl = $state(null);
  let abortController = $state(null);
  let userScrolledUp = false;

  function handleSelectProject(projId) {
    if (activeProject === projId) return;
    activeProject = projId;
    if (typeof localStorage !== 'undefined') {
      localStorage.setItem('visitflow-active-project', projId);
    }
    // Switch conversation scope to new project
    startNewChat();
    loadConversations(projId);
    toast.success(`Beralih ke project ${projId === 'ski-compliance' ? 'Ski Compliance' : 'VisitFlow'}`);
  }

  $effect(() => {
    if (typeof document !== 'undefined') {
      const isCompliance = activeProject === 'ski-compliance';
      const appName = isCompliance ? 'Ski Compliance AI' : 'VisitFlow AI';
      const titlePrefix = activeConversation?.title ? `${activeConversation.title} — ` : '';
      document.title = `${titlePrefix}${appName} — Asisten Cerdas Internal`;

      // Update favicon
      const iconLink = document.querySelector('link[rel="icon"]');
      if (iconLink) {
        iconLink.href = isCompliance ? '/ski.png' : '/logo.svg';
      }
    }
  });

  async function loadConversations(projectFilter = activeProject) {
    try {
      const url = projectFilter ? `/api/conversations?project=${encodeURIComponent(projectFilter)}` : '/api/conversations';
      const res = await fetch(url);
      const data = await res.json();
      if (data.success) {
        conversations = data.conversations || [];
      }
    } catch (err) {
      console.error('Failed to load conversations:', err);
    }
  }

  async function selectConversation(id) {
    if (isStreaming) return;
    if (window.matchMedia('(max-width: 768px)').matches) isSidebarOpen = false;
    activeId = id;
    try {
      const res = await fetch(`/api/conversations/${id}`);
      const data = await res.json();
      if (data.success) {
        activeConversation = data.conversation;
        messages = data.messages || [];
        await tick();
        scrollToBottom(true);
      }
    } catch (err) {
      toast.error('Gagal memuat detail percakapan');
    }
  }

  function startNewChat() {
    if (isStreaming) return;
    if (window.matchMedia('(max-width: 768px)').matches) isSidebarOpen = false;
    activeId = null;
    activeConversation = null;
    messages = [];
    currentStreamingText = '';
    currentStreamingSources = [];
    lastFailedPrompt = '';
  }

  function handleRequestRename(conv) {
    conversationToRename = conv;
    renameModalOpen = true;
  }

  async function confirmRename(newTitle) {
    if (!conversationToRename) return;
    const id = conversationToRename.id;
    try {
      const res = await fetch(`/api/conversations/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title: newTitle })
      });
      const data = await res.json();
      if (data.success) {
        const item = conversations.find(c => c.id === id);
        if (item) item.title = newTitle;
        if (activeConversation && activeConversation.id === id) {
          activeConversation.title = newTitle;
        }
        toast.success('Judul berhasil diubah');
      } else {
        toast.error(data.error || 'Gagal mengubah judul');
      }
    } catch (err) {
      toast.error('Gagal mengubah judul');
    } finally {
      renameModalOpen = false;
      conversationToRename = null;
    }
  }

  function handleRequestDelete(conv) {
    conversationToDelete = conv;
    deleteModalOpen = true;
  }

  async function confirmDelete() {
    if (!conversationToDelete) return;
    const id = conversationToDelete.id;
    try {
      const res = await fetch(`/api/conversations/${id}`, { method: 'DELETE' });
      const data = await res.json();
      if (data.success) {
        conversations = conversations.filter(c => c.id !== id);
        if (activeId === id) {
          startNewChat();
        }
        toast.info('Percakapan dihapus');
      } else {
        toast.error(data.error || 'Gagal menghapus percakapan');
      }
    } catch (err) {
      toast.error('Gagal menghapus percakapan');
    } finally {
      deleteModalOpen = false;
      conversationToDelete = null;
    }
  }

  function handleRequestDeleteAll() {
    if (conversations.length === 0) return;
    clearAllModalOpen = true;
  }

  async function confirmClearAll() {
    try {
      const url = activeProject ? `/api/conversations?project=${encodeURIComponent(activeProject)}` : '/api/conversations';
      const res = await fetch(url, { method: 'DELETE' });
      const data = await res.json();
      if (data.success) {
        conversations = [];
        startNewChat();
        toast.info('Semua percakapan berhasil dibersihkan');
      } else {
        toast.error(data.error || 'Gagal membersihkan percakapan');
      }
    } catch (err) {
      toast.error('Gagal membersihkan percakapan');
    } finally {
      clearAllModalOpen = false;
    }
  }

  function handleScroll() {
    if (!chatContainerEl) return;
    const { scrollTop, scrollHeight, clientHeight } = chatContainerEl;
    const isNearBottom = scrollHeight - scrollTop - clientHeight < 60;
    userScrolledUp = !isNearBottom;
  }

  function scrollToBottom(force = false) {
    if (!chatContainerEl) return;
    if (force || !userScrolledUp) {
      chatContainerEl.scrollTop = chatContainerEl.scrollHeight;
    }
  }

  async function sendMessage(text) {
    if (!text || !text.trim() || isStreaming) return;
    const promptText = text.trim();
    lastFailedPrompt = '';
    userScrolledUp = false;

    // Push user message to UI immediately
    const tempUserMsg = {
      id: 'temp-user-' + Date.now(),
      role: 'user',
      content: promptText,
      created_at: new Date().toISOString()
    };
    messages = [...messages, tempUserMsg];

    isStreaming = true;
    isThinking = true;
    currentStreamingText = '';
    currentStreamingSources = [];

    await tick();
    scrollToBottom(true);

    abortController = new AbortController();

    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          conversationId: activeId,
          message: promptText,
          model: activeModel,
          project: activeProject
        }),
        signal: abortController.signal
      });

      if (!response.ok) {
        const errData = await response.json().catch(() => ({}));
        throw new Error(errData.error || `HTTP ${response.status}`);
      }

      const reader = response.body.getReader();
      const decoder = new TextDecoder();
      let buffer = '';

      while (true) {
        const { value, done } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop() || '';

        let currentEvent = 'message';

        for (const line of lines) {
          const trimmed = line.trim();
          if (!trimmed) continue;

          if (trimmed.startsWith('event: ')) {
            currentEvent = trimmed.slice(7).trim();
            continue;
          }

          if (trimmed.startsWith('data: ')) {
            const dataStr = trimmed.slice(6);
            try {
              const parsed = JSON.parse(dataStr);

              if (currentEvent === 'sources') {
                currentStreamingSources = parsed.sources || [];
              } else if (currentEvent === 'title') {
                if (parsed.conversationId) {
                  activeId = parsed.conversationId;
                  activeConversation = { id: parsed.conversationId, title: parsed.title };
                  loadConversations();
                }
              } else if (currentEvent === 'delta') {
                isThinking = false;
                currentStreamingText += parsed.text || '';
                await tick();
                scrollToBottom();
              } else if (currentEvent === 'done') {
                if (parsed.conversationId) {
                  activeId = parsed.conversationId;
                }
                const assistantMsg = {
                  id: parsed.id || 'asst-' + Date.now(),
                  role: 'assistant',
                  content: currentStreamingText,
                  sources: parsed.sources || currentStreamingSources,
                  created_at: new Date().toISOString()
                };
                messages = [...messages, assistantMsg];
                currentStreamingText = '';
                currentStreamingSources = [];
                loadConversations();
              } else if (currentEvent === 'error') {
                isThinking = false;
                lastFailedPrompt = promptText;
                toast.error(parsed.error || 'Terjadi kesalahan pada agent');
              }
            } catch (e) {
              // Ignore partial or unparseable SSE line
            }
          }
        }
      }
    } catch (err) {
      if (err.name !== 'AbortError') {
        console.error('Chat stream error:', err);
        lastFailedPrompt = promptText;
        toast.error(`Gagal menghubungkan ke agent: ${err.message}`);
      }
    } finally {
      isStreaming = false;
      isThinking = false;
      abortController = null;
      await tick();
      scrollToBottom();
    }
  }

  function stopStreaming() {
    if (abortController) {
      abortController.abort();
      abortController = null;
    }
    isStreaming = false;
    isThinking = false;
    if (currentStreamingText) {
      const partialMsg = {
        id: 'partial-' + Date.now(),
        role: 'assistant',
        content: currentStreamingText + ' _[dihentikan]_',
        sources: currentStreamingSources,
        created_at: new Date().toISOString()
      };
      messages = [...messages, partialMsg];
      currentStreamingText = '';
      currentStreamingSources = [];
    }
  }

  function handleKeydownGlobal(e) {
    if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
      e.preventDefault();
      startNewChat();
    }
  }

  function handleSelectModel(m) {
    activeModel = m;
    if (typeof localStorage !== 'undefined') {
      localStorage.setItem('mf-active-model', m);
    }
  }

  onMount(() => {
    isSidebarOpen = window.matchMedia('(min-width: 769px)').matches;
    let initialProject = activeProject;
    if (typeof localStorage !== 'undefined') {
      const savedProj = localStorage.getItem('visitflow-active-project');
      if (savedProj) {
        activeProject = savedProj;
        initialProject = savedProj;
      }
      const savedModel = localStorage.getItem('mf-active-model');
      if (savedModel) {
        activeModel = savedModel;
      }
    }
    loadConversations(initialProject);
    window.addEventListener('keydown', handleKeydownGlobal);
    return () => {
      window.removeEventListener('keydown', handleKeydownGlobal);
    };
  });
</script>

<div class="chat-app-root" data-project={activeProject}>
  <!-- Left Sidebar -->
  <Sidebar 
    {conversations} 
    {activeId} 
    isOpen={isSidebarOpen}
    {activeModel}
    {activeProject}
    onSelectProject={handleSelectProject}
    onSelectConversation={selectConversation}
    onNewChat={startNewChat}
    onRequestDelete={handleRequestDelete}
    onRequestDeleteAll={handleRequestDeleteAll}
    onRequestRename={handleRequestRename}
    onCloseMobile={() => isSidebarOpen = false}
  />

  <!-- Main Chat Workspace -->
  <main class="main-workspace">
    <Header 
      title={activeConversation?.title || (messages.length > 0 ? 'Percakapan Aktif' : (activeProject === 'ski-compliance' ? 'Ski Compliance AI' : 'VisitFlow AI'))}
      {activeModel}
      {isSidebarOpen}
      onToggleSidebar={() => isSidebarOpen = !isSidebarOpen}
      onSelectModel={handleSelectModel}
    />

    <!-- Messages Container -->
    <div 
      class="chat-scroll-area" 
      bind:this={chatContainerEl}
      onscroll={handleScroll}
    >
      {#if messages.length === 0 && !isStreaming}
        <WelcomeScreen project={activeProject} onSelectPrompt={(p) => sendMessage(p)} />
      {:else}
        <div class="messages-list">
          {#each messages as msg (msg.id)}
            <MessageItem message={msg} project={activeProject} model={msg.model || activeModel} />
          {/each}

          <!-- Live Streaming Message -->
          {#if isStreaming}
            {#if isThinking && !currentStreamingText}
              <div class="message-row assistant">
                <div class="assistant-container">
                  <div class="assistant-avatar {activeProject === 'ski-compliance' ? 'ski' : 'vf'}">
                    <img 
                      src={activeProject === 'ski-compliance' ? '/ski.png' : '/logo.svg'} 
                      alt={activeProject === 'ski-compliance' ? 'SKI' : 'VF'} 
                      class="avatar-logo-img" 
                    />
                  </div>
                  <div class="assistant-content">
                    <div class="thinking-state">
                      <div class="typing-dots">
                        <span class="typing-dot"></span>
                        <span class="typing-dot"></span>
                        <span class="typing-dot"></span>
                      </div>
                      <div class="thinking-text-group">
                        <span class="thinking-name">{activeProject === 'ski-compliance' ? 'Ski Compliance AI' : 'VisitFlow AI'}</span>
                        <span class="thinking-model-badge {activeProject === 'ski-compliance' ? 'ski' : 'vf'}" title="Model AI: {formatModelName(activeModel)}">
                          <Cpu size={10.5} class="model-tag-icon" />
                          <span>{formatModelName(activeModel)}</span>
                        </span>
                        <span class="thinking-status">sedang memproses...</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            {:else if currentStreamingText}
              <MessageItem 
                message={{
                  role: 'assistant',
                  content: currentStreamingText,
                  sources: currentStreamingSources,
                  created_at: new Date().toISOString()
                }} 
                isStreaming={true}
                project={activeProject}
                model={activeModel}
              />
            {/if}
          {/if}

          <!-- Inline Error Retry Card -->
          {#if lastFailedPrompt && !isStreaming}
            <div class="error-banner-container">
              <div class="error-card">
                <AlertCircle size={16} class="error-card-icon" />
                <div class="error-card-body">
                  <span class="error-text">Gagal menerima jawaban dari agent.</span>
                  <button class="retry-btn" onclick={() => sendMessage(lastFailedPrompt)}>
                    <RefreshCw size={12} />
                    <span>Coba Lagi</span>
                  </button>
                </div>
              </div>
            </div>
          {/if}
        </div>
      {/if}
    </div>

    <!-- Sticky Composer Area with Fade Mask -->
    <div class="composer-sticky-zone">
      <div class="composer-fade-mask"></div>
      <ChatInput 
        bind:value={inputValue}
        {isStreaming}
        project={activeProject}
        onSend={sendMessage}
        onStop={stopStreaming}
      />
    </div>
  </main>
</div>

<!-- Custom Modals (No native alert / confirm!) -->
<ConfirmDialog 
  isOpen={deleteModalOpen}
  title="Hapus percakapan?"
  description="Percakapan '{conversationToDelete?.title || ''}' akan dihapus secara permanen. Tindakan ini tidak dapat dibatalkan."
  confirmLabel="Hapus"
  cancelLabel="Batal"
  isDestructive={true}
  onConfirm={confirmDelete}
  onCancel={() => { deleteModalOpen = false; conversationToDelete = null; }}
/>
<ConfirmDialog 
  isOpen={clearAllModalOpen}
  title="Hapus semua percakapan?"
  description="Semua riwayat percakapan ({conversations.length} percakapan) akan dihapus secara permanen dari database. Tindakan ini tidak dapat dibatalkan. Apakah Anda yakin?"
  confirmLabel="Hapus Semua"
  cancelLabel="Batal"
  isDestructive={true}
  onConfirm={confirmClearAll}
  onCancel={() => { clearAllModalOpen = false; }}
/>

<RenameDialog 
  isOpen={renameModalOpen}
  initialTitle={conversationToRename?.title || ''}
  onSave={confirmRename}
  onCancel={() => { renameModalOpen = false; conversationToRename = null; }}
/>

<style>
  .chat-app-root {
    display: flex;
    width: 100%;
    height: 100dvh;
    overflow: hidden;
    position: relative;
    background-color: var(--bg-app);
  }

  .main-workspace {
    flex: 1;
    display: flex;
    flex-direction: column;
    height: 100%;
    background-color: var(--bg-app);
    position: relative;
    min-width: 0;
  }

  .chat-scroll-area {
    flex: 1;
    min-height: 0;
    overflow-y: auto;
    overflow-x: hidden;
    display: flex;
    flex-direction: column;
    padding: 0.5rem 0 0 0;
  }

  .messages-list {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
    padding-bottom: 7rem;
  }

  /* Thinking Indicator */
  .message-row {
    width: 100%;
    max-width: 820px;
    margin: 0 auto;
    padding: 0.75rem 1.25rem;
    display: flex;
  }

  .assistant-container {
    display: flex;
    gap: 0.9rem;
    width: 100%;
    align-items: center;
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

  .thinking-state {
    display: flex;
    align-items: center;
    gap: 0.65rem;
    padding: 0.2rem 0;
  }

  .thinking-text-group {
    display: flex;
    align-items: center;
    gap: 0.45rem;
    flex-wrap: wrap;
  }

  .thinking-name {
    font-size: 13px;
    font-weight: 600;
    color: var(--text-primary);
  }

  .thinking-model-badge {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    font-size: 10px;
    font-weight: 600;
    font-family: var(--font-mono);
    color: var(--text-secondary);
    background: var(--surface-tint);
    border: 1px solid var(--border-subtle);
    padding: 0.08rem 0.4rem;
    border-radius: 4px;
    letter-spacing: 0.01em;
  }

  .thinking-model-badge.ski {
    border-color: rgba(56, 189, 248, 0.3);
  }

  .thinking-status {
    font-size: 12.5px;
    color: var(--text-muted);
    font-style: italic;
  }

  /* Inline Error Banner */
  .error-banner-container {
    width: 100%;
    max-width: 820px;
    margin: 0.5rem auto;
    padding: 0 1.25rem;
  }

  .error-card {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.75rem 1rem;
    background: rgba(244, 63, 94, 0.08);
    border: 1px solid rgba(244, 63, 94, 0.25);
    border-radius: var(--radius-md);
  }

  :global(.error-card-icon) {
    color: var(--accent-rose);
    flex-shrink: 0;
  }

  .error-card-body {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
  }

  .error-text {
    font-size: 13px;
    color: var(--error-text);
  }

  .retry-btn {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    padding: 0.25rem 0.6rem;
    background: rgba(244, 63, 94, 0.15);
    border: 1px solid rgba(244, 63, 94, 0.3);
    border-radius: 4px;
    font-size: 11.5px;
    font-weight: 500;
    color: var(--text-primary);
    transition: all 0.15s ease;
  }

  .retry-btn:hover {
    background: rgba(244, 63, 94, 0.25);
  }

  /* Sticky Composer Zone */
  .composer-sticky-zone {
    flex-shrink: 0;
    position: relative;
    width: 100%;
    z-index: 10;
  }

  .composer-fade-mask {
    position: absolute;
    top: -30px;
    left: 0;
    right: 0;
    height: 30px;
    background: linear-gradient(180deg, transparent 0%, var(--bg-app) 100%);
    pointer-events: none;
  }
</style>
