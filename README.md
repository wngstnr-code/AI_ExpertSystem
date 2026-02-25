# 💻 Sistem Rekomendasi Laptop Berdasarkan Kebutuhan Pengguna

Sistem pakar berbasis **CLIPS** (C Language Integrated Production System) yang memberikan rekomendasi laptop sesuai kebutuhan, anggaran, dan preferensi pengguna menggunakan metode **Forward Chaining**.

> Dibuat untuk Tugas Expert System — Mata Kuliah Kecerdasan Buatan

---

## 📋 Deskripsi

Sistem ini menerima 3 input dari pengguna dan menghasilkan rekomendasi laptop yang spesifik:

| No | Input | Pilihan |
|----|-------|---------|
| 1 | Kebutuhan Utama | `kantor` / `desain` / `gaming` |
| 2 | Rentang Anggaran | `murah` (< 7 jt) / `menengah` (7-15 jt) / `tinggi` (> 15 jt) |
| 3 | Prioritas Bobot | `ringan` / `standar` |

Kombinasi dari 3 faktor tersebut menghasilkan **18 aturan rekomendasi** yang mencakup **3 kasus utama** (Kantor, Desain, Gaming), masing-masing dengan 6 sub-kasus.

---

## 🔄 Alur Inferensi (Forward Chaining)

```
[START] → Tanya Kebutuhan → Tanya Anggaran → Tanya Bobot
       → Cocokkan Aturan → Tampilkan Rekomendasi
```

---

## 🏗️ Struktur Program

```
AI_ExpertSystem/
├── rekomendasi_laptop.clp   # Kode utama sistem pakar (CLIPS)
├── run_clips.py             # Script Python untuk menjalankan CLIPS
├── README.md                # Dokumentasi
└── .venv/                   # Virtual environment Python
```

### Struktur Kode CLIPS (`rekomendasi_laptop.clp`)

| Bagian | Isi |
|--------|-----|
| **Bagian 1** — Template | 3 template: `profil-pengguna`, `fase`, `rekomendasi` |
| **Bagian 2** — Deffacts | Fakta awal (initial facts) saat `(reset)` |
| **Bagian 3** — Rules Dialog | 4 rules untuk menampilkan header & membaca input pengguna |
| **Bagian 4** — Rules Inferensi | 18 rules rekomendasi (6 per kasus utama) |
| **Bagian 5** — Rules Output | 1 rule untuk menampilkan hasil rekomendasi |

**Total: 3 template, 1 deffacts, 23 rules**

---

## ⚙️ Cara Menjalankan

### Prasyarat

- Python 3.10+
- pip

### Instalasi

```bash
# Clone repository
git clone https://github.com/USERNAME/AI_ExpertSystem.git
cd AI_ExpertSystem

# Buat virtual environment & install dependensi
python3 -m venv .venv
source .venv/bin/activate
pip install clipspy
```

### Menjalankan Program

```bash
source .venv/bin/activate
python run_clips.py
```

Ikuti 3 pertanyaan yang muncul di terminal, lalu sistem akan menampilkan rekomendasi.

---

## 📸 Contoh Output

```
=========================================================
     SISTEM REKOMENDASI LAPTOP (CLIPS)
     Berbasis Forward Chaining
=========================================================

---------------------------------------------------------
 LANGKAH 1/3 : Kebutuhan Utama
---------------------------------------------------------
  Apa kebutuhan utama Anda?
    1. Pekerjaan Kantoran / Mahasiswa  (ketik: kantor)
    2. Desain Grafis / Video Editing   (ketik: desain)
    3. Bermain Game Berat              (ketik: gaming)
---------------------------------------------------------
  Pilihan Anda: gaming

---------------------------------------------------------
 LANGKAH 2/3 : Rentang Anggaran
---------------------------------------------------------
  Berapa anggaran Anda?
    1. < 7 juta                 (ketik: murah)
    2. 7 - 15 juta              (ketik: menengah)
    3. > 15 juta                (ketik: tinggi)
---------------------------------------------------------
  Pilihan Anda: menengah

---------------------------------------------------------
 LANGKAH 3/3 : Prioritas Bobot Laptop
---------------------------------------------------------
  Apakah Anda mengutamakan laptop yang ringan?
    1. Ya, harus ringan & tipis         (ketik: ringan)
    2. Tidak masalah / standar          (ketik: standar)
---------------------------------------------------------
  Pilihan Anda: ringan

=========================================================
              HASIL REKOMENDASI LAPTOP
=========================================================

  Profil Anda:
    - Kebutuhan   : gaming
    - Anggaran    : menengah
    - Bobot       : ringan

---------------------------------------------------------
  Kategori        : Laptop Gaming Thin & Light
  Prosesor        : Intel Core i7-13620H / AMD Ryzen 7 7735HS
  RAM             : 16 GB
  GPU             : NVIDIA GeForce RTX 4050 6GB
  Layar           : 14 - 15.6 inch, FHD/2K IPS, 144-165Hz
  Penyimpanan     : SSD 512GB
  Contoh Laptop   : ASUS ROG Zephyrus G14, Lenovo Legion Slim 5, Acer Predator Triton 14
  Estimasi Harga  : Rp 13.000.000 - Rp 15.000.000
---------------------------------------------------------

  Terima kasih telah menggunakan Sistem ini!
```

---

## 📊 Daftar Kasus & Rekomendasi

### Kasus 1: Kantor / Mahasiswa

| Anggaran | Bobot | Rekomendasi |
|----------|-------|-------------|
| Murah | Ringan | Acer Chromebook 314, Lenovo IdeaPad 1 |
| Murah | Standar | Asus Vivobook 14, Acer Aspire 3 |
| Menengah | Ringan | Acer Swift 3, ASUS Zenbook 14 |
| Menengah | Standar | Lenovo ThinkPad E14, HP ProBook 450 |
| Tinggi | Ringan | MacBook Air M3, Dell XPS 13 |
| Tinggi | Standar | Lenovo ThinkPad T14s, HP EliteBook 860 |

### Kasus 2: Desain / Content Creator

| Anggaran | Bobot | Rekomendasi |
|----------|-------|-------------|
| Murah | Ringan | ASUS Vivobook Pro 14, Lenovo IdeaPad Slim 5 |
| Murah | Standar | ASUS Vivobook 15 OLED, Acer Aspire 5 |
| Menengah | Ringan | MacBook Air M2, ASUS Zenbook 14 OLED |
| Menengah | Standar | ASUS Vivobook Pro 16 OLED, Lenovo Yoga Pro 7 |
| Tinggi | Ringan | MacBook Pro 14 M3 Pro, Dell XPS 15 |
| Tinggi | Standar | MacBook Pro 16 M3 Max, ASUS ProArt Studiobook |

### Kasus 3: Gaming

| Anggaran | Bobot | Rekomendasi |
|----------|-------|-------------|
| Murah | Ringan | ASUS TUF Dash F15, Acer Nitro 5 Slim |
| Murah | Standar | Acer Nitro 5, ASUS TUF Gaming F15 |
| Menengah | Ringan | ASUS ROG Zephyrus G14, Lenovo Legion Slim 5 |
| Menengah | Standar | Lenovo Legion 5, ASUS TUF Gaming A16 |
| Tinggi | Ringan | ASUS ROG Zephyrus G16, Razer Blade 14 |
| Tinggi | Standar | ASUS ROG Strix SCAR 18, Lenovo Legion 9i |

---

## 🛠️ Teknologi

- **CLIPS** — Rule-based expert system tool
- **clipspy** — Python wrapper untuk CLIPS engine
- **Python 3** — Untuk menjalankan CLIPS via script