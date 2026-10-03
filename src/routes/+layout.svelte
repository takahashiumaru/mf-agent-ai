<script>
  import '../app.css';
  import { onMount } from 'svelte';
  import Toast from '$lib/components/Toast.svelte';

  let { children } = $props();

  onMount(() => {
    // Global copy handler for markdown code blocks
    window.__copyCode = function(button) {
      const rawEncoded = button.getAttribute('data-code');
      if (!rawEncoded) return;
      const code = decodeURIComponent(rawEncoded);
      navigator.clipboard.writeText(code).then(() => {
        const span = button.querySelector('span');
        const originalText = span ? span.innerText : 'Salin';
        if (span) span.innerText = 'Tersalin!';
        button.style.color = '#10b981';
        setTimeout(() => {
          if (span) span.innerText = originalText;
          button.style.color = '';
        }, 2000);
      });
    };
  });
</script>

<div class="app-layout">
  <!-- eslint-disable-next-line svelte/no-at-html-tags -->
  {@render children()}
  <Toast />
</div>

<style>
  .app-layout {
    display: flex;
    width: 100vw;
    height: 100vh;
    background-color: var(--bg-app);
    color: var(--text-primary);
    overflow: hidden;
    position: relative;
  }
</style>
