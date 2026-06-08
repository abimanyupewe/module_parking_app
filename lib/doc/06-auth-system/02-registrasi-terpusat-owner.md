2. REGISTRASI TERPUSAT OWNER

Sistem aplikasi ini tidak memiliki fitur registrasi publik (Public Registration). Hal ini bertujuan untuk menjaga keamanan data dan transparansi operasional.

A. Hak Akses Registrasi
- Pemilik Tunggal: Hanya user dengan role 'owner' yang memiliki hak akses untuk membuat akun baru.
- Lokasi Registrasi: Form registrasi hanya tersedia di halaman Manajemen SDM di dalam Owner Dashboard.
- Role yang Dibuatkan: Owner membuat akun untuk role 'admin' dan 'petugas'.

B. Parameter Akun Baru (tb_user)
1. Nama Lengkap: Digunakan untuk identitas petugas/admin.
2. Username (UNIQUE): Digunakan untuk login ke sistem.
3. Password: Password awal yang dibuatkan oleh Owner.
4. Role: Memilih antara 'admin' atau 'petugas'.
5. Status: Secara default bernilai 'aktif'.

C. Transparansi & Audit
- Setiap aksi pembuatan akun baru oleh Owner akan terekam secara otomatis ke dalam tb_log_aktivitas sebagai kategori 'Otorisasi'.
- Metadata log mencatat 'ID Owner' (siapa pembuat), 'Username Akun Baru', dan 'Waktu' pembuatan.
