# Tools Documentation Template

<!--
  File ini mendokumentasikan semua tool (fungsi/API) yang bisa dipanggil oleh AI.
  Sesuaikan setiap bagian dengan tool yang kamu miliki.
-->

## Konfigurasi Endpoint

URL dan token untuk setiap tool dikonfigurasi di file `endpoints.json`.
Format:

```json
{
  "nama_tool": {
    "url": "https://your-api.com/endpoint",
    "token": "Bearer token-kamu-disini",
    "method": "GET atau POST"
  }
}
```

Untuk menambah tool baru dengan endpoint berbeda, cukup tambahkan entri baru di `endpoints.json` — tidak perlu ubah kode.

---

## Tools yang Tersedia

### get_doctors

Mencari data dokter (customer) dari sistem API.

Gunakan tool ini **setiap kali** ada pertanyaan terkait pencarian data dokter, customer, dengan bisa memfilter berdasarkan nama, kota, spesialis, dan posisi.

**Parameter:**

| Parameter | Tipe | Wajib | Keterangan |
|---|---|---|---|
| `name.like` | string | Tidak | Mencari dokter berdasarkan nama (contoh: "dia", "budi") |
| `city_id.eq` | string | Tidak | Filter ID kota (contoh: "DKI", "MES") |
| `customer_specialist_id.eq` | string | Tidak | Filter berdasarkan ID spesialis (contoh: "27" untuk SP.MK) |
| `customer_position_id.eq` | string | Tidak | Filter posisi customer (contoh: "7" untuk DOKTER PRAKTEK) |
| `customers.id.like` | string | Tidak | Pencarian berdasarkan ID Dokter / Customer secara persis / kemiripan |
| `ktp.like` | string | Tidak | Nomor KTP dokter |
| `npwp.like` | string | Tidak | Nomor NPWP dokter |
| `limit` | string | Tidak | Jumlah hasil maksimal per halaman (default 100) |
| `page` | string | Tidak | Halaman hasil pencarian (default 1) |

> **Pastikan Anda meneruskan parameter sebagai query string sesuai parameter di atas jika diminta pengguna.**

**Contoh response yang dikembalikan:**

```json
{
  "code": 200,
  "message": "OK",
  "data": [
    {
      "id": "23060024",
      "name": "VIDYAPATI WIDIARTO MANGUNKUSUMO",
      "phone": "+628111111111",
      "gender": "Laki-laki",
      "email": "vidya@gmail.com",
      "ktp": "3203012502306009",
      "npwp": "00.000.000.0-000.000",
      "customer_specialist_id": 27,
      "customer_position_id": 7,
      "city": { "id": "DKI", "name": "DKI JAKARTA" },
      "customer_specialist": { "title": "SP.MK", "description": "SP.MK - SPESIALIS MIKROBIOLOGI KLINIK" },
      "customer_position": { "name": "DOKTER PRAKTEK ( USER )" }
    }
  ]
}
```

**Keterangan field penting:**

| Field | Keterangan |
|---|---|
| `id` | ID unik dokter / customer |
| `name` | Nama dokter |
| `phone` | Nomor telepon |
| `city` | Detail kota tempat dokter berada |
| `customer_specialist` | Detail spesialis dokter (contoh: SP.MK) |
| `customer_position` | Posisi dokter dalam sistem (contoh: DOKTER PRAKTEK ( USER )) |

---

## Format Plan

AI harus mengembalikan objek JSON dengan array `plan`. Setiap langkah harus memiliki `step`, `action`, dan `parameters`.

```json
{
  "plan": [
    {
      "step": 1,
      "action": "get_doctors",
      "parameters": { "name.like": "widiarto" }
    }
  ]
}
```

---

## Contoh Plan Multi-Step

**Contoh — pengguna mencari dokter berdasarkan nama:**
```json
{
  "plan": [
    {
      "step": 1,
      "action": "get_doctors",
      "parameters": { "name.like": "budi" }
    }
  ]
}
```



<!--
  Tambahkan tool baru dengan menduplikasi blok "### function_one" di atas
  dan mendaftarkan endpoint-nya di endpoints.json.
-->