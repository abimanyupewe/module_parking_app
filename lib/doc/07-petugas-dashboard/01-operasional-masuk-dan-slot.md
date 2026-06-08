1. OPERASIONAL MASUK DAN MONITORING SLOT

Halaman Beranda Petugas dirancang dengan UI yang sangat bersih dan elemen input yang besar untuk memastikan proses operasional yang cepat dan akurat.

A. Monitoring Sisa Slot (Header)
- Komponen: summary_card.dart.
- Warna Latar: #EEF4FF (Secondary Color).
- Fungsi: Menampilkan sisa slot parkir secara real-time yang dihitung dari total kapasitas dikurangi jumlah kendaraan yang terisi di area tersebut.

B. Tab Kendaraan Masuk (Check-in)
- Form Input: Plat Nomor, Merk, dan Warna Kendaraan.
- Komponen Input: custom_textfield.dart dengan latar belakang #EEF1F7.
- Aksi Utama: Tombol "Simpan & Cetak Karcis" menggunakan primary_button.dart (#343858).
- Validasi Sistem: Sistem secara otomatis mengecek status plat nomor di tb_transaksi. Jika plat tersebut masih berstatus 'Parkir' (belum checkout), sistem akan menolak input ganda.

C. Logika Update Area
- Otomatisasi: Saat data kendaraan masuk berhasil disimpan, sistem secara otomatis menambahkan (+1) jumlah kolom 'terisi' pada tabel tb_area_parkir yang dipilih.
- Riwayat: Aksi ini terekam otomatis ke dalam tb_log_aktivitas sebagai kategori 'Transaksi'.
