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
    display: inline-flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 0.4rem;
    margin-bottom: 0.75rem;
    padding: 0.25rem 0.6rem;
    background: var(--surface-tint);
    border: 1px solid var(--border-subtle);
    border-radius: var(--radius-full);
    font-size: 11.5px;
  }

  .sources-label {
    display: flex;
    align-items: center;
    gap: 0.3rem;
    color: var(--text-muted);
    font-weight: 500;
  }

  .sources-chips {
    display: flex;
    flex-wrap: wrap;
    gap: 0.3rem;
  }

  .source-tag {
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
    padding: 0.1rem 0.45rem;
    background: rgba(66, 108, 178, 0.12);
    border: 1px solid rgba(58, 194, 219, 0.25);
    border-radius: var(--radius-full);
    color: var(--accent-primary);
    font-family: var(--font-mono);
    font-size: 11px;
    transition: all 0.15s ease;
  }

  .source-tag:hover {
    background: rgba(66, 108, 178, 0.2);
    border-color: rgba(58, 194, 219, 0.45);
  }

  :global(.tag-icon) {
    color: var(--accent-blue);
  }
</style>
