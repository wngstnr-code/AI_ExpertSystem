# LAPORAN TUGAS EXPERT SYSTEM
## Sistem Rekomendasi Laptop Berdasarkan Kebutuhan Pengguna

**Mata Kuliah:** Kecerdasan Buatan  
**Bahasa Pemrograman:** CLIPS (C Language Integrated Production System)

---

## 1. Pendahuluan

### 1.1 Latar Belakang

Pemilihan laptop yang tepat merupakan tantangan bagi banyak pengguna, terutama dengan banyaknya variasi produk yang tersedia di pasaran. Setiap pengguna memiliki kebutuhan yang berbeda, mulai dari pekerjaan kantoran, desain grafis, hingga gaming. Selain itu, faktor anggaran dan preferensi bobot laptop juga memengaruhi keputusan pembelian.

Sistem pakar (Expert System) dapat membantu menyelesaikan permasalahan ini dengan meniru proses pengambilan keputusan seorang ahli. Dengan memanfaatkan basis pengetahuan (knowledge base) berupa fakta dan aturan (rules), sistem pakar mampu memberikan rekomendasi yang relevan dan spesifik berdasarkan input yang diberikan pengguna.

### 1.2 Tujuan

1. Membangun sistem pakar berbasis CLIPS yang mampu memberikan rekomendasi laptop sesuai kebutuhan pengguna.
2. Mengimplementasikan metode **Forward Chaining** sebagai mekanisme inferensi.
3. Menangani minimal 3 kasus utama dengan sub-kasus yang detail.

### 1.3 Ruang Lingkup

Sistem ini mencakup rekomendasi untuk 3 kategori kebutuhan utama:
- **Kantor / Mahasiswa** — untuk kegiatan produktivitas, office, browsing.
- **Desain Grafis / Content Creator** — untuk editing foto, video, dan desain.
- **Gaming** — untuk bermain game AAA / berat.

Setiap kasus utama dipecah lagi berdasarkan 2 faktor tambahan (anggaran dan bobot), sehingga menghasilkan **18 kombinasi rekomendasi** yang unik.

---

## 2. Landasan Teori

### 2.1 Sistem Pakar (Expert System)

Sistem pakar adalah program komputer yang meniru kemampuan pengambilan keputusan seorang ahli di bidang tertentu. Komponen utama sistem pakar meliputi:

| Komponen | Deskripsi |
|----------|-----------|
| **Knowledge Base** | Kumpulan fakta dan aturan yang merepresentasikan pengetahuan ahli |
| **Inference Engine** | Mekanisme yang memproses fakta dan aturan untuk menghasilkan kesimpulan |
| **User Interface** | Antarmuka untuk interaksi antara pengguna dan sistem |
| **Working Memory** | Memori kerja yang menyimpan fakta-fakta saat runtime |

### 2.2 Forward Chaining

Forward Chaining adalah metode inferensi yang bekerja dari **fakta menuju kesimpulan** (data-driven). Alurnya:

```
Fakta → Evaluasi Aturan → Kesimpulan Baru → Evaluasi Aturan → ... → Hasil Akhir
```

Dalam sistem ini, forward chaining diterapkan sebagai berikut:
1. Sistem mengumpulkan fakta dari input pengguna (kebutuhan, anggaran, bobot).
2. Fakta-fakta tersebut dicocokkan dengan aturan-aturan yang ada.
3. Aturan yang cocok menghasilkan kesimpulan berupa rekomendasi laptop.

### 2.3 CLIPS

CLIPS (C Language Integrated Production System) adalah tool yang dikembangkan oleh NASA untuk membangun sistem pakar. CLIPS menggunakan paradigma **rule-based programming** di mana pengetahuan direpresentasikan dalam bentuk aturan IF-THEN (production rules).

---

## 3. Deskripsi Sistem

### 3.1 Arsitektur Sistem

```
┌─────────────────────────────────────────────────────┐
│                   USER INTERFACE                    │
│          (Dialog berbasis teks di terminal)         │
├─────────────────────────────────────────────────────┤
│                 INFERENCE ENGINE                    │
│           (CLIPS Forward Chaining Engine)           │
│                                                     │
│  ┌─────────────┐     ┌────────────────────────────┐ │
│  │   Working   │     │      Knowledge Base        │ │
│  │   Memory    │◄──► │  ┌─────────┐ ┌─────────┐   │ │
│  │             │     │  │  Facts  │ │  Rules  │   │ │
│  │- profil-    │     │  │ (3 tmpl)│ │(23 rule)│   │ │
│  │  pengguna   │     │  └─────────┘ └─────────┘   │ │
│  │- fase       │     │                            │ │
│  │- rekomendasi│     │                            │ │
│  └─────────────┘     └────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

### 3.2 Alur Program (Flowchart)

```
                    ┌─────────┐
                    │  START  │
                    └────┬────┘
                         ▼
              ┌─────────────────────┐
              │  Tampilkan Header   │
              │  (Rule: tampilkan-  │
              │   header)           │
              └──────────┬──────────┘
                         ▼
              ┌─────────────────────┐
              │  Tanya Kebutuhan    │     ┌──────────┐
              │  kantor/desain/     │◄────│  Input   │
              │  gaming             │     │  tidak   │
              └──────────┬──────────┘     │  valid?  │
                         │                │  Ulangi  │
                         ▼                └──────────┘
              ┌─────────────────────┐
              │  Validasi Input     │──── Tidak valid ───┐
              └──────────┬──────────┘                    │
                   Valid │                               │
                         ▼                               │
              ┌─────────────────────┐                    │
              │  Tanya Anggaran     │◄───────────────────┘
              │  murah/menengah/    │
              │  tinggi             │
              └──────────┬──────────┘
                         ▼
              ┌─────────────────────┐
              │  Tanya Bobot        │
              │  ringan/standar     │
              └──────────┬──────────┘
                         ▼
              ┌─────────────────────┐
              │  Cocokkan Aturan    │
              │  (18 rules          │
              │   rekomendasi)      │
              └──────────┬──────────┘
                         ▼
              ┌─────────────────────┐
              │  Tampilkan Hasil    │
              │  Rekomendasi        │
              └──────────┬──────────┘
                         ▼
                    ┌─────────┐
                    │   END   │
                    └─────────┘
```

---

## 4. Deskripsi Input dan Output

### 4.1 Input

Sistem menerima 3 input secara berurutan melalui dialog interaktif di terminal:

#### Input 1: Kebutuhan Utama

| Nilai Input | Deskripsi |
|-------------|-----------|
| `kantor` | Pekerjaan kantoran, tugas kuliah, browsing, office |
| `desain` | Desain grafis, video editing, content creation |
| `gaming` | Bermain game AAA / berat, streaming |

#### Input 2: Rentang Anggaran

| Nilai Input | Rentang Harga |
|-------------|---------------|
| `murah` | < Rp 7.000.000 |
| `menengah` | Rp 7.000.000 – Rp 15.000.000 |
| `tinggi` | > Rp 15.000.000 |

#### Input 3: Prioritas Bobot

| Nilai Input | Deskripsi |
|-------------|-----------|
| `ringan` | Mengutamakan laptop tipis dan ringan untuk mobilitas |
| `standar` | Tidak mempermasalahkan bobot, mengutamakan performa |

### 4.2 Output

Sistem menghasilkan output berupa rekomendasi laptop yang terdiri dari:

| Field Output | Deskripsi | Contoh |
|--------------|-----------|--------|
| **Profil Pengguna** | Ringkasan 3 input yang dipilih | kebutuhan: gaming, anggaran: menengah, bobot: ringan |
| **Kategori** | Kategori laptop yang direkomendasikan | Laptop Gaming Thin & Light |
| **Prosesor** | Spesifikasi minimum prosesor | Intel Core i7-13620H / AMD Ryzen 7 7735HS |
| **RAM** | Kapasitas RAM yang disarankan | 16 GB |
| **GPU** | Kartu grafis yang direkomendasikan | NVIDIA GeForce RTX 4050 6GB |
| **Layar** | Spesifikasi layar | 14 - 15.6 inch, FHD/2K IPS, 144-165Hz |
| **Penyimpanan** | Kapasitas storage | SSD 512GB |
| **Contoh Laptop** | 3 contoh laptop yang sesuai | ASUS ROG Zephyrus G14, Lenovo Legion Slim 5, Acer Predator Triton 14 |
| **Estimasi Harga** | Kisaran harga di pasaran | Rp 13.000.000 - Rp 15.000.000 |

---

## 5. Komponen CLIPS yang Digunakan

### 5.1 Template (deftemplate)

Sistem menggunakan 3 template untuk merepresentasikan struktur data:

| No | Template | Slot | Fungsi |
|----|----------|------|--------|
| 1 | `profil-pengguna` | kebutuhan, anggaran, bobot | Menyimpan preferensi pengguna |
| 2 | `fase` | tahap | Mengontrol urutan tahap dialog (control fact) |
| 3 | `rekomendasi` | kategori, prosesor, ram, gpu, layar, penyimpanan, contoh-laptop, estimasi-harga | Menyimpan hasil rekomendasi |

### 5.2 Fakta Awal (deffacts)

```clips
(deffacts fakta-awal
   (fase (tahap mulai))
   (profil-pengguna (kebutuhan unknown) (anggaran unknown) (bobot unknown)))
```

Fakta awal di-load saat perintah `(reset)` dijalankan, menginisialisasi fase ke `mulai` dan profil pengguna dengan nilai `unknown`.

### 5.3 Aturan (defrule)

Sistem memiliki **23 rules** yang terbagi dalam 3 kelompok:

| Kelompok | Jumlah | Salience | Fungsi |
|----------|--------|----------|--------|
| Rules Dialog (input) | 4 rules | 100, 90, 80, 70 | Menampilkan header dan membaca input pengguna |
| Rules Inferensi (rekomendasi) | 18 rules | 50 | Mencocokkan kombinasi input dengan rekomendasi |
| Rules Output (tampilan) | 1 rule | 40 | Menampilkan hasil rekomendasi |

### 5.4 Mekanisme Kontrol

- **Salience:** Digunakan untuk mengatur prioritas eksekusi rules. Semakin tinggi salience, semakin dahulu rule dieksekusi.
- **Control Fact (fase):** Template `fase` digunakan untuk mengontrol urutan tahap dialog agar berjalan sekuensial.
- **Validasi Input:** Setiap input divalidasi menggunakan kondisi `if-then-else`. Jika input tidak valid, sistem menampilkan pesan error dan tetap di fase yang sama.

---

## 6. Daftar Lengkap Kasus dan Rekomendasi

### 6.1 Kasus 1: Kantor / Mahasiswa (6 sub-kasus)

| No | Anggaran | Bobot | Kategori Rekomendasi | Contoh Laptop |
|----|----------|-------|----------------------|---------------|
| K1 | Murah | Ringan | Laptop Entry-Level Ringan / Chromebook | Acer Chromebook 314, Lenovo IdeaPad 1 |
| K2 | Murah | Standar | Laptop Entry-Level Standar | Asus Vivobook 14, Acer Aspire 3 |
| K3 | Menengah | Ringan | Ultrabook Tipis & Ringan | Acer Swift 3, ASUS Zenbook 14 |
| K4 | Menengah | Standar | Laptop Produktivitas Mid-Range | Lenovo ThinkPad E14, HP ProBook 450 |
| K5 | Tinggi | Ringan | Business Ultrabook Premium | MacBook Air M3, Dell XPS 13 |
| K6 | Tinggi | Standar | Workstation Portable Premium | Lenovo ThinkPad T14s, HP EliteBook 860 |

### 6.2 Kasus 2: Desain / Content Creator (6 sub-kasus)

| No | Anggaran | Bobot | Kategori Rekomendasi | Contoh Laptop |
|----|----------|-------|----------------------|---------------|
| D1 | Murah | Ringan | Laptop Desain Entry-Level (Ringan) | ASUS Vivobook Pro 14, Acer Aspire 5 |
| D2 | Murah | Standar | Laptop Desain Entry-Level (Layar Besar) | ASUS Vivobook 15 OLED, Lenovo IdeaPad 5 |
| D3 | Menengah | Ringan | Laptop Creator Tipis & Ringan | MacBook Air M2, ASUS Zenbook 14 OLED |
| D4 | Menengah | Standar | Laptop Creator Mid-Range | ASUS Vivobook Pro 16 OLED, Lenovo Yoga Pro 7 |
| D5 | Tinggi | Ringan | Laptop Creator Premium (Ultra-Portable) | MacBook Pro 14 M3 Pro, Dell XPS 15 |
| D6 | Tinggi | Standar | Mobile Workstation Creator | MacBook Pro 16 M3 Max, ASUS ProArt Studiobook |

### 6.3 Kasus 3: Gaming (6 sub-kasus)

| No | Anggaran | Bobot | Kategori Rekomendasi | Contoh Laptop |
|----|----------|-------|----------------------|---------------|
| G1 | Murah | Ringan | Laptop Gaming Budget (Thin) | ASUS TUF Dash F15, Acer Nitro 5 Slim |
| G2 | Murah | Standar | Laptop Gaming Budget | Acer Nitro 5, ASUS TUF Gaming F15 |
| G3 | Menengah | Ringan | Laptop Gaming Thin & Light | ASUS ROG Zephyrus G14, Lenovo Legion Slim 5 |
| G4 | Menengah | Standar | Laptop Gaming Mid-Range | Lenovo Legion 5, ASUS TUF Gaming A16 |
| G5 | Tinggi | Ringan | Laptop Gaming High-End (Thin) | ASUS ROG Zephyrus G16, Razer Blade 14 |
| G6 | Tinggi | Standar | Laptop Gaming Flagship / Desktop Replacement | ASUS ROG Strix SCAR 18, Lenovo Legion 9i |

---

## 7. Contoh Skenario Pengujian

### Skenario 1: Mahasiswa dengan anggaran terbatas

- **Input:** kebutuhan = `kantor`, anggaran = `murah`, bobot = `standar`
- **Output:** Laptop Entry-Level Standar (Asus Vivobook 14, Acer Aspire 3, Lenovo V14 G3)
- **Estimasi Harga:** Rp 5.000.000 - Rp 7.000.000

### Skenario 2: Desainer profesional

- **Input:** kebutuhan = `desain`, anggaran = `tinggi`, bobot = `standar`
- **Output:** Mobile Workstation Creator (MacBook Pro 16 M3 Max, ASUS ProArt Studiobook, Dell Precision 5680)
- **Estimasi Harga:** Rp 35.000.000 - Rp 70.000.000

### Skenario 3: Gamer yang sering mobile

- **Input:** kebutuhan = `gaming`, anggaran = `menengah`, bobot = `ringan`
- **Output:** Laptop Gaming Thin & Light (ASUS ROG Zephyrus G14, Lenovo Legion Slim 5, Acer Predator Triton 14)
- **Estimasi Harga:** Rp 13.000.000 - Rp 15.000.000

---

## 8. Cara Menjalankan Program

### Prasyarat
- Python 3.10 atau lebih baru
- pip (Python package manager)

### Langkah-langkah

```bash
# 1. Masuk ke direktori proyek
cd AI_ExpertSystem

# 2. Buat virtual environment
python3 -m venv .venv

# 3. Aktivasi virtual environment
source .venv/bin/activate

# 4. Install dependensi
pip install clipspy

# 5. Jalankan program
python run_clips.py
```

### Contoh Output Program

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

## 9. Kesimpulan

Sistem pakar rekomendasi laptop ini berhasil diimplementasikan menggunakan CLIPS dengan metode Forward Chaining. Sistem mampu:

1. Menerima 3 input dari pengguna secara interaktif dengan validasi input.
2. Menangani **3 kasus utama** (kantor, desain, gaming) dengan **18 sub-kasus** yang spesifik.
3. Memberikan rekomendasi yang detail mencakup spesifikasi prosesor, RAM, GPU, layar, penyimpanan, contoh laptop, dan estimasi harga.
4. Menggunakan mekanisme kontrol (salience dan control fact) untuk memastikan alur program berjalan dengan benar.

### Struktur Kode

| Komponen | Jumlah |
|----------|--------|
| Template (deftemplate) | 3 |
| Fakta Awal (deffacts) | 1 |
| Aturan Dialog (defrule) | 4 |
| Aturan Inferensi (defrule) | 18 |
| Aturan Output (defrule) | 1 |
| **Total Rules** | **23** |

---

## 10. Daftar Pustaka

1. Giarratano, J. C., & Riley, G. D. (2005). *Expert Systems: Principles and Programming* (4th ed.). Thomson Course Technology.
2. CLIPS Reference Manual. (2024). https://www.clipsrules.net/documentation.html
3. clipspy Documentation. (2024). https://clipspy.readthedocs.io/
