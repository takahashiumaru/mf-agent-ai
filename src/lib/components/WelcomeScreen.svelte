<script>
  import { 
    Database, 
    Layers, 
    Stethoscope, 
    Terminal, 
    ArrowUpRight, 
    Handshake, 
    TrendingUp, 
    Receipt, 
    Network 
  } from '@lucide/svelte';
  import KnowledgeSculpture from './KnowledgeSculpture.svelte';

  let { 
    project = 'visitflow',
    onSelectPrompt = () => {} 
  } = $props();

  const visitflowSuggestions = [
    { 
      label: 'Call & Kunjungan Dokter', 
      detail: 'Pelajari alur pencatatan call & jadwal visit', 
      icon: Stethoscope, 
      prompt: 'Bagaimana alur pencatatan jadwal call dan syarat sah realisasi kunjungan dokter di VisitFlow?' 
    },
    { 
      label: 'Master Customer List (MCL)', 
      detail: 'Kelola daftar dokter target & segmentasi', 
      icon: Database, 
      prompt: 'Jelaskan struktur data Master Customer List (MCL) dan relasi dokter di VisitFlow.' 
    },
    { 
      label: 'Geotagging & Check-in', 
      detail: 'Aturan validasi lokasi GPS saat kunjungan', 
      icon: Layers, 
      prompt: 'Bagaimana aturan validasi geotagging radius GPS saat dokter atau outlet dikunjungi?' 
    },
    { 
      label: 'Approval & Reporting', 
      detail: 'Alur persetujuan visit & rekap laporan', 
      icon: Terminal, 
      prompt: 'Bagaimana alur approval rencana kunjungan dan rekap laporan call harian lapangan?' 
    }
  ];

  const complianceSuggestions = [
    { 
      label: 'Kesepakatan Dokter (SKI)', 
      detail: 'Alur komitmen & proposal kerjasama dokter', 
      icon: Handshake, 
      prompt: 'Bagaimana alur pengajuan dan verifikasi kesepakatan kerjasama dokter (SKI)?' 
    },
    { 
      label: 'Realisasi Sales FF', 
      detail: 'Data transaksi sales_ffs & capaian value', 
      icon: TrendingUp, 
      prompt: 'Jelaskan struktur tabel sales_ffs dan formula perhitungan Value Sales Final serta diskon.' 
    },
    { 
      label: 'Credit Notes (SPC)', 
      detail: 'Aturan Nota Kredit & adjustment sales', 
      icon: Receipt, 
      prompt: 'Bagaimana konsep dan aturan pencatatan SPC (Credit Notes) pada data sales dan laporan SKI?' 
    },
    { 
      label: 'Bridging Outlet & Produk', 
      detail: 'Pemetaan data distributor ke master SKI', 
      icon: Network, 
      prompt: 'Bagaimana alur dan fungsi bridging outlet serta produk distributor di SKI Compliance?' 
    }
  ];

  let isCompliance = $derived(project === 'ski-compliance');
  let currentSuggestions = $derived(isCompliance ? complianceSuggestions : visitflowSuggestions);
</script>

<section class="welcome" aria-labelledby="welcome-title">
  <div class="welcome-hero">
    <div class="hero-copy">
      <div class="eyebrow {isCompliance ? 'ski' : 'vf'}">
        <span class="eyebrow-dot {isCompliance ? 'ski' : 'vf'}"></span>
        <span>{isCompliance ? 'ASISTEN SKI COMPLIANCE' : 'ASISTEN VISITFLOW'}</span>
      </div>
      <h1 id="welcome-title">
        Tanyakan seputar<br />
        <span class={isCompliance ? 'ski' : 'vf'}>{isCompliance ? 'Ski Compliance.' : 'VisitFlow.'}</span>
      </h1>
      <p class="hero-description">
        {isCompliance 
          ? 'Tanyakan kesepakatan dokter (SKI), realisasi sales FF, credit notes (SPC), bridging outlet/produk, dan target marketing.' 
          : 'Tanyakan data kunjungan (call), MCL, profil dokter, atau pelajari cara kerja aplikasi VisitFlow.'}
      </p>
      <div class="source-note">
        <Layers size={15} class="source-note-icon {isCompliance ? 'ski' : 'vf'}" />
        <span>Tulis pertanyaan Anda untuk memulai.</span>
      </div>
    </div>
    <div class="hero-art"><KnowledgeSculpture {project} /></div>
  </div>
  <div class="explore-heading"><h2>Contoh topik yang bisa ditanyakan</h2><span>Pilih satu topik untuk mulai</span></div>
  <div class="suggestions">
    {#each currentSuggestions as item, i}
      {@const Icon = item.icon}
      <button class="suggestion {isCompliance ? 'ski' : 'vf'}" style:--index={i} onclick={() => onSelectPrompt(item.prompt)}>
        <span class="suggestion-icon {isCompliance ? 'ski' : 'vf'}"><Icon size={19} strokeWidth={1.5} /></span>
        <span class="suggestion-copy"><strong>{item.label}</strong><span>{item.detail}</span></span>
        <ArrowUpRight size={16} class="suggestion-arrow" />
      </button>
    {/each}
  </div>
</section>

<style>
  .welcome { width: 100%; max-width: 1040px; margin: auto; padding: 32px 48px 35px; }
  .welcome-hero { display: grid; grid-template-columns: minmax(0, 1.3fr) minmax(0, 1fr); align-items: center; min-height: 340px; gap: 16px; }
  .hero-copy { position: relative; z-index: 1; animation: enter 700ms both; }
  
  .eyebrow { 
    display: inline-flex; 
    align-items: center; 
    gap: 7px; 
    padding: 4px 12px 4px 10px; 
    background: rgba(58, 194, 219, 0.08); 
    border: 1px solid rgba(58, 194, 219, 0.22); 
    border-radius: 9999px; 
    color: var(--accent-primary); 
    font-family: var(--font-sans); 
    font-size: 11px; 
    font-weight: 700; 
    letter-spacing: 0.1em; 
    text-transform: uppercase; 
    margin-bottom: 20px; 
  }
  .eyebrow-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: var(--accent-primary);
    box-shadow: 0 0 8px var(--accent-primary);
  }

  .eyebrow.ski {
    background: rgba(56, 189, 248, 0.1);
    border-color: rgba(56, 189, 248, 0.3);
    color: #38bdf8;
  }
  .eyebrow-dot.ski {
    background: #38bdf8;
    box-shadow: 0 0 8px #38bdf8;
  }

  h1 { 
    font-family: var(--font-display); 
    font-size: clamp(34px, 3.8vw, 50px); 
    font-weight: 600; 
    line-height: 1.15; 
    letter-spacing: -0.04em; 
    color: var(--text-primary); 
  }
  h1 span.vf { 
    background: linear-gradient(135deg, #3ac2db 0%, #60a5fa 100%); 
    -webkit-background-clip: text; 
    -webkit-text-fill-color: transparent; 
    font-weight: 700; 
  }
  h1 span.ski { 
    background: linear-gradient(135deg, #38bdf8 0%, #2563eb 100%); 
    -webkit-background-clip: text; 
    -webkit-text-fill-color: transparent; 
    font-weight: 700; 
  }

  .hero-description { 
    max-width: 420px; 
    margin-top: 18px; 
    font-family: var(--font-sans); 
    font-size: 15px; 
    font-weight: 400; 
    color: var(--text-secondary); 
    line-height: 1.65; 
  }

  .source-note { 
    display: inline-flex; 
    align-items: center; 
    gap: 9px; 
    margin-top: 24px; 
    padding: 6px 14px; 
    border-radius: 8px; 
    background: rgba(66, 108, 178, 0.08); 
    border: 1px solid var(--border-subtle); 
    font-size: 12.5px; 
    font-weight: 500; 
    color: var(--text-secondary); 
  }
  :global(.source-note-icon) { 
    color: var(--accent-primary); 
    flex-shrink: 0; 
  }
  :global(.source-note-icon.ski) { 
    color: #38bdf8; 
  }

  .hero-art { display: flex; min-width: 0; justify-content: center; animation: art-enter 1000ms 120ms both; }
  .explore-heading { display: flex; align-items: baseline; justify-content: space-between; margin: 32px 0 16px; }
  .explore-heading h2 { font-size: 13.5px; font-weight: 600; color: var(--text-primary); letter-spacing: -0.01em; }
  .explore-heading > span { color: var(--text-muted); font-size: 12px; }
  .suggestions { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
  .suggestion { 
    display: flex; 
    align-items: center; 
    text-align: left; 
    gap: 14px; 
    padding: 16px 18px; 
    border: 1px solid var(--border-medium); 
    border-radius: 12px; 
    background: var(--bg-surface); 
    box-shadow: var(--shadow-sm);
    transition: transform 200ms, background 200ms, border-color 200ms, box-shadow 200ms; 
    animation: enter 650ms both; 
    animation-delay: calc(150ms + var(--index) * 65ms); 
  }
  .suggestion:hover { 
    transform: translateY(-2px); 
    background: var(--surface-tint-hover); 
    border-color: var(--accent-primary); 
    box-shadow: var(--shadow-md); 
  }
  .suggestion.ski:hover { 
    background: rgba(37, 99, 235, 0.08); 
    border-color: var(--accent-primary); 
    box-shadow: var(--shadow-md); 
  }
  .suggestion:active { transform: translateY(0) scale(.985); }
  .suggestion-icon { 
    display: grid; 
    place-items: center; 
    width: 38px; 
    height: 38px; 
    border: 1px solid var(--border-subtle); 
    border-radius: 10px; 
    color: var(--accent-primary); 
    background: var(--surface-tint); 
    flex-shrink: 0; 
  }
  .suggestion-icon.ski { color: #2563eb; background: rgba(37, 99, 235, 0.1); border-color: rgba(37, 99, 235, 0.2); }
  .suggestion-copy { display: flex; flex-direction: column; gap: 3px; flex: 1; }
  .suggestion-copy strong { font-size: 13.5px; font-weight: 600; color: var(--text-primary); }
  .suggestion-copy > span { font-size: 12px; line-height: 1.5; color: var(--text-secondary); }
  :global(.suggestion-arrow) { color: var(--text-muted); transition: transform 240ms, color 240ms; }
  .suggestion:hover :global(.suggestion-arrow) { transform: translate(2px,-2px); color: var(--accent-primary); }
  .suggestion.ski:hover :global(.suggestion-arrow) { color: #38bdf8; }
  @keyframes art-enter { from { opacity: 0; } to { opacity: 1; } }
  @keyframes enter { from { opacity: 0; transform: translateY(14px); } to { opacity: 1; transform: translateY(0); } }
  @media (max-width: 1100px) { .welcome { padding: 20px 28px; } h1 { font-size: 32px; } .hero-art { transform: scale(.75); } }
  @media (max-width: 600px) { .welcome { padding: 12px 20px 24px; } .welcome-hero { display: flex; flex-direction: column-reverse; gap: 0; align-items: flex-start; } .hero-art { height: 220px; width: 100%; transform: scale(.67); transform-origin: center top; } h1 { font-size: clamp(28px, 8vw, 34px); } .eyebrow { margin-bottom: 16px; } .hero-description { margin-top: 16px; font-size: 14px; } .source-note { margin-top: 17px; } .explore-heading { margin-top: 28px; } .explore-heading > span { display: none; } .suggestions { grid-template-columns: 1fr; } .suggestion { padding: 14px; } }
</style>
