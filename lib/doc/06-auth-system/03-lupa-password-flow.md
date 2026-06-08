3. LUPA PASSWORD DAN RESET AKSES

Fitur "Lupa Password" diimplementasikan sebagai solusi pemulihan akses secara mandiri maupun terpusat bagi user yang kehilangan kredensial login.

A. Fitur Lupa Password Mandiri (Forget Password)
- Lokasi: Link/Tombol "Lupa Password?" di bawah form login (Warna #737686).
- Halaman Lupa Password (forgot_password_page.dart): User memasukkan Username.
- Alur Pemulihan (Recovery): Menggunakan Security Question (Pertanyaan Keamanan) yang diset saat pembuatan akun, ATAU sistem meminta User untuk menghubungi Owner untuk reset manual.

B. Reset Password Terpusat (Owner/Admin Privilege)
- Reset oleh Owner: Owner memiliki tombol "Reset Password" pada list user di halaman Manajemen SDM.
- Fungsi Reset: Mengembalikan password user ke password default (contoh: 'password123') agar user dapat login kembali dan mengganti password-nya.
- Audit Log: Setiap aksi reset password akan terekam secara otomatis ke dalam tb_log_aktivitas sebagai kategori 'Otorisasi'.

C. Ganti Password (Change Password)
- Lokasi: Menu Profile atau Settings di setiap role dashboard.
- Fitur: Setiap user (Owner, Admin, dan Petugas) diwajibkan untuk mengganti password default mereka setelah login pertama kali untuk keamanan.
- Validasi: Memasukkan Password Lama sebelum dapat membuat Password Baru.
