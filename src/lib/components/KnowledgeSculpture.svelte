<script>
  import { Pause, Play } from '@lucide/svelte';
  
  let { project = 'visitflow' } = $props();

  let paused = $state(false);
  let tiltX = $state(0);
  let tiltY = $state(0);

  let isCompliance = $derived(project === 'ski-compliance');
  let logoSrc = $derived(isCompliance ? '/ski.png' : '/logo.svg');
  let logoLabel = $derived(isCompliance ? 'Logo Ski Compliance dalam bentuk 3D' : 'Logo VisitFlow dalam bentuk 3D');

  function track(event) {
    if (event.pointerType === 'touch') return;
    const bounds = event.currentTarget.getBoundingClientRect();
    tiltY = ((event.clientX - bounds.left) / bounds.width - 0.5) * 18;
    tiltX = -((event.clientY - bounds.top) / bounds.height - 0.5) * 12;
  }
</script>

<!-- Extrude the original brand asset, preserving its shape and colors. -->
<div class="sculpture {isCompliance ? 'ski' : 'vf'}" class:paused onpointermove={track} onpointerleave={() => { tiltX = 0; tiltY = 0; }} role="group" aria-label={logoLabel}>
  <div class="stage" aria-hidden="true" style:--tilt-x="{tiltX}deg" style:--tilt-y="{tiltY}deg">
    <div class="ground {isCompliance ? 'ski' : 'vf'}"></div>
    <div class="assembly" style:--logo-url="url('{logoSrc}')">
      {#each Array.from({ length: 16 }, (_, i) => i) as depth}
        <img class="logo-depth {isCompliance ? 'ski' : 'vf'}" src={logoSrc} alt="" draggable="false" style:--depth={depth + 1} />
      {/each}
      <img class="logo-front {isCompliance ? 'ski' : 'vf'}" src={logoSrc} alt="" draggable="false" />
      <div class="logo-reflection" style="mask-image: var(--logo-url); -webkit-mask-image: var(--logo-url);"></div>
    </div>
    <div class="pedestal {isCompliance ? 'ski' : 'vf'}"><div class="pedestal-rim {isCompliance ? 'ski' : 'vf'}"></div></div>
  </div>
  <button class="motion-toggle" onclick={() => paused = !paused} aria-label={paused ? 'Putar animasi 3D' : 'Jeda animasi 3D'} aria-pressed={paused}>
    {#if paused}<Play size={12} />{:else}<Pause size={12} />{/if}
  </button>
</div>

<style>
  .sculpture { position: relative; width: 340px; height: 300px; flex-shrink: 0; }
  .stage { width: 100%; height: 100%; perspective: 850px; transform: rotateX(var(--tilt-x)) rotateY(var(--tilt-y)); transition: transform 650ms cubic-bezier(.2,.8,.2,1); }
  .assembly { position: absolute; top: -24px; left: 10px; width: 320px; height: 320px; transform-style: preserve-3d; transform: rotateX(8deg) rotateY(-22deg) rotateZ(-6deg); animation: drift 9s ease-in-out infinite; }
  .logo-depth, .logo-front { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: contain; backface-visibility: hidden; pointer-events: none; }
  .logo-depth { transform: translateZ(calc(var(--depth) * -1.2px)); filter: brightness(.48) saturate(1.1); }
  .logo-depth.ski { filter: brightness(.42) saturate(1.2) contrast(1.1); }
  .logo-front { transform: translateZ(1px); filter: drop-shadow(0 1px 1px #bcf4ff60); }
  .logo-front.ski { filter: drop-shadow(0 2px 14px rgba(56, 189, 248, 0.45)); }
  .logo-reflection { position: absolute; inset: 0; transform: translateZ(2px); mask-position: center; mask-size: contain; mask-repeat: no-repeat; -webkit-mask-position: center; -webkit-mask-size: contain; -webkit-mask-repeat: no-repeat; background: linear-gradient(120deg, #ffffff35, transparent 40%, #ffffff0c 70%, transparent); pointer-events: none; }
  
  .pedestal { position: absolute; left: 62px; bottom: 3px; width: 216px; height: 74px; border-radius: 50%; background: linear-gradient(180deg, #20385c35, #0c172640); border: 1px solid var(--border-medium); box-shadow: 0 10px 24px #00000018, inset 0 1px 0 #81c9e930; }
  .pedestal.ski { background: linear-gradient(180deg, rgba(37, 99, 235, 0.25), rgba(12, 23, 38, 0.5)); border-color: rgba(56, 189, 248, 0.3); box-shadow: 0 10px 24px rgba(0, 0, 0, 0.25), inset 0 1px 0 rgba(56, 189, 248, 0.4); }
  
  .pedestal-rim { position: absolute; inset: 9px 15px; border: 1px solid #5dbfda25; border-radius: 50%; background: radial-gradient(ellipse, #426cb217, transparent 70%); }
  .pedestal-rim.ski { border-color: rgba(56, 189, 248, 0.35); background: radial-gradient(ellipse, rgba(37, 99, 235, 0.22), transparent 70%); }
  
  :global([data-theme="light"]) .pedestal { background: #426cb20b; box-shadow: 0 10px 24px #284b820c, inset 0 1px 0 #ffffffb3; }
  :global([data-theme="light"]) .pedestal.ski { background: rgba(37, 99, 235, 0.08); box-shadow: 0 10px 24px rgba(37, 99, 235, 0.12), inset 0 1px 0 #ffffffb3; }
  
  .ground { position: absolute; width: 170px; height: 36px; left: 85px; bottom: 45px; background: var(--sculpture-shadow); filter: blur(19px); border-radius: 50%; }
  .ground.ski { background: rgba(37, 99, 235, 0.35); filter: blur(22px); }
  
  .motion-toggle { position: absolute; bottom: 0; right: 0; display: grid; place-items: center; width: 30px; height: 30px; border: 1px solid var(--border-medium); border-radius: 50%; color: var(--text-muted); }
  .motion-toggle:hover { color: var(--text-primary); background: var(--bg-surface-hover); }
  .paused .assembly { animation-play-state: paused; }
  @keyframes drift { 0%,100% { transform: translateY(0) rotateX(8deg) rotateY(-22deg) rotateZ(-6deg); } 50% { transform: translateY(-9px) rotateX(4deg) rotateY(-10deg) rotateZ(-3deg); } }
  @media (prefers-reduced-motion: reduce) { .stage { transform: none; } .assembly { animation: none; } .motion-toggle { display: none; } }
</style>
