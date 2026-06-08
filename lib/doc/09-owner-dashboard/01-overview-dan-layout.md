1. OVERVIEW DAN LAYOUT DASHBOARD OWNER

Halaman Beranda (Dashboard Overview) dirancang untuk pimpinan dengan tampilan yang menekankan pada analitik, laporan, dan transparansi.

A. Quick Access Section
- Lokasi: Header Dashboard (Pojok kanan atas atau di bawah App Bar).
- Komponen: Widget quick_access_section.dart.
- Fitur: Filter rentang waktu laporan (Hari Ini, Minggu Ini, Bulan Ini).
- Warna Latar: #EEF1F7 (Tertiary Color) untuk tombol filter agar kontras dan bersih.

B. Summary Grid
- Komponen: Widget revenue_summary_grid.dart (Pembungkus summary_card.dart).
- Daftar Kartu Ringkasan:
  1. Total Pendapatan: Warna #343858 (Primary), teks putih, data SUM(total_biaya).
  2. Jumlah Petugas Aktif: Berdasarkan filter status 'aktif'.
  3. Jumlah Admin: Total pengguna dengan role 'admin'.
  4. Total Kendaraan: Total record di tb_kendaraan atau transaksi aktif.

C. Real-time Monitoring
- Komponen: Widget recent_transaction_table.dart.
- Konten: Tabel mini yang menampilkan 5 transaksi terakhir secara otomatis tanpa perlu refresh manual (Reactive UI).
