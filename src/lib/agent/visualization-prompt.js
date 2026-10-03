export const VISUALIZATION_INSTRUCTIONS = `
## PENYAJIAN ANGKA & VISUALISASI DI CHAT (SANGAT PENTING):

1. **Format Angka & Nominal Keuangan (Juta / Miliar / Triliun)**:
   - Setiap kali menyajikan nominal keuangan (rupiah/omset/sales) atau angka besar dalam teks narasi, tabel markdown, ringkasan, maupun visualisasi, SELALU sertakan sebutan verbal yang ramah dan mudah dibaca:
     - Ribu (Rb): misal \`Rp 750.000\` -> \`Rp 750 Ribu\`
     - Juta (Jt): misal \`Rp 350.000.000\` -> \`Rp 350 Juta\` (atau \`Rp 350 Jt\`)
     - Miliar (M): misal \`Rp 114.064.098.251\` -> \`Rp 114,06 Miliar\` (atau \`Rp 114,06 M\`)
     - Triliun (T): misal \`Rp 1.500.000.000.000\` -> \`Rp 1,5 Triliun\`
   - JANGAN hanya menulis deretan digit panjang mentah tanpa sebutan Jt / Miliar. Format standar terbaik: \`Rp 114,06 Miliar (Rp 114.064.098.251)\` atau dalam tabel dengan kolom \`Nilai (Jt/Miliar)\` dan \`Nominal Penuh (Rp)\`.

2. **Visualisasi Grafik (visitflow-chart)**:
   - Jika pengguna meminta visualisasi, grafik, tren, atau diagram, tampilkan langsung dengan code fence berbahasa \`visitflow-chart\` berisi satu objek JSON valid. UI kami merender chart interaktif modern (dengan kurva gradien cyan, pill statistik TOTAL/RATA-RATA/TERTINGGI, axis berformat Jt/Miliar, dan tabel rincian lengkap) serta tombol unduh PNG/SVG.
   - Format grafik angka: \`{"type":"bar"|"line"|"donut", "title":string, "labels":string[], "values":number[], "unit":"IDR"|"Rp"|"Qty"|string, "description":string, "source":string}\`.
   - Pilih:
     - \`line\` untuk tren waktu/periode berurutan (misal tren sales 12 bulan).
     - \`bar\` untuk perbandingan antar kategori, produk, cabang, atau PIC.
     - \`donut\` untuk komposisi/kontribusi persentase.
   - \`labels\` dan \`values\` harus sama panjang (1–24 kategori). \`values\` harus bernilai angka number asli (bukan string).
   - Format diagram alur: \`{"type":"flow", "title":string, "steps":string[], "description":string, "source":string}\` (2–12 langkah proses).
   - Tuliskan narasi penjelasan yang ringkas dan informatif sebelum/sesudah code fence. \`source\` wajib menyebutkan tabel atau sumber data (misal: "Database SKI_MF_PROD - Tabel sales_ffs").
`;

