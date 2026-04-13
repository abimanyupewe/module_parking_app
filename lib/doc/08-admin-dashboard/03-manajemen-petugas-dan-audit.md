3. MANAJEMEN PETUGAS DAN AUDIT TERBATAS

Halaman Manajemen Petugas dan Audit Terbatas memastikan operasional tim kasir tetap dalam kendali Admin.

A. Manajemen Petugas
- Fungsi: Halaman daftar akun petugas dari tb_user (role = 'petugas').
- Kontrol: Admin dapat melihat daftar petugas yang aktif dan nonaktif.
- Action: Fungsi Disable (Toggle Switch status aktif/nonaktif).
- Larangan: Tombol Hapus akun petugas di-hide untuk Admin. Penghapusan akun hanya diizinkan di level Owner.

B. Audit Terbatas (Log Aktivitas)
- Fokus: Menampilkan Log Aktivitas yang HANYA milik Petugas saja (Filter role = 'petugas').
- Konten: Riwayat operasional petugas dalam sistem seperti plat nomor masuk, checkout, atau perubahan transaksi sederhana.
- Visual: Menggunakan log_timeline_tile.dart untuk tampilan list bergaris yang rapi.
- Metadata: Setiap log mencatat ID User petugas, kategori, aktivitas, dan waktu kejadian (DATETIME).

C. Integrasi Status User
- Keamanan: Setiap status petugas yang di-disable secara otomatis mencegah login petugas yang bersangkutan ke sistem.
