
## Tools yang Tersedia

### get_doctors

Mencari data dokter (customer) dari sistem API.

Gunakan tool ini **setiap kali** ada pertanyaan terkait pencarian data dokter, customer, dengan bisa memfilter berdasarkan nama, kota, spesialis, dan posisi. Spesialis ini tulisannya tidak harus sama persis, misal Internis sama dg penyakit dalam.

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
  "success": true,
  "message": "Record found",
  "total_data": 29034,
  "data": [
    {
      "id": "23060024",
      "name": "VIDYAPATI WIDIARTO MANGUNKUSUMO",
      "address": "-",
      "latitude": -6,
      "longitude": 108,
      "phone": "+628111111111",
      "place_of_birth": "-",
      "date_of_birth": "1999-01-01T00:00:00Z",
      "gender": "Laki-laki",
      "religion": "Islam",
      "email": "vidya@gmail.com",
      "ktp": "3203012502306009",
      "npwp": "00.000.000.0-000.000",
      "customer_specialist_id": 27,
      "customer_position_id": 7,
      "city": {
        "id": "DKI",
        "name": "DKI JAKARTA"
      },
      "customer_specialist": {
        "id": 27,
        "title": "SP.MK",
        "description": "SP.MK - SPESIALIS MIKROBIOLOGI KLINIK",
        "customer_group_specialist_id": 6
      },
      "customer_position": {
        "id": 7,
        "name": "DOKTER PRAKTEK ( USER )"
      },
      "customer_inactive_status": {
        "id": 0,
        "name": "-"
      }
    }
  ]
}
```

**Keterangan field penting:**

| Field | Keterangan |
|---|---|
| `success` | Status keberhasilan request (`true` / `false`) |
| `total_data` | Total seluruh data dokter yang tersedia di sistem |
| `id` | ID unik dokter / customer |
| `name` | Nama lengkap dokter |
| `address` | Alamat dokter |
| `latitude` / `longitude` | Koordinat lokasi dokter |
| `phone` | Nomor telepon dokter |
| `place_of_birth` | Tempat lahir dokter |
| `date_of_birth` | Tanggal lahir dokter (format ISO 8601) |
| `gender` | Jenis kelamin (`Laki-laki` / `Perempuan`) |
| `religion` | Agama dokter |
| `email` | Alamat email dokter |
| `ktp` | Nomor KTP dokter |
| `npwp` | Nomor NPWP dokter |
| `city` | Detail kota tempat dokter berada (`id` dan `name`) |
| `customer_specialist` | Detail spesialis dokter (contoh: `SP.MK`, `SP.PD`, `G.P`, `APT`) |
| `customer_position` | Posisi dokter dalam sistem (contoh: `DOKTER PRAKTEK ( USER )`, `KEPALA FARMASI / LOGISTIK`) |
| `customer_inactive_status` | Status aktif/nonaktif dokter; `name: "-"` berarti dokter masih aktif |

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