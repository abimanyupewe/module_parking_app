2. MASTER DATA MANAGEMENT

Halaman Master Data memberikan kontrol penuh bagi Admin untuk mengatur konfigurasi dasar sistem parkir agar dinamis dan fleksibel.

A. Master Kategori Kendaraan (tb_jenis_kendaraan)
- Fungsi: CRUD untuk kategori kendaraan seperti 'Motor Roda 2', 'Mobil', 'Truk', dsb.
- Komponen: Tabel CRUD dengan tombol aksi 'Tambah Kategori'.
- Input: Menggunakan custom_textfield.dart pada modal popup form input.
- Metadata: Nama Jenis (UNIQUE) dan Tarif per Jam (Rp).

B. Master Area Parkir (tb_area_parkir)
- Fungsi: CRUD untuk area parkir (contoh: 'Blok A', 'Blok B').
- Relasi: Setiap area dihubungkan ke salah satu jenis kendaraan (id_jenis).
- Kapasitas: Mengatur kapasitas maksimal dan monitoring jumlah kendaraan yang sedang terisi.
- Kontrol: Admin dapat mengaktifkan atau menonaktifkan area tertentu jika sedang dalam perbaikan.

C. Layout UI
- Implementasi: Menggunakan Tab Bar untuk memisahkan 'Kategori Kendaraan' dan 'Area Parkir'.
- Visual: Latar belakang tab aktif menggunakan #EEF4FF untuk indikator highlight.
- Form Input: Latar belakang TextField menggunakan #EEF1F7 (Tertiary Color).
