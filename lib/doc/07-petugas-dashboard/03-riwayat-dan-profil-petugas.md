3. RIWAYAT DAN PROFIL PETUGAS OPERASIONAL

Halaman Riwayat dan Profil Petugas membantu pengawasan mandiri oleh petugas terhadap hasil operasionalnya selama shift berlangsung.

A. Halaman Riwayat Shift (Shift History)
- Konten Utama: Daftar transaksi yang dilakukan oleh petugas yang sedang login pada hari tersebut (Current Date).
- Filter: Menampilkan riwayat transaksi (tb_transaksi) yang berstatus 'Selesai'.
- Visual: Menggunakan log_timeline_tile.dart untuk tampilan list bergaris yang rapi dan elegan.
- Metadata: Plat nomor, waktu keluar, dan total biaya yang diterima.

B. Halaman Profil (Personal Info)
- Informasi: Nama Lengkap petugas, Username, dan Role ('petugas').
- Keamanan: Fitur "Ganti Password" untuk mengganti password default yang telah dibuatkan oleh Owner.
- Audit Profil: Setiap aksi ganti password akan terekam secara otomatis ke dalam tb_log_aktivitas sebagai kategori 'Otorisasi'.

C. Sinkronisasi Data
- Keamanan Akun: Saat status petugas di-disable oleh Admin/Owner di tengah shift, sistem akan secara otomatis memaksa logout (force logout) agar petugas tidak dapat melakukan transaksi masuk atau keluar lagi.
