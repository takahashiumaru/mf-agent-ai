<script>
  import { onMount, onDestroy } from 'svelte';
  import { Pause, Play, Sparkles } from '@lucide/svelte';
  import * as THREE from 'three';
  import gsap from 'gsap';

  let { project = 'visitflow' } = $props();

  let containerEl = $state(null);
  let paused = $state(false);
  let isCompliance = $derived(project === 'ski-compliance');

  let scene, camera, renderer, animationFrameId;
  let coreGroup, ring1, ring2, ring3, particles, particleGeo, particleMat;
  let targetRotationX = 0, targetRotationY = 0;
  let currentRotationX = 0, currentRotationY = 0;

  function initThree() {
    if (!containerEl) return;
    const width = containerEl.clientWidth || 340;
    const height = containerEl.clientHeight || 300;

    // 1. Scene
    scene = new THREE.Scene();

    // 2. Camera
    camera = new THREE.PerspectiveCamera(45, width / height, 0.1, 1000);
    camera.position.z = 6.8;

    // 3. Renderer with antialiasing and alpha
    renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true, powerPreference: 'high-performance' });
    renderer.setSize(width, height);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1.2;

    containerEl.appendChild(renderer.domElement);

    // 4. Lights
    const ambientLight = new THREE.AmbientLight(0xffffff, 1.2);
    scene.add(ambientLight);

    const pointLight1 = new THREE.PointLight(isCompliance ? 0x38bdf8 : 0x3ac2db, 4.5, 50);
    pointLight1.position.set(4, 5, 4);
    scene.add(pointLight1);

    const pointLight2 = new THREE.PointLight(isCompliance ? 0x2563eb : 0x60a5fa, 3.5, 50);
    pointLight2.position.set(-4, -3, 3);
    scene.add(pointLight2);

    // 5. Core Group
    coreGroup = new THREE.Group();
    scene.add(coreGroup);

    // Geometry 1: Icosahedron / Crystal Core
    const coreGeo = new THREE.IcosahedronGeometry(1.2, 1);
    const coreMat = new THREE.MeshPhysicalMaterial({
      color: isCompliance ? 0x1d4ed8 : 0x0284c7,
      emissive: isCompliance ? 0x1e3a8a : 0x0369a1,
      emissiveIntensity: 0.6,
      roughness: 0.15,
      metalness: 0.85,
      transmission: 0.6,
      thickness: 1.2,
      ior: 1.5,
      wireframe: false
    });
    const coreMesh = new THREE.Mesh(coreGeo, coreMat);
    coreGroup.add(coreMesh);

    // Inner Wireframe
    const wireMat = new THREE.MeshBasicMaterial({
      color: isCompliance ? 0x93c5fd : 0x7dd3fc,
      wireframe: true,
      transparent: true,
      opacity: 0.45
    });
    const wireMesh = new THREE.Mesh(coreGeo, wireMat);
    wireMesh.scale.set(1.02, 1.02, 1.02);
    coreGroup.add(wireMesh);

    // Geometry 2: Gyroscope Quantum Rings
    const ringMat1 = new THREE.MeshStandardMaterial({
      color: isCompliance ? 0x38bdf8 : 0x38bdf8,
      metalness: 0.9,
      roughness: 0.2,
      wireframe: true
    });
    const ringGeo1 = new THREE.TorusGeometry(1.9, 0.025, 16, 100);
    ring1 = new THREE.Mesh(ringGeo1, ringMat1);
    coreGroup.add(ring1);

    const ringMat2 = new THREE.MeshStandardMaterial({
      color: isCompliance ? 0x60a5fa : 0x3ac2db,
      metalness: 0.95,
      roughness: 0.15
    });
    const ringGeo2 = new THREE.TorusGeometry(2.3, 0.035, 16, 100);
    ring2 = new THREE.Mesh(ringGeo2, ringMat2);
    ring2.rotation.x = Math.PI / 3;
    coreGroup.add(ring2);

    const ringMat3 = new THREE.MeshStandardMaterial({
      color: isCompliance ? 0x2563eb : 0x0284c7,
      metalness: 0.8,
      roughness: 0.3
    });
    const ringGeo3 = new THREE.TorusGeometry(2.7, 0.02, 16, 100);
    ring3 = new THREE.Mesh(ringGeo3, ringMat3);
    ring3.rotation.y = Math.PI / 4;
    coreGroup.add(ring3);

    // Geometry 3: Orbiting Floating Data Sparks
    const count = 120;
    const pos = new Float32Array(count * 3);
    for (let i = 0; i < count * 3; i += 3) {
      const radius = 2.5 + Math.random() * 1.8;
      const theta = Math.random() * Math.PI * 2;
      const phi = Math.acos((Math.random() * 2) - 1);
      pos[i] = radius * Math.sin(phi) * Math.cos(theta);
      pos[i + 1] = radius * Math.sin(phi) * Math.sin(theta);
      pos[i + 2] = radius * Math.cos(phi);
    }
    particleGeo = new THREE.BufferGeometry();
    particleGeo.setAttribute('position', new THREE.BufferAttribute(pos, 3));
    particleMat = new THREE.PointsMaterial({
      size: 0.065,
      color: isCompliance ? 0x60a5fa : 0x38bdf8,
      transparent: true,
      opacity: 0.85,
      blending: THREE.AdditiveBlending
    });
    particles = new THREE.Points(particleGeo, particleMat);
    coreGroup.add(particles);

    // Initial Entrance Animation with GSAP
    gsap.from(coreGroup.scale, {
      x: 0,
      y: 0,
      z: 0,
      duration: 1.4,
      ease: 'elastic.out(1, 0.6)'
    });
    gsap.from(coreGroup.rotation, {
      x: Math.PI * 2,
      y: Math.PI * 2,
      duration: 2,
      ease: 'power3.out'
    });

    animate();
  }

  function animate() {
    animationFrameId = requestAnimationFrame(animate);

    if (!paused && coreGroup) {
      // Smooth interactive parallax interpolation
      currentRotationX += (targetRotationX - currentRotationX) * 0.08;
      currentRotationY += (targetRotationY - currentRotationY) * 0.08;

      coreGroup.rotation.y += 0.008;
      coreGroup.rotation.x = Math.sin(Date.now() * 0.001) * 0.15 + currentRotationX;
      coreGroup.rotation.z = currentRotationY * 0.5;

      if (ring1) {
        ring1.rotation.x += 0.015;
        ring1.rotation.y += 0.012;
      }
      if (ring2) {
        ring2.rotation.y -= 0.018;
        ring2.rotation.z += 0.01;
      }
      if (ring3) {
        ring3.rotation.z += 0.014;
        ring3.rotation.x -= 0.009;
      }
      if (particles) {
        particles.rotation.y -= 0.003;
      }
    }

    if (renderer && scene && camera) {
      renderer.render(scene, camera);
    }
  }

  function handlePointerMove(e) {
    if (e.pointerType === 'touch' || !containerEl) return;
    const rect = containerEl.getBoundingClientRect();
    const x = (e.clientX - rect.left) / rect.width - 0.5;
    const y = (e.clientY - rect.top) / rect.height - 0.5;
    targetRotationY = x * 0.8;
    targetRotationX = y * 0.6;
  }

  function handlePointerLeave() {
    targetRotationX = 0;
    targetRotationY = 0;
  }

  function handleResize() {
    if (!containerEl || !camera || !renderer) return;
    const width = containerEl.clientWidth || 340;
    const height = containerEl.clientHeight || 300;
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
    renderer.setSize(width, height);
  }

  onMount(() => {
    initThree();
    window.addEventListener('resize', handleResize);
  });

  onDestroy(() => {
    if (typeof window !== 'undefined') {
      window.removeEventListener('resize', handleResize);
    }
    if (animationFrameId) {
      cancelAnimationFrame(animationFrameId);
    }
    if (renderer && renderer.domElement && containerEl) {
      containerEl.removeChild(renderer.domElement);
      renderer.dispose();
    }
  });
</script>

<div 
  class="quantum-sculpture {isCompliance ? 'ski' : 'vf'}" 
  onpointermove={handlePointerMove} 
  onpointerleave={handlePointerLeave}
  role="region"
  aria-label="3D Quantum Visualizer Core"
>
  <div class="canvas-mount" bind:this={containerEl}></div>
  <div class="glow-orb {isCompliance ? 'ski' : 'vf'}"></div>

  <div class="sculpture-hud">
    <span class="hud-badge">
      <Sparkles size={11} class="hud-icon" />
      <span>{isCompliance ? 'SKI NEURAL CORE' : 'VISITFLOW AI CORE'}</span>
    </span>
    <button 
      class="motion-toggle" 
      onclick={() => paused = !paused} 
      aria-label={paused ? 'Putar animasi 3D' : 'Jeda animasi 3D'} 
      aria-pressed={paused}
    >
      {#if paused}<Play size={12} />{:else}<Pause size={12} />{/if}
    </button>
  </div>
</div>

<style>
  .quantum-sculpture {
    position: relative;
    width: 340px;
    height: 300px;
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .canvas-mount {
    width: 100%;
    height: 100%;
    position: relative;
    z-index: 2;
    cursor: grab;
  }

  .canvas-mount:active {
    cursor: grabbing;
  }

  .glow-orb {
    position: absolute;
    width: 180px;
    height: 180px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(58, 194, 219, 0.35) 0%, rgba(37, 99, 235, 0.1) 60%, transparent 80%);
    filter: blur(28px);
    z-index: 1;
    pointer-events: none;
    animation: pulse-glow 6s ease-in-out infinite alternate;
  }

  .glow-orb.ski {
    background: radial-gradient(circle, rgba(56, 189, 248, 0.4) 0%, rgba(29, 78, 216, 0.15) 60%, transparent 80%);
  }

  .sculpture-hud {
    position: absolute;
    bottom: 4px;
    left: 12px;
    right: 12px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    z-index: 3;
    pointer-events: auto;
  }

  .hud-badge {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    padding: 3px 9px;
    border-radius: 9999px;
    background: var(--bg-surface);
    border: 1px solid var(--border-medium);
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 0.06em;
    color: var(--text-primary);
    box-shadow: var(--shadow-sm);
    backdrop-filter: blur(8px);
  }

  :global(.hud-icon) {
    color: var(--accent-primary);
  }

  .motion-toggle {
    display: grid;
    place-items: center;
    width: 28px;
    height: 28px;
    border: 1px solid var(--border-medium);
    border-radius: 50%;
    background: var(--bg-surface);
    color: var(--text-muted);
    box-shadow: var(--shadow-sm);
    cursor: pointer;
    transition: all 0.15s ease;
  }

  .motion-toggle:hover {
    color: var(--accent-primary);
    border-color: var(--accent-primary);
    transform: scale(1.06);
  }

  @keyframes pulse-glow {
    0% { transform: scale(0.9); opacity: 0.6; }
    100% { transform: scale(1.15); opacity: 1; }
  }

  @media (max-width: 600px) {
    .quantum-sculpture {
      width: 100%;
      height: 230px;
    }
    .glow-orb {
      width: 140px;
      height: 140px;
    }
  }
</style>
