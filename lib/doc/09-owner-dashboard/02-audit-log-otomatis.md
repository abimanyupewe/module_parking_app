2. AUDIT LOG OTOMATIS DAN TRANSPARANSI SISTEM

Halaman Audit Transparansi (Log Aktivitas) dirancang untuk audit riwayat sistem dengan fitur pencatatan otomatis yang aman dan rapi.

A. Prinsip Log Aktivitas
- Otomatis: Aplikasi TIDAK BOLEH memiliki form input manual untuk log.
- Triggers: Aktivitas tercatat saat ada aksi Transaksi (Update/Insert) atau Otorisasi (Edit User).
- Read-Only: Aplikasi tidak boleh memiliki fungsi UPDATE atau DELETE untuk data di tb_log_aktivitas.

B. Layout Log Aktivitas (LogActivityPage)
- Header: Tab Bar dengan 2 kategori (Log Transaksi dan Log Otorisasi).
- Latar Belakang Tab Aktif: #EEF4FF (Secondary Color) sebagai indikator highlight.
- Visual List: Menggunakan log_timeline_tile.dart untuk tampilan list bergaris (timeline style) agar riwayat log terlihat rapi dan elegan.

C. Pembagian Kategori Log
1. Tab 1 (Log Transaksi): Riwayat operasional petugas/kasir (contoh: plat nomor masuk, checkout).
2. Tab 2 (Log Otorisasi): Riwayat administratif oleh admin (contoh: penambahan area, perubahan status user).
- Metadata: Setiap log mencatat ID User yang bertugas, kategori, aktivitas, dan waktu kejadian (DATETIME).
