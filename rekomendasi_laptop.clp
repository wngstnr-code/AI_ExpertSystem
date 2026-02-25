;;; ======================================================================
;;; SISTEM REKOMENDASI LAPTOP BERDASARKAN KEBUTUHAN PENGGUNA
;;; Dibuat untuk Tugas Expert System - Mata Kuliah Kecerdasan Buatan
;;; ======================================================================
;;;
;;; Deskripsi:
;;;   Sistem ini menggunakan metode Forward Chaining untuk memberikan
;;;   rekomendasi laptop berdasarkan 3 faktor input dari pengguna:
;;;     1. Kebutuhan utama  (kantor / desain / gaming)
;;;     2. Rentang anggaran (murah / menengah / tinggi)
;;;     3. Prioritas bobot  (ringan / standar)
;;;
;;;   Kombinasi dari ketiga faktor tersebut menghasilkan rekomendasi
;;;   yang spesifik (minimal 3 kasus utama, masing-masing dengan
;;;   sub-kasus berdasarkan anggaran dan bobot).
;;;
;;; Alur Inferensi (Forward Chaining):
;;;   [START] --> tanya kebutuhan --> tanya anggaran --> tanya bobot
;;;          --> cocokkan aturan --> tampilkan rekomendasi
;;; ---------------------------------------------------------------------


;;; BAGIAN 1 : TEMPLATE (Struktur Data / Fakta)

;; Template untuk menyimpan profil lengkap pengguna
(deftemplate profil-pengguna
   "Menyimpan seluruh preferensi pengguna yang dikumpulkan via dialog"
   (slot kebutuhan   (type SYMBOL) (allowed-symbols kantor desain gaming unknown)
                     (default unknown))
   (slot anggaran    (type SYMBOL) (allowed-symbols murah menengah tinggi unknown)
                     (default unknown))
   (slot bobot       (type SYMBOL) (allowed-symbols ringan standar unknown)
                     (default unknown)))

;; Template untuk mengontrol fase/tahap pertanyaan (control fact)
(deftemplate fase
   "Mengatur urutan tahap pertanyaan agar berjalan sekuensial"
   (slot tahap (type SYMBOL)
              (allowed-symbols mulai tanya-kebutuhan tanya-anggaran tanya-bobot
                               proses selesai)))

;; Template untuk menyimpan hasil rekomendasi
(deftemplate rekomendasi
   "Menyimpan hasil akhir rekomendasi laptop untuk ditampilkan"
   (slot kategori       (type STRING))
   (slot prosesor       (type STRING))
   (slot ram            (type STRING))
   (slot gpu            (type STRING))
   (slot layar          (type STRING))
   (slot penyimpanan    (type STRING))
   (slot contoh-laptop  (type STRING))
   (slot estimasi-harga (type STRING)))



;;; BAGIAN 2 : DEFFACTS (Fakta Awal / Initial Facts)

;; Fakta awal yang di-load saat (reset) dipanggil
(deffacts fakta-awal
   "Fakta awal: fase dimulai dari 'mulai' dan profil pengguna kosong"
   (fase (tahap mulai))
   (profil-pengguna (kebutuhan unknown) (anggaran unknown) (bobot unknown)))



;;; BAGIAN 3 : RULES - Tahap Input / Dialog Pengguna

;; Rule 1: Menampilkan header program (fase: mulai)
(defrule tampilkan-header
   "Menampilkan judul program dan melanjutkan ke fase tanya-kebutuhan"
   (declare (salience 100))
   ?f <- (fase (tahap mulai))
   =>
   (printout t crlf)
   (printout t "=========================================================" crlf)
   (printout t "     SISTEM REKOMENDASI LAPTOP (CLIPS)                   " crlf)
   (printout t "     Berbasis Forward Chaining                           " crlf)
   (printout t "=========================================================" crlf)
   (printout t crlf)
   (modify ?f (tahap tanya-kebutuhan)))

;; Rule 2: Menanyakan kebutuhan utama pengguna (fase: tanya-kebutuhan)
(defrule tanya-kebutuhan
   "Membaca input kebutuhan utama pengguna dan menyimpannya ke profil"
   (declare (salience 90))
   ?f <- (fase (tahap tanya-kebutuhan))
   ?p <- (profil-pengguna (kebutuhan unknown))
   =>
   (printout t "---------------------------------------------------------" crlf)
   (printout t " LANGKAH 1/3 : Kebutuhan Utama                           " crlf)
   (printout t "---------------------------------------------------------" crlf)
   (printout t "  Apa kebutuhan utama Anda?                              " crlf)
   (printout t "    1. Pekerjaan Kantoran / Mahasiswa  (ketik: kantor)   " crlf)
   (printout t "    2. Desain Grafis / Video Editing   (ketik: desain)   " crlf)
   (printout t "    3. Bermain Game Berat              (ketik: gaming)   " crlf)
   (printout t "---------------------------------------------------------" crlf)
   (printout t "  Pilihan Anda: ")
   (bind ?input (read))
   (if (or (eq ?input kantor) (eq ?input desain) (eq ?input gaming))
      then
         (modify ?p (kebutuhan ?input))
         (modify ?f (tahap tanya-anggaran))
      else
         (printout t crlf "  [!] Input '" ?input "' tidak valid. Gunakan: kantor / desain / gaming" crlf)
         ;; Tetap di fase yang sama agar pertanyaan diulang
   ))

;; Rule 3: Menanyakan rentang anggaran (fase: tanya-anggaran)
(defrule tanya-anggaran
   "Membaca input anggaran pengguna dan menyimpannya ke profil"
   (declare (salience 80))
   ?f <- (fase (tahap tanya-anggaran))
   ?p <- (profil-pengguna (kebutuhan ?k&~unknown) (anggaran unknown))
   =>
   (printout t crlf)
   (printout t "---------------------------------------------------------" crlf)
   (printout t " LANGKAH 2/3 : Rentang Anggaran                          " crlf)
   (printout t "---------------------------------------------------------" crlf)
   (printout t "  Berapa anggaran Anda?                                  " crlf)
   (printout t "    1. < 7 juta                 (ketik: murah)           " crlf)
   (printout t "    2. 7 - 15 juta              (ketik: menengah)        " crlf)
   (printout t "    3. > 15 juta                (ketik: tinggi)          " crlf)
   (printout t "---------------------------------------------------------" crlf)
   (printout t "  Pilihan Anda: ")
   (bind ?input (read))
   (if (or (eq ?input murah) (eq ?input menengah) (eq ?input tinggi))
      then
         (modify ?p (anggaran ?input))
         (modify ?f (tahap tanya-bobot))
      else
         (printout t crlf "  [!] Input '" ?input "' tidak valid. Gunakan: murah / menengah / tinggi" crlf)
   ))

;; Rule 4: Menanyakan prioritas bobot laptop (fase: tanya-bobot)
(defrule tanya-bobot
   "Membaca input prioritas bobot laptop dan menyimpannya ke profil"
   (declare (salience 70))
   ?f <- (fase (tahap tanya-bobot))
   ?p <- (profil-pengguna (kebutuhan ?k&~unknown) (anggaran ?a&~unknown) (bobot unknown))
   =>
   (printout t crlf)
   (printout t "---------------------------------------------------------" crlf)
   (printout t " LANGKAH 3/3 : Prioritas Bobot Laptop                    " crlf)
   (printout t "---------------------------------------------------------" crlf)
   (printout t "  Apakah Anda mengutamakan laptop yang ringan?           " crlf)
   (printout t "    1. Ya, harus ringan & tipis         (ketik: ringan)  " crlf)
   (printout t "    2. Tidak masalah / standar          (ketik: standar) " crlf)
   (printout t "---------------------------------------------------------" crlf)
   (printout t "  Pilihan Anda: ")
   (bind ?input (read))
   (if (or (eq ?input ringan) (eq ?input standar))
      then
         (modify ?p (bobot ?input))
         (modify ?f (tahap proses))
      else
         (printout t crlf "  [!] Input '" ?input "' tidak valid. Gunakan: ringan / standar" crlf)
   ))



;;; BAGIAN 4 : RULES - Inferensi Rekomendasi (Aturan Produksi)

;;; --- KASUS 1: KEBUTUHAN KANTOR / MAHASISWA ---

;; Rule K1: Kantor + Murah + Ringan
(defrule rek-kantor-murah-ringan
   "Kantor, anggaran murah, preferensi ringan -> Chromebook / Laptop entry ringan"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan kantor) (anggaran murah) (bobot ringan))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Entry-Level Ringan / Chromebook")
      (prosesor       "Intel Celeron / AMD Athlon / MediaTek Kompanio")
      (ram            "4 - 8 GB")
      (gpu            "Integrated Graphics")
      (layar          "14 inch, HD/FHD, TN/IPS")
      (penyimpanan    "eMMC 64GB / SSD 128GB")
      (contoh-laptop  "Acer Chromebook 314, Lenovo IdeaPad 1, HP Chromebook 14")
      (estimasi-harga "Rp 3.000.000 - Rp 6.000.000"))))

;; Rule K2: Kantor + Murah + Standar
(defrule rek-kantor-murah-standar
   "Kantor, anggaran murah, bobot standar -> Laptop entry-level standar"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan kantor) (anggaran murah) (bobot standar))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Entry-Level Standar")
      (prosesor       "Intel Core i3 Gen 12 / AMD Ryzen 3 5000-series")
      (ram            "8 GB")
      (gpu            "Integrated Graphics (Intel UHD / AMD Radeon)")
      (layar          "14 - 15.6 inch, FHD IPS")
      (penyimpanan    "SSD 256GB")
      (contoh-laptop  "Asus Vivobook 14, Acer Aspire 3, Lenovo V14 G3")
      (estimasi-harga "Rp 5.000.000 - Rp 7.000.000"))))

;; Rule K3: Kantor + Menengah + Ringan
(defrule rek-kantor-menengah-ringan
   "Kantor, anggaran menengah, ringan -> Ultrabook tipis premium"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan kantor) (anggaran menengah) (bobot ringan))
   =>
   (assert (rekomendasi
      (kategori       "Ultrabook Tipis & Ringan")
      (prosesor       "Intel Core i5 Gen 13 / AMD Ryzen 5 7000-series")
      (ram            "8 - 16 GB")
      (gpu            "Integrated (Intel Iris Xe / AMD Radeon 680M)")
      (layar          "13 - 14 inch, FHD IPS, 100% sRGB")
      (penyimpanan    "SSD 512GB")
      (contoh-laptop  "Acer Swift 3, ASUS Zenbook 14, Lenovo Yoga Slim 7")
      (estimasi-harga "Rp 8.000.000 - Rp 13.000.000"))))

;; Rule K4: Kantor + Menengah + Standar
(defrule rek-kantor-menengah-standar
   "Kantor, anggaran menengah, bobot standar -> Laptop produktivitas mid-range"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan kantor) (anggaran menengah) (bobot standar))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Produktivitas Mid-Range")
      (prosesor       "Intel Core i5 Gen 13 / AMD Ryzen 5 7000-series")
      (ram            "16 GB")
      (gpu            "Integrated Graphics")
      (layar          "14 - 15.6 inch, FHD IPS")
      (penyimpanan    "SSD 512GB")
      (contoh-laptop  "Lenovo ThinkPad E14, HP ProBook 450, Dell Vostro 15")
      (estimasi-harga "Rp 9.000.000 - Rp 14.000.000"))))

;; Rule K5: Kantor + Tinggi + Ringan
(defrule rek-kantor-tinggi-ringan
   "Kantor, anggaran tinggi, ringan -> Business Ultrabook premium"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan kantor) (anggaran tinggi) (bobot ringan))
   =>
   (assert (rekomendasi
      (kategori       "Business Ultrabook Premium")
      (prosesor       "Intel Core Ultra 7 / Apple M3")
      (ram            "16 - 32 GB")
      (gpu            "Integrated (Intel Arc / Apple GPU 10-core)")
      (layar          "13 - 14 inch, 2K/Retina, 100% sRGB, 400+ nits")
      (penyimpanan    "SSD 512GB - 1TB")
      (contoh-laptop  "MacBook Air M3, Lenovo ThinkPad X1 Carbon, Dell XPS 13")
      (estimasi-harga "Rp 16.000.000 - Rp 28.000.000"))))

;; Rule K6: Kantor + Tinggi + Standar
(defrule rek-kantor-tinggi-standar
   "Kantor, anggaran tinggi, bobot standar -> Workstation portable premium"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan kantor) (anggaran tinggi) (bobot standar))
   =>
   (assert (rekomendasi
      (kategori       "Workstation Portable Premium")
      (prosesor       "Intel Core i7 Gen 14 / AMD Ryzen 7 PRO")
      (ram            "32 GB")
      (gpu            "Integrated / NVIDIA RTX A500 (opsional)")
      (layar          "14 - 16 inch, 2K IPS, 100% sRGB")
      (penyimpanan    "SSD 1TB")
      (contoh-laptop  "Lenovo ThinkPad T14s, HP EliteBook 860, Dell Latitude 7440")
      (estimasi-harga "Rp 18.000.000 - Rp 30.000.000"))))

;;; --- KASUS 2: KEBUTUHAN DESAIN / CONTENT CREATOR ---

;; Rule D1: Desain + Murah + Ringan
(defrule rek-desain-murah-ringan
   "Desain, anggaran murah, ringan -> Entry-level desain ringan"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan desain) (anggaran murah) (bobot ringan))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Desain Entry-Level (Ringan)")
      (prosesor       "AMD Ryzen 5 5500U / Intel Core i5 Gen 12")
      (ram            "8 GB (upgradable)")
      (gpu            "Integrated (AMD Radeon / Intel Iris Xe)")
      (layar          "14 inch, FHD IPS, 60-72% NTSC")
      (penyimpanan    "SSD 256 - 512GB")
      (contoh-laptop  "ASUS Vivobook Pro 14, Acer Aspire 5, Lenovo IdeaPad Slim 5")
      (estimasi-harga "Rp 6.000.000 - Rp 7.000.000"))))

;; Rule D2: Desain + Murah + Standar
(defrule rek-desain-murah-standar
   "Desain, anggaran murah, bobot standar -> Entry-level desain layar besar"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan desain) (anggaran murah) (bobot standar))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Desain Entry-Level (Layar Besar)")
      (prosesor       "AMD Ryzen 5 5600H / Intel Core i5 Gen 12 H-series")
      (ram            "8 - 16 GB")
      (gpu            "Integrated / NVIDIA MX550")
      (layar          "15.6 inch, FHD IPS, 60-72% NTSC")
      (penyimpanan    "SSD 512GB")
      (contoh-laptop  "ASUS Vivobook 15 OLED, Acer Aspire 5, Lenovo IdeaPad 5 15")
      (estimasi-harga "Rp 6.500.000 - Rp 7.000.000"))))

;; Rule D3: Desain + Menengah + Ringan
(defrule rek-desain-menengah-ringan
   "Desain, anggaran menengah, ringan -> Creator laptop tipis"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan desain) (anggaran menengah) (bobot ringan))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Creator Tipis & Ringan")
      (prosesor       "Intel Core i7 Gen 13 / Apple M2")
      (ram            "16 GB")
      (gpu            "Integrated (Iris Xe / Apple GPU 10-core)")
      (layar          "14 inch, 2.8K OLED / Retina, 100% DCI-P3")
      (penyimpanan    "SSD 512GB")
      (contoh-laptop  "MacBook Air M2, ASUS Zenbook 14 OLED, Dell Inspiron 14 Plus")
      (estimasi-harga "Rp 12.000.000 - Rp 15.000.000"))))

;; Rule D4: Desain + Menengah + Standar
(defrule rek-desain-menengah-standar
   "Desain, anggaran menengah, bobot standar -> Creator laptop mid-range"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan desain) (anggaran menengah) (bobot standar))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Creator Mid-Range")
      (prosesor       "Intel Core i7 Gen 13 H / AMD Ryzen 7 7735HS")
      (ram            "16 GB")
      (gpu            "NVIDIA GeForce RTX 3050 / RTX 4050 6GB")
      (layar          "15.6 - 16 inch, FHD/2K IPS, 100% sRGB")
      (penyimpanan    "SSD 512GB")
      (contoh-laptop  "ASUS Vivobook Pro 16 OLED, Lenovo Yoga Pro 7, Acer Swift X 16")
      (estimasi-harga "Rp 12.000.000 - Rp 15.000.000"))))

;; Rule D5: Desain + Tinggi + Ringan
(defrule rek-desain-tinggi-ringan
   "Desain, anggaran tinggi, ringan -> Creator premium ultrabook"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan desain) (anggaran tinggi) (bobot ringan))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Creator Premium (Ultra-Portable)")
      (prosesor       "Apple M3 Pro / Intel Core Ultra 9")
      (ram            "18 - 36 GB")
      (gpu            "Apple GPU 18-core / Intel Arc")
      (layar          "14 - 16 inch, Liquid Retina XDR / 3.2K OLED, P3 Wide Color")
      (penyimpanan    "SSD 512GB - 1TB")
      (contoh-laptop  "MacBook Pro 14 M3 Pro, ASUS Zenbook Pro 14 OLED, Dell XPS 15")
      (estimasi-harga "Rp 20.000.000 - Rp 40.000.000"))))

;; Rule D6: Desain + Tinggi + Standar
(defrule rek-desain-tinggi-standar
   "Desain, anggaran tinggi, bobot standar -> Workstation Creator kelas atas"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan desain) (anggaran tinggi) (bobot standar))
   =>
   (assert (rekomendasi
      (kategori       "Mobile Workstation Creator")
      (prosesor       "Intel Core i9 Gen 14 HX / Apple M3 Max")
      (ram            "32 - 64 GB")
      (gpu            "NVIDIA RTX 4070 8GB / Apple GPU 40-core")
      (layar          "16 - 17 inch, 4K OLED / mini-LED, 100% DCI-P3")
      (penyimpanan    "SSD 1TB - 2TB")
      (contoh-laptop  "MacBook Pro 16 M3 Max, ASUS ProArt Studiobook, Dell Precision 5680")
      (estimasi-harga "Rp 35.000.000 - Rp 70.000.000"))))

;;; --- KASUS 3: KEBUTUHAN GAMING ---

;; Rule G1: Gaming + Murah + Ringan
(defrule rek-gaming-murah-ringan
   "Gaming, anggaran murah, ringan -> Budget gaming ringan (kompromi performa)"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan gaming) (anggaran murah) (bobot ringan))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Gaming Budget (Thin)")
      (prosesor       "AMD Ryzen 5 5600H / Intel Core i5 Gen 12 H")
      (ram            "8 GB (upgradable ke 16GB)")
      (gpu            "NVIDIA GeForce RTX 2050 / GTX 1650 4GB")
      (layar          "14 - 15.6 inch, FHD IPS, 120Hz")
      (penyimpanan    "SSD 256 - 512GB")
      (contoh-laptop  "ASUS TUF Dash F15, Acer Nitro 5 Slim, Lenovo IdeaPad Gaming 3")
      (estimasi-harga "Rp 6.500.000 - Rp 7.000.000"))))

;; Rule G2: Gaming + Murah + Standar
(defrule rek-gaming-murah-standar
   "Gaming, anggaran murah, bobot standar -> Budget gaming standar"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan gaming) (anggaran murah) (bobot standar))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Gaming Budget")
      (prosesor       "AMD Ryzen 5 5600H / Intel Core i5-12450H")
      (ram            "8 - 16 GB")
      (gpu            "NVIDIA GeForce RTX 3050 4GB / GTX 1650 4GB")
      (layar          "15.6 inch, FHD IPS, 144Hz")
      (penyimpanan    "SSD 512GB")
      (contoh-laptop  "Acer Nitro 5, ASUS TUF Gaming F15, Lenovo IdeaPad Gaming 3")
      (estimasi-harga "Rp 6.500.000 - Rp 7.000.000"))))

;; Rule G3: Gaming + Menengah + Ringan
(defrule rek-gaming-menengah-ringan
   "Gaming, anggaran menengah, ringan -> Thin & Light Gaming"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan gaming) (anggaran menengah) (bobot ringan))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Gaming Thin & Light")
      (prosesor       "Intel Core i7-13620H / AMD Ryzen 7 7735HS")
      (ram            "16 GB")
      (gpu            "NVIDIA GeForce RTX 4050 6GB")
      (layar          "14 - 15.6 inch, FHD/2K IPS, 144-165Hz")
      (penyimpanan    "SSD 512GB")
      (contoh-laptop  "ASUS ROG Zephyrus G14, Lenovo Legion Slim 5, Acer Predator Triton 14")
      (estimasi-harga "Rp 13.000.000 - Rp 15.000.000"))))

;; Rule G4: Gaming + Menengah + Standar
(defrule rek-gaming-menengah-standar
   "Gaming, anggaran menengah, bobot standar -> Gaming mid-range"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan gaming) (anggaran menengah) (bobot standar))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Gaming Mid-Range")
      (prosesor       "Intel Core i7-13650HX / AMD Ryzen 7 7745HX")
      (ram            "16 GB")
      (gpu            "NVIDIA GeForce RTX 4060 8GB")
      (layar          "15.6 - 16 inch, FHD/2K IPS, 144-165Hz")
      (penyimpanan    "SSD 512GB - 1TB")
      (contoh-laptop  "Lenovo Legion 5, ASUS TUF Gaming A16, Acer Nitro 16")
      (estimasi-harga "Rp 13.000.000 - Rp 15.000.000"))))

;; Rule G5: Gaming + Tinggi + Ringan
(defrule rek-gaming-tinggi-ringan
   "Gaming, anggaran tinggi, ringan -> High-end gaming tipis"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan gaming) (anggaran tinggi) (bobot ringan))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Gaming High-End (Thin)")
      (prosesor       "Intel Core i9-14900HX / AMD Ryzen 9 7945HX")
      (ram            "16 - 32 GB")
      (gpu            "NVIDIA GeForce RTX 4070 8GB")
      (layar          "14 - 16 inch, 2K IPS/OLED, 165-240Hz, G-Sync")
      (penyimpanan    "SSD 1TB")
      (contoh-laptop  "ASUS ROG Zephyrus G16, Razer Blade 14, MSI Stealth 16")
      (estimasi-harga "Rp 22.000.000 - Rp 40.000.000"))))

;; Rule G6: Gaming + Tinggi + Standar
(defrule rek-gaming-tinggi-standar
   "Gaming, anggaran tinggi, bobot standar -> Desktop-replacement gaming"
   (declare (salience 50))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan gaming) (anggaran tinggi) (bobot standar))
   =>
   (assert (rekomendasi
      (kategori       "Laptop Gaming Flagship / Desktop Replacement")
      (prosesor       "Intel Core i9-14900HX / AMD Ryzen 9 7945HX3D")
      (ram            "32 - 64 GB DDR5")
      (gpu            "NVIDIA GeForce RTX 4080/4090 12-16GB")
      (layar          "16 - 18 inch, 2K/4K IPS, 240Hz, G-Sync, MUX Switch")
      (penyimpanan    "SSD 1TB - 2TB (dual slot)")
      (contoh-laptop  "ASUS ROG Strix SCAR 18, Lenovo Legion 9i, MSI Titan GT77 HX")
      (estimasi-harga "Rp 35.000.000 - Rp 80.000.000"))))



;;; BAGIAN 5 : RULES - Menampilkan Hasil Rekomendasi

;; Rule Output: Menampilkan rekomendasi yang telah di-assert
(defrule tampilkan-rekomendasi
   "Mengambil fakta rekomendasi dan menampilkannya dalam format rapi"
   (declare (salience 40))
   (fase (tahap proses))
   (profil-pengguna (kebutuhan ?k) (anggaran ?a) (bobot ?b))
   (rekomendasi (kategori       ?kat)
                (prosesor       ?proc)
                (ram            ?ram)
                (gpu            ?gpu)
                (layar          ?lay)
                (penyimpanan    ?sto)
                (contoh-laptop  ?con)
                (estimasi-harga ?har))
   =>
   (printout t crlf)
   (printout t "=========================================================" crlf)
   (printout t "              HASIL REKOMENDASI LAPTOP                   " crlf)
   (printout t "=========================================================" crlf)
   (printout t crlf)
   (printout t "  Profil Anda:" crlf)
   (printout t "    - Kebutuhan   : " ?k crlf)
   (printout t "    - Anggaran    : " ?a crlf)
   (printout t "    - Bobot       : " ?b crlf)
   (printout t crlf)
   (printout t "---------------------------------------------------------" crlf)
   (printout t "  Kategori        : " ?kat crlf)
   (printout t "  Prosesor        : " ?proc crlf)
   (printout t "  RAM             : " ?ram crlf)
   (printout t "  GPU             : " ?gpu crlf)
   (printout t "  Layar           : " ?lay crlf)
   (printout t "  Penyimpanan     : " ?sto crlf)
   (printout t "  Contoh Laptop   : " ?con crlf)
   (printout t "  Estimasi Harga  : " ?har crlf)
   (printout t "---------------------------------------------------------" crlf)
   (printout t crlf)
   (printout t "  Terima kasih telah menggunakan Sistem ini!             " crlf)
   (printout t crlf))

;;; AKHIR PROGRAM