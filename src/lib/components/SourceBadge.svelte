<script>
  import { BookOpen, Database, Shield, Wrench, FileText, ChevronDown } from '@lucide/svelte';

  let { sources = [] } = $props();

  let isExpanded = $state(false);

  function getIcon(sourceName) {
    if (sourceName.includes('DATABASE') || sourceName.includes('.sql')) return Database;
    if (sourceName.includes('rules')) return Shield;
    if (sourceName.includes('tools')) return Wrench;
    if (sourceName.includes('system') || sourceName.includes('README')) return BookOpen;
    return FileText;
  }

  function getFileName(sourcePath) {
    return sourcePath.split('/').pop() || sourcePath;
  }

  // Deduplicate sources by filename
  let uniqueSources = $derived.by(() => {
    const map = new Map();
    for (const s of (sources || [])) {
      const name = getFileName(s.source);
      if (!map.has(name)) {
        map.set(name, s);
      }
    }
    return Array.from(map.values());
  });
</script>

{#if uniqueSources && uniqueSources.length > 0}
  <div class="sources-pill-row">
    <div class="sources-label">
      <BookOpen size={13} />
      <span>Sumber:</span>
    </div>
    <div class="sources-chips">
      {#each uniqueSources as src}
        {@const Icon = getIcon(src.source)}
        <span class="source-tag" title="{src.source} (Bagian: {src.section || 'Dokumen'})">
          <Icon size={11} class="tag-icon" />
          <span>{getFileName(src.source)}</span>
        </span>
      {/each}
    </div>
  </div>
{/if}

<style>
  .sources-pill-row {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 0.5rem;
    margin-bottom: 0.85rem;
    padding: 0.35rem 0.65rem;
    background: var(--surface-tint);
    border: 1px solid var(--border-subtle);
    border-radius: var(--radius-sm);
    font-size: 11.5px;
    width: fit-content;
    max-width: 100%;
  }

  .sources-label {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    color: var(--text-secondary);
    font-weight: 600;
    font-size: 11.5px;
    flex-shrink: 0;
  }

  .sources-chips {
    display: inline-flex;
    flex-wrap: wrap;
    gap: 0.35rem;
    align-items: center;
  }

  .source-tag {
    display: inline-flex;
    align-items: center;
    gap: 0.3rem;
    padding: 0.2rem 0.5rem;
    background: var(--bg-surface);
    border: 1px solid var(--border-medium);
    border-radius: 5px;
    color: var(--accent-primary);
    font-family: var(--font-mono);
    font-size: 11px;
    font-weight: 500;
    box-shadow: var(--shadow-sm);
    transition: all 0.15s ease;
  }

  .source-tag:hover {
    background: var(--surface-tint-hover);
    border-color: var(--accent-primary);
    color: var(--accent-primary-hover);
  }

  :global(.tag-icon) {
    color: var(--accent-primary);
    flex-shrink: 0;
  }
</style>
