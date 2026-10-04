<script>
  import { Download, FileImage, ChevronDown, TrendingUp, BarChart3, PieChart, GitCommit } from '@lucide/svelte';
  
  let { chart } = $props();
  let svgElement = $state(null);
  let exporting = $state(false);
  let exportError = $state('');
  let activeIndex = $state(null);

  const colors = ['#38bdf8', '#2563eb', '#3ac2db', '#10b981', '#a855f7', '#f59e0b', '#ec4899', '#6366f1'];
  const names = { bar: 'Grafik Batang', line: 'Grafik Tren Garis', donut: 'Diagram Komposisi', flow: 'Diagram Alur Proses' };

  // Formatter for compact axis/labels (e.g. "Rp 12,4 M", "Rp 306 Jt", "75 Rb")
  function formatCompact(val, unit = '') {
    if (val === null || val === undefined || isNaN(val)) return '0';
    const isCurrency = (unit && (unit.toUpperCase() === 'IDR' || unit.toUpperCase() === 'RP')) || Math.abs(val) >= 100000;
    const prefix = isCurrency ? 'Rp ' : '';
    const abs = Math.abs(val);
    const sign = val < 0 ? '-' : '';

    if (abs >= 1e12) {
      const num = (abs / 1e12).toLocaleString('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 2 });
      return `${prefix}${sign}${num} T`;
    }
    if (abs >= 1e9) {
      const num = (abs / 1e9).toLocaleString('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 2 });
      return `${prefix}${sign}${num} M`;
    }
    if (abs >= 1e6) {
      const num = (abs / 1e6).toLocaleString('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 2 });
      return `${prefix}${sign}${num} Jt`;
    }
    if (abs >= 1e3) {
      const num = (abs / 1e3).toLocaleString('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 1 });
      return `${prefix}${sign}${num} Rb`;
    }
    return `${prefix}${sign}${abs.toLocaleString('id-ID')}`;
  }

  // Verbal description for readable cards/tooltips (e.g. "Rp 12,44 Miliar", "Rp 306,33 Juta")
  function formatWord(val, unit = '') {
    if (val === null || val === undefined || isNaN(val)) return '0';
    const isCurrency = (unit && (unit.toUpperCase() === 'IDR' || unit.toUpperCase() === 'RP')) || Math.abs(val) >= 100000;
    const prefix = isCurrency ? 'Rp ' : '';
    const abs = Math.abs(val);
    const sign = val < 0 ? '-' : '';

    if (abs >= 1e12) {
      const num = (abs / 1e12).toLocaleString('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 2 });
      return `${prefix}${sign}${num} Triliun`;
    }
    if (abs >= 1e9) {
      const num = (abs / 1e9).toLocaleString('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 2 });
      return `${prefix}${sign}${num} Miliar`;
    }
    if (abs >= 1e6) {
      const num = (abs / 1e6).toLocaleString('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 2 });
      return `${prefix}${sign}${num} Juta`;
    }
    if (abs >= 1e3) {
      const num = (abs / 1e3).toLocaleString('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 1 });
      return `${prefix}${sign}${num} Ribu`;
    }
    return `${prefix}${sign}${abs.toLocaleString('id-ID')}`;
  }

  // Exact number with thousand separators
  function formatFull(val, unit = '') {
    if (val === null || val === undefined || isNaN(val)) return '0';
    const isCurrency = (unit && (unit.toUpperCase() === 'IDR' || unit.toUpperCase() === 'RP')) || Math.abs(val) >= 100000;
    const prefix = isCurrency ? 'Rp ' : '';
    return `${prefix}${new Intl.NumberFormat('id-ID').format(val)}`;
  }

  const short = (value, limit) => value && value.length > limit ? value.slice(0, limit - 1) + '…' : (value || '');

  const total = $derived((chart.values || []).reduce((sum, value) => sum + (Number(value) || 0), 0));
  const min = $derived(Math.min(0, ...(chart.values || [0])));
  const max = $derived(Math.max(0, ...(chart.values || [1])));
  const range = $derived(max - min || 1);
  const avg = $derived(chart.values && chart.values.length > 0 ? total / chart.values.length : 0);

  // Highest & Lowest points
  const maxPointIndex = $derived(
    chart.values && chart.values.length > 0 
      ? chart.values.indexOf(Math.max(...chart.values)) 
      : -1
  );
  const minPointIndex = $derived(
    chart.values && chart.values.length > 0 
      ? chart.values.indexOf(Math.min(...chart.values)) 
      : -1
  );

  const height = $derived(
    chart.type === 'bar' ? (chart.labels || []).length * 44 + 130 :
    chart.type === 'flow' ? (chart.steps || []).length * 88 + 100 :
    chart.type === 'donut' ? Math.max(360, (chart.labels || []).length * 28 + 130) : 340
  );

  const barX = value => 180 + ((value - min) / range) * 380;
  const lineX = index => (chart.values || []).length <= 1 ? 380 : 85 + (index / ((chart.values || []).length - 1)) * 590;
  const lineY = value => 245 - ((value - min) / range) * 155;

  const linePoints = $derived((chart.values || []).map((value, index) => `${lineX(index)},${lineY(value)}`).join(' '));
  const areaPoints = $derived(
    chart.values && chart.values.length > 0
      ? `${lineX(0)},245 ${linePoints} ${lineX(chart.values.length - 1)},245`
      : ''
  );

  function wrap(value) {
    if (!value) return [''];
    if (value.length <= 50) return [value];
    return value.match(/.{1,48}(?:\s|$)|\S{1,48}/g)?.map(line => line.trim()).filter(Boolean) || [value];
  }

  async function download(format) {
    if (!svgElement || exporting) return;
    exporting = true;
    exportError = '';
    let imageUrl;
    let downloadUrl;
    try {
      const clone = svgElement.cloneNode(true);
      clone.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
      clone.setAttribute('width', '760');
      clone.setAttribute('height', String(height));
      const originals = [svgElement, ...svgElement.querySelectorAll('*')];
      const copies = [clone, ...clone.querySelectorAll('*')];
      originals.forEach((element, index) => {
        const style = getComputedStyle(element);
        for (const property of ['fill', 'stroke', 'font-family', 'font-size', 'font-weight']) {
          copies[index].style.setProperty(property, style.getPropertyValue(property));
        }
      });
      const svgBlob = new Blob([new XMLSerializer().serializeToString(clone)], { type: 'image/svg+xml;charset=utf-8' });
      let result = svgBlob;
      if (format === 'png') {
        imageUrl = URL.createObjectURL(svgBlob);
        const img = new Image();
        await new Promise((resolve, reject) => { img.onload = resolve; img.onerror = () => reject(new Error('Gambar gagal dibuat.')); img.src = imageUrl; });
        const canvas = document.createElement('canvas');
        canvas.width = 1520;
        canvas.height = height * 2;
        const context = canvas.getContext('2d');
        if (!context) throw new Error('Browser tidak mendukung ekspor gambar.');
        context.drawImage(img, 0, 0, canvas.width, canvas.height);
        result = await new Promise(resolve => canvas.toBlob(resolve, 'image/png'));
        if (!result) throw new Error('Gambar gagal dibuat.');
      }
      downloadUrl = URL.createObjectURL(result);
      const link = document.createElement('a');
      link.href = downloadUrl;
      link.download = `visualisasi-${(chart.title || 'grafik').replace(/[^a-z0-9]+/gi, '-').slice(0, 70)}.${format}`;
      document.body.appendChild(link);
      link.click();
      link.remove();
    } catch (error) {
      exportError = error.message || 'Gambar gagal diunduh. Silakan coba lagi.';
    } finally {
      if (imageUrl) URL.revokeObjectURL(imageUrl);
      if (downloadUrl) setTimeout(() => URL.revokeObjectURL(downloadUrl), 1000);
      exporting = false;
    }
  }
</script>

<figure class="visualization">
  <!-- Toolbar Header -->
  <div class="chart-toolbar">
    <div class="toolbar-title-wrap">
      {#if chart.type === 'line'}<TrendingUp size={14} class="tool-icon" />
      {:else if chart.type === 'bar'}<BarChart3 size={14} class="tool-icon" />
      {:else if chart.type === 'donut'}<PieChart size={14} class="tool-icon" />
      {:else}<GitCommit size={14} class="tool-icon" />{/if}
      <span class="tool-name">{names[chart.type] || 'Visualisasi'}</span>
    </div>
    <div class="export-actions">
      <button onclick={() => download('png')} disabled={exporting} title="Unduh PNG"><FileImage size={13} /> PNG</button>
      <button onclick={() => download('svg')} disabled={exporting} title="Unduh SVG"><Download size={13} /> SVG</button>
    </div>
  </div>

  <!-- Quick Stat Summary Cards (Above Chart) -->
  {#if chart.values && chart.values.length > 0 && chart.type !== 'flow'}
    <div class="stat-summary-bar">
      <div class="stat-pill">
        <span class="stat-label">TOTAL</span>
        <strong class="stat-val highlight">{formatWord(total, chart.unit)}</strong>
      </div>
      <div class="stat-pill">
        <span class="stat-label">RATA-RATA</span>
        <strong class="stat-val">{formatWord(avg, chart.unit)}</strong>
      </div>
      {#if maxPointIndex >= 0}
        <div class="stat-pill">
          <span class="stat-label">TERTINGGI</span>
          <strong class="stat-val success">{formatWord(chart.values[maxPointIndex], chart.unit)} <small>({chart.labels[maxPointIndex]})</small></strong>
        </div>
      {/if}
      {#if minPointIndex >= 0 && minPointIndex !== maxPointIndex}
        <div class="stat-pill">
          <span class="stat-label">TERENDAH</span>
          <strong class="stat-val warning">{formatWord(chart.values[minPointIndex], chart.unit)} <small>({chart.labels[minPointIndex]})</small></strong>
        </div>
      {/if}
    </div>
  {/if}

  <!-- SVG Chart Container -->
  <div class="chart-scroll">
    <svg 
      bind:this={svgElement} 
      viewBox="0 0 760 {height}" 
      role="img" 
      aria-label={chart.title} 
      style="font-family: 'Space Grotesk', Manrope, -apple-system, sans-serif"
    >
      <defs>
        <!-- Gradient for line area -->
        <linearGradient id="area-cyan-grad" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stop-color="#38bdf8" stop-opacity="0.35" />
          <stop offset="100%" stop-color="#38bdf8" stop-opacity="0.0" />
        </linearGradient>
        <linearGradient id="bar-blue-grad" x1="0" y1="0" x2="1" y2="0">
          <stop offset="0%" stop-color="#2563eb" />
          <stop offset="100%" stop-color="#38bdf8" />
        </linearGradient>
      </defs>

      <title>{chart.title}</title>
      <desc>{chart.description || names[chart.type]}. {chart.source}</desc>
      
      <!-- Background Card -->
      <rect width="760" {height} rx="12" fill="var(--bg-surface)" />
      
      <!-- Title & Unit Header -->
      <text x="28" y="34" font-size="16" font-weight="700" fill="var(--text-primary)">{short(chart.title, 72)}</text>
      <text x="28" y="54" font-size="11" font-weight="500" fill="var(--text-muted)">
        {chart.unit ? `Satuan: ${chart.unit}` : ''} • Nilai dihitung dalam format Juta (Jt) & Miliar (M)
      </text>

      <!-- BAR CHART -->
      {#if chart.type === 'bar'}
        <!-- Axis Guides -->
        {#each [min, min + range * 0.33, min + range * 0.66, min + range] as tick}
          <line x1={barX(tick)} x2={barX(tick)} y1="75" y2={height - 50} stroke="var(--border-subtle)" stroke-dasharray="3,3" />
          <text x={barX(tick)} y="70" text-anchor="middle" font-size="10" font-weight="600" fill="var(--text-muted)">
            {formatCompact(tick, chart.unit)}
          </text>
        {/each}

        <!-- Bars -->
        {#each chart.values as value, index}
          {@const yPos = index * 44 + 88}
          {@const bWidth = Math.max(3, Math.abs(barX(value) - barX(0)))}
          
          <!-- Label on Left -->
          <text x="170" y={yPos + 17} text-anchor="end" font-size="12" font-weight="600" fill="var(--text-primary)">
            <title>{chart.labels[index]}</title>
            {short(chart.labels[index], 20)}
          </text>

          <!-- Bar Pill -->
          <rect 
            x={Math.min(barX(0), barX(value))} 
            y={yPos} 
            width={bWidth} 
            height="26" 
            rx="5" 
            fill="url(#bar-blue-grad)"
            opacity={activeIndex === index ? 1 : 0.88}
            role="graphics-symbol"
            aria-label="{chart.labels[index]}: {formatWord(value, chart.unit)}"
            onmouseenter={() => { activeIndex = index; }}
            onmouseleave={() => { activeIndex = null; }}
          >
            <title>{chart.labels[index]}: {formatWord(value, chart.unit)} ({formatFull(value, chart.unit)})</title>
          </rect>

          <!-- Formatted Value Badge on Right (Juta/Miliar) -->
          <text x="575" y={yPos + 17} font-size="11.5" font-weight="700" fill="#38bdf8">
            {formatWord(value, chart.unit)}
          </text>
        {/each}

      <!-- LINE CHART -->
      {:else if chart.type === 'line'}
        <!-- Y-Axis Grid Lines & Compact Ticks (Juta / Miliar) -->
        {#each [min, min + range * 0.33, min + range * 0.66, min + range] as tick}
          <line x1="80" x2="685" y1={lineY(tick)} y2={lineY(tick)} stroke="var(--border-subtle)" stroke-dasharray="4,4" />
          <text x="72" y={lineY(tick) + 4} text-anchor="end" font-size="10.5" font-weight="600" fill="var(--text-muted)">
            {formatCompact(tick, chart.unit)}
          </text>
        {/each}

        <!-- Area Under Line -->
        {#if areaPoints}
          <polygon points={areaPoints} fill="url(#area-cyan-grad)" />
        {/if}

        <!-- Smooth Polyline -->
        <polyline 
          points={linePoints} 
          fill="none" 
          stroke="#38bdf8" 
          stroke-width="3" 
          stroke-linecap="round" 
          stroke-linejoin="round" 
        />

        <!-- Data Points & Labels -->
        {#each chart.values as value, index}
          {@const cx = lineX(index)}
          {@const cy = lineY(value)}
          {@const isMax = index === maxPointIndex}
          {@const isMin = index === minPointIndex && chart.values.length > 2}
          {@const isHovered = activeIndex === index}
          
          <!-- Invisible larger hover zone -->
          <circle 
            {cx} {cy} r="18" fill="transparent" cursor="pointer"
            role="graphics-symbol"
            aria-label="{chart.labels[index]}: {formatWord(value, chart.unit)}"
            onmouseenter={() => { activeIndex = index; }}
            onmouseleave={() => { activeIndex = null; }}
          >
            <title>{chart.labels[index]}: {formatWord(value, chart.unit)} ({formatFull(value, chart.unit)})</title>
          </circle>

          <!-- Outer glow circle -->
          <circle 
            {cx} {cy} 
            r={isHovered ? 8 : 5} 
            fill={isHovered ? '#38bdf8' : '#0f172a'} 
            stroke={isMax ? '#10b981' : isMin ? '#f59e0b' : '#38bdf8'} 
            stroke-width={isHovered ? 3 : 2} 
          />
          <circle {cx} {cy} r="2.5" fill={isHovered ? '#ffffff' : '#38bdf8'} />

          <!-- Value Tag: show for Peak (isMax), Lowest (isMin), or when Hovered (isHovered) -->
          {#if isHovered || (isMax && activeIndex === null) || (isMin && activeIndex === null)}
            <g transform="translate({cx}, {cy - (isHovered ? 32 : 24)})" pointer-events="none">
              <rect 
                x="-44" 
                y="-14" 
                width="88" 
                height="20" 
                rx="4" 
                fill="#0f172a" 
                stroke={isHovered ? '#38bdf8' : isMax ? '#10b981' : '#f59e0b'} 
                stroke-width="1.2" 
              />
              <text text-anchor="middle" y="0.5" font-size="9.5" font-weight="700" fill={isHovered ? '#38bdf8' : isMax ? '#34d399' : '#fbbf24'}>
                {formatCompact(value, chart.unit)}
              </text>
            </g>
          {/if}

          <!-- X-Axis Label -->
          {#if index % Math.ceil(chart.labels.length / 8) === 0 || index === chart.labels.length - 1}
            <text x={cx} y="268" text-anchor="middle" font-size="10.5" font-weight="600" fill="var(--text-secondary)">
              {short(chart.labels[index], 12)}
            </text>
          {/if}
        {/each}

      <!-- DONUT CHART -->
      {:else if chart.type === 'donut'}
        {@const donutY = (chart.labels || []).length > 8 ? 160 : 195}
        <circle cx="170" cy={donutY} r="75" fill="none" stroke="var(--border-subtle)" stroke-width="32" />
        {#each chart.values as value, index}
          {@const share = total > 0 ? (value / total) * 100 : 0}
          {@const offset = total > 0 ? (chart.values.slice(0, index).reduce((sum, item) => sum + item, 0) / total) * 100 : 0}
          <circle 
            cx="170" 
            cy={donutY} 
            r="75" 
            pathLength="100" 
            fill="none" 
            stroke={colors[index % colors.length]} 
            stroke-width="32" 
            stroke-dasharray="{share} {100 - share}" 
            stroke-dashoffset={-offset} 
            transform="rotate(-90 170 {donutY})"
          >
            <title>{chart.labels[index]}: {formatWord(value, chart.unit)} ({share.toFixed(1)}%)</title>
          </circle>

          <!-- Legend item on right with responsive coordinate bounds -->
          <g transform="translate(305, {index * 26 + 82})">
            <rect x="0" y="0" width="9" height="9" rx="2.5" fill={colors[index % colors.length]} />
            <text x="16" y="9" font-size="11.5" font-weight="600" fill="var(--text-primary)">
              {short(chart.labels[index], 20)}
            </text>
            <text x="415" y="9" text-anchor="end" font-size="11.5" font-weight="700" fill="#38bdf8">
              {formatWord(value, chart.unit)} <tspan font-weight="400" font-size="10" fill="var(--text-muted)">({share.toFixed(1)}%)</tspan>
            </text>
          </g>
        {/each}

        <!-- Center Total Text -->
        <text x="170" y={donutY - 5} text-anchor="middle" font-size="18" font-weight="700" fill="var(--text-primary)">
          {formatCompact(total, chart.unit)}
        </text>
        <text x="170" y={donutY + 14} text-anchor="middle" font-size="10" font-weight="600" fill="var(--text-muted)">
          TOTAL
        </text>

      <!-- FLOW CHART -->
      {:else if chart.type === 'flow'}
        {#each chart.steps as step, index}
          {@const lines = wrap(step)}
          {@const cardH = Math.max(60, lines.length * 20 + 26)}
          {@const yPos = index * 92 + 80}
          <rect x="110" y={yPos} width="540" height={cardH} rx="10" fill="var(--bg-surface-hover)" stroke="rgba(56, 189, 248, 0.35)" stroke-width="1.2" />
          
          <!-- Step Badge -->
          <rect x="125" y={yPos + 18} width="26" height="24" rx="6" fill="#2563eb" />
          <text x="138" y={yPos + 34} text-anchor="middle" font-size="11" font-weight="700" fill="#ffffff">
            {index + 1}
          </text>

          <text x="165" y={yPos + (lines.length > 1 ? 26 : 34)} font-size="12" font-weight="600" fill="var(--text-primary)">
            {#each lines as line, lineIndex}
              <tspan x="165" dy={lineIndex ? 18 : 0}>{line}</tspan>
            {/each}
          </text>
          
          {#if index < chart.steps.length - 1}
            <line x1="380" x2="380" y1={yPos + cardH} y2={yPos + cardH + 18} stroke="#38bdf8" stroke-width="2" />
            <polygon points="376,{yPos + cardH + 13} 384,{yPos + cardH + 13} 380,{yPos + cardH + 18}" fill="#38bdf8" />
          {/if}
        {/each}
      {/if}

      <!-- Footer Source -->
      {#if chart.source}
        <text x="28" y={height - 15} font-size="9.5" font-weight="500" fill="var(--text-muted)">
          {short(chart.source, 120)}
        </text>
      {/if}
    </svg>
  </div>

  {#if chart.description}
    <figcaption>{chart.description}</figcaption>
  {/if}
  {#if chart.source}
    <p class="chart-source">Sumber: {chart.source}</p>
  {/if}
  {#if exportError}
    <p class="export-error" role="alert">{exportError}</p>
  {/if}

  <!-- Collapsible Detailed Data Breakdown Table -->
  <details class="data-details">
    <summary>
      <ChevronDown size={14} class="details-chevron" />
      <span>{chart.type === 'flow' ? 'Lihat ringkasan langkah alur' : 'Lihat rincian data lengkap (Juta / Miliar & Nominal Asli)'}</span>
    </summary>
    
    {#if chart.type === 'flow'}
      <ol class="flow-list">
        {#each chart.steps as step}<li>{step}</li>{/each}
      </ol>
    {:else}
      <div class="table-responsive">
        <table class="breakdown-table">
          <thead>
            <tr>
              <th>Kategori / Periode</th>
              <th class="text-right">Nilai Ringkas</th>
              <th class="text-right">Nominal Lengkap (Rp)</th>
              <th class="text-right">Kontribusi</th>
            </tr>
          </thead>
          <tbody>
            {#each (chart.labels || []) as label, index}
              {@const val = chart.values[index]}
              {@const pct = total > 0 ? ((val / total) * 100).toFixed(1) : '0'}
              <tr>
                <td class="font-medium">{label}</td>
                <td class="text-right font-bold text-accent">{formatWord(val, chart.unit)}</td>
                <td class="text-right text-muted">{formatFull(val, chart.unit)}</td>
                <td class="text-right"><span class="pct-badge">{pct}%</span></td>
              </tr>
            {/each}
          </tbody>
          {#if total > 0}
            <tfoot>
              <tr>
                <th>TOTAL</th>
                <th class="text-right text-accent">{formatWord(total, chart.unit)}</th>
                <th class="text-right">{formatFull(total, chart.unit)}</th>
                <th class="text-right"><span class="pct-badge full">100%</span></th>
              </tr>
            </tfoot>
          {/if}
        </table>
      </div>
    {/if}
  </details>
</figure>

<style>
  .visualization { 
    margin: 18px 0; 
    border: 1px solid var(--border-medium); 
    border-radius: 12px; 
    background: var(--bg-surface); 
    overflow: hidden; 
    box-shadow: var(--shadow-md);
  }
  
  .chart-toolbar { 
    display: flex; 
    align-items: center; 
    justify-content: space-between; 
    gap: 10px; 
    padding: 10px 16px; 
    background: var(--surface-tint);
    border-bottom: 1px solid var(--border-subtle); 
    color: var(--text-secondary); 
    font-size: 11.5px; 
  }

  .toolbar-title-wrap {
    display: flex;
    align-items: center;
    gap: 6px;
    font-weight: 600;
    color: var(--text-primary);
  }

  :global(.tool-icon) {
    color: var(--accent-primary);
  }

  .export-actions { 
    display: flex; 
    gap: 6px; 
  }
  
  .export-actions button { 
    display: flex; 
    align-items: center; 
    gap: 5px; 
    border: 1px solid var(--border-medium); 
    border-radius: 6px; 
    padding: 4px 9px; 
    font-size: 11px; 
    font-weight: 600;
    background: var(--bg-surface);
    color: var(--text-primary); 
    cursor: pointer;
    box-shadow: var(--shadow-sm);
    transition: all 0.15s ease;
  }
  
  .export-actions button:hover { 
    background: var(--bg-surface-hover); 
    border-color: var(--accent-primary);
    color: var(--accent-primary);
  }
  
  .export-actions button:disabled { 
    opacity: .5; 
  }

  .stat-summary-bar {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
    gap: 10px;
    padding: 12px 16px;
    background: var(--surface-tint);
    border-bottom: 1px solid var(--border-subtle);
  }

  .stat-pill {
    display: flex;
    flex-direction: column;
    gap: 3px;
    padding: 8px 12px;
    background: var(--bg-surface);
    border: 1px solid var(--border-medium);
    border-radius: var(--radius-sm);
    box-shadow: var(--shadow-sm);
  }

  .stat-label {
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 0.05em;
    color: var(--text-secondary);
  }

  .stat-val {
    font-size: 13.5px;
    font-weight: 700;
    color: var(--text-primary);
  }

  .stat-val.highlight {
    color: var(--accent-primary);
  }

  .stat-val.success {
    color: var(--accent-emerald);
  }

  .stat-val.warning {
    color: var(--accent-amber);
  }

  .stat-val small {
    font-size: 10.5px;
    font-weight: 500;
    color: var(--text-muted);
  }

  .chart-scroll { 
    overflow-x: auto; 
    padding: 12px 14px 8px;
    background: var(--bg-surface);
  }
  
  svg { 
    display: block; 
    width: 100%; 
    min-width: 540px; 
    height: auto; 
  }
  
  figcaption, .chart-source, .export-error { 
    padding: 8px 16px 10px; 
    font-size: 12px; 
    line-height: 1.6; 
    color: var(--text-secondary); 
  }
  
  .chart-source {
    font-size: 11px;
    color: var(--text-muted);
    padding-top: 0;
  }

  .export-error { 
    color: var(--danger-text); 
  }
  
  .data-details { 
    border-top: 1px solid var(--border-subtle); 
    padding: 10px 16px; 
    font-size: 12px; 
    background: var(--surface-tint);
  }
  
  summary { 
    display: flex; 
    align-items: center; 
    gap: 6px; 
    cursor: pointer; 
    font-weight: 600;
    color: var(--text-secondary); 
    user-select: none;
  }

  summary:hover {
    color: #38bdf8;
  }

  :global(.details-chevron) {
    transition: transform 0.2s ease;
  }

  details[open] :global(.details-chevron) {
    transform: rotate(180deg);
  }
  
  .table-responsive {
    overflow-x: auto;
    margin-top: 10px;
  }

  .breakdown-table { 
    width: 100%; 
    border-collapse: collapse; 
    font-size: 12px;
  }
  
  .breakdown-table th, .breakdown-table td { 
    padding: 7px 10px; 
    border-bottom: 1px solid var(--border-subtle); 
  }
  
  .breakdown-table th {
    font-weight: 600;
    color: var(--text-muted);
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.03em;
  }

  .text-right {
    text-align: right;
  }

  .font-medium {
    font-weight: 500;
    color: var(--text-primary);
  }

  .font-bold {
    font-weight: 700;
  }

  .text-accent {
    color: #38bdf8;
  }

  .text-muted {
    color: var(--text-muted);
    font-family: var(--font-mono);
    font-size: 11px;
  }

  .pct-badge {
    display: inline-block;
    padding: 1px 6px;
    border-radius: 4px;
    background: rgba(56, 189, 248, 0.12);
    color: #38bdf8;
    font-weight: 700;
    font-size: 10.5px;
    font-family: var(--font-mono);
  }

  .pct-badge.full {
    background: rgba(16, 185, 129, 0.15);
    color: #10b981;
  }

  .breakdown-table tfoot th {
    padding-top: 10px;
    border-top: 2px solid var(--border-medium);
    border-bottom: none;
    font-size: 12px;
    font-weight: 700;
  }

  @media (max-width: 640px) {
    .visualization {
      margin: 12px 0;
      border-radius: 8px;
    }

    .chart-toolbar {
      flex-direction: column;
      align-items: flex-start;
      gap: 8px;
      padding: 10px 12px;
    }

    .export-actions {
      width: 100%;
      justify-content: flex-end;
    }

    .stat-summary-bar {
      padding: 8px 10px;
      gap: 6px;
    }

    .stat-pill {
      flex: 1 1 calc(50% - 6px);
      min-width: 110px;
      padding: 4px 8px;
    }

    .stat-val {
      font-size: 11.5px;
    }

    .chart-scroll {
      padding: 4px 6px 4px;
      -webkit-overflow-scrolling: touch;
    }

    figcaption, .chart-source, .export-error, .data-details {
      padding-left: 12px;
      padding-right: 12px;
    }
  }

  .flow-list { 
    margin: 10px 0 0; 
    padding-left: 20px; 
  }
  
  .flow-list li { 
    margin: 6px 0; 
    color: var(--text-primary);
  }
</style>
