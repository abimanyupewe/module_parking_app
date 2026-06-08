2. ALUR CHECKOUT DAN PEMBAYARAN INSTAN

Halaman Kendaraan Keluar dirancang agar proses penutupan transaksi berlangsung sangat cepat dengan klik yang seminimal mungkin bagi petugas.

A. Tab Kendaraan Keluar (Check-out)
- Fitur Pencarian: Terdapat kolom Search raksasa dengan latar belakang #EEF1F7.
- Logika Filter: Mengetik minimal 3 huruf plat nomor akan otomatis memfilter data kendaraan yang berstatus 'Parkir'.
- Komponen: ListView atau GridView kendaraan yang sedang parkir untuk dipilih secara cepat.

B. Pop-up Modal Checkout (Bill Summary)
- Pemicu: Memilih salah satu kendaraan yang ingin keluar.
- UI Layout: Dialog ringkasan transparan dan modern.
- Konten Rangkuman:
  1. Plat Nomor & Jenis Kendaraan.
  2. Waktu Masuk & Waktu Keluar (DATETIME).
  3. Durasi Parkir (Dihitung dalam jam).
  4. Total Biaya (Berdasarkan tarif per jam dari tb_jenis_kendaraan).
- Aksi Utama: Tombol "Selesai & Buka Palang" menggunakan primary_button.dart (#343858).

C. Finalisasi Transaksi
- Update Transaksi: Status pada tb_transaksi diubah menjadi 'Selesai' dan mengisi kolom waktu_keluar serta total_biaya.
- Update Area: Mengurangi (-1) jumlah kolom 'terisi' pada tabel tb_area_parkir secara otomatis.
- Audit Log: Aksi ini terekam otomatis ke dalam tb_log_aktivitas sebagai kategori 'Transaksi'.
