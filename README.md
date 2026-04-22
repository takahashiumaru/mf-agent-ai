# AI Prompt Template

Template siap pakai untuk membangun AI assistant berbasis tool-calling. Cocok untuk berbagai use case: customer service, internal support, helpdesk, e-commerce, dan lainnya.

---

## Struktur File

```
├── README.md          ← Panduan ini
├── endpoints.json     ← Konfigurasi URL & token API
├── system.md          ← System prompt (kepribadian & cara kerja AI)
├── rules.md           ← Aturan perilaku AI
└── tools.md           ← Dokumentasi tool yang bisa dipanggil AI
```

---

## Cara Menggunakan Template Ini

### Langkah 1 — Clone & Siapkan Project

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

### Langkah 2 — Isi `system.md`

File ini adalah **system prompt** yang menentukan identitas dan cara kerja AI.

Ganti bagian berikut:
- `[NAMA_AI]` → nama AI kamu, misalnya `Aria`, `Max`, `Budi`
- `[DESKRIPSI_SINGKAT_PERAN]` → contoh: `asisten virtual`, `agen support`
- `[NAMA_PERUSAHAAN/PRODUK]` → nama brand atau produk kamu
- `[TUGAS_1..3]` → daftar tugas yang bisa dilakukan AI

**Contoh hasil akhir:**
```
Nama kamu Aria, asisten virtual untuk platform e-commerce ShopNow.
Tugasmu adalah membantu pengguna dengan:
- Cek status order
- Informasi produk
- Proses pengembalian barang
```

### Langkah 3 — Isi `rules.md`

File ini berisi **aturan keras** yang mengontrol perilaku AI. Sesuaikan:
- `[JENIS_DATA]` → jenis data yang dikelola, contoh: `order`, `produk`, `tiket`
- `[IDENTIFIER_UTAMA/SEKUNDER/TERSIER]` → cara mencari data pengguna, contoh: `order_id`, `email`, `phone`
- Tambah atau hapus aturan sesuai kebutuhan domain kamu

### Langkah 4 — Isi `tools.md`

File ini **mendokumentasikan API/fungsi** yang bisa dipanggil AI. Untuk setiap tool:

1. Ganti deskripsi `function_one` dan `function_two` dengan fungsi asli kamu
2. Sesuaikan tabel **parameter** dengan input yang diterima API-mu
3. Ganti **contoh response** dengan struktur JSON yang dikembalikan API-mu
4. Update tabel **keterangan field** sesuai field yang ada
5. Sesuaikan aturan konfirmasi untuk aksi destructive (delete, reset, dll)

> Jika kamu hanya punya satu tool, hapus bagian `function_two`.  
> Jika kamu punya lebih dari dua tool, duplikasi blok yang ada.

### Langkah 5 — Isi `endpoints.json`

```json
{
  "function_one": {
    "url": "https://api.yourapp.com/endpoint-kamu",
    "token": "Bearer token-kamu",
    "method": "GET"
  },
  "function_two": {
    "url": "https://api.yourapp.com/endpoint-aksi",
    "token": "Bearer token-kamu",
    "method": "POST"
  }
}
```

> **Jangan commit token asli ke repository publik.** Gunakan environment variable atau secret manager.

---

## Konsep Utama

### System Prompt (`system.md`)
Mendefinisikan **siapa** AI ini dan **apa** yang boleh/tidak boleh dilakukan. Ini adalah instruksi tingkat tinggi yang dibaca AI di awal setiap sesi.

### Rules (`rules.md`)
Aturan **perilaku** yang lebih spesifik dan ketat. Misalnya: kapan harus pakai tool, bagaimana menangani error, apa yang tidak boleh diekspos.

### Tools (`tools.md`)
Dokumentasi **fungsi eksternal** yang bisa dipanggil AI untuk mengambil atau mengubah data. AI butuh dokumentasi ini untuk tahu kapan dan bagaimana memanggil setiap tool.

### Endpoints (`endpoints.json`)
Konfigurasi teknis (URL + token) yang dipisah dari dokumentasi agar mudah diganti tanpa mengubah prompt.

---

## Format Plan (JSON)

AI berkomunikasi dengan sistem menggunakan format **plan** — daftar langkah berurutan dalam JSON:

```json
{
  "plan": [
    {
      "step": 1,
      "action": "function_one",
      "parameters": { "param1": "nilai" }
    },
    {
      "step": 2,
      "action": "function_two",
      "parameters": { "id": "{{step1.data.id}}", "note": "aksi" }
    }
  ]
}
```

---

## Tips

- **Semakin spesifik system prompt, semakin konsisten perilaku AI.** Hindari instruksi ambigu.
- **Pisahkan aksi read dan write** ke tool yang berbeda agar kontrol akses lebih mudah.
- **Selalu minta konfirmasi** sebelum menjalankan aksi yang tidak bisa di-undo (delete, reset, kirim email, dll).
- **Uji dengan edge case**: data tidak ditemukan, identifier salah, pengguna tidak menyebut ID.

---

## Lisensi

MIT — bebas digunakan dan dimodifikasi untuk keperluan pribadi maupun komersial.