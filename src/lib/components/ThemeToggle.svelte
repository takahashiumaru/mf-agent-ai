<script>
  import { onMount } from 'svelte';
  import { Sun, Moon } from '@lucide/svelte';
  let theme = $state('dark');
  let manualChoice = false;
  function applyTheme(next) {
    theme = next;
    document.documentElement.dataset.theme = next;
    document.documentElement.classList.toggle('dark', next === 'dark');
  }
  function toggleTheme() {
    manualChoice = true;
    applyTheme(theme === 'dark' ? 'light' : 'dark');
    try { localStorage.setItem('visitflow-theme', theme); } catch { /* Usable without storage. */ }
  }
  onMount(() => {
    const preference = window.matchMedia('(prefers-color-scheme: dark)');
    let saved;
    try { saved = localStorage.getItem('visitflow-theme'); } catch { /* Follow device preference. */ }
    manualChoice = saved === 'dark' || saved === 'light';
    applyTheme(manualChoice ? saved : (preference.matches ? 'dark' : 'light'));
    const onSystemChange = (event) => { if (!manualChoice) applyTheme(event.matches ? 'dark' : 'light'); };
    preference.addEventListener('change', onSystemChange);
    return () => preference.removeEventListener('change', onSystemChange);
  });
</script>
<button class="theme-toggle" onclick={toggleTheme}
  aria-label={theme === 'dark' ? 'Aktifkan mode terang' : 'Aktifkan mode gelap'}
  title={theme === 'dark' ? 'Aktifkan mode terang' : 'Aktifkan mode gelap'}>
  {#if theme === 'dark'}<Sun size={17} strokeWidth={1.7} />{:else}<Moon size={17} strokeWidth={1.7} />{/if}
</button>
<style>
  .theme-toggle { width: 36px; height: 36px; flex-shrink: 0; display: grid; place-items: center; border: 1px solid var(--border-medium); border-radius: 8px; color: var(--text-secondary); transition: background 180ms, color 180ms, transform 180ms; }
  .theme-toggle:hover { background: var(--bg-surface-hover); color: var(--text-primary); }
  .theme-toggle:active { transform: scale(.92); }
  @media (max-width: 380px) { .theme-toggle { width: 32px; height: 32px; } }
</style>
