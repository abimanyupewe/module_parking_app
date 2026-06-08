4. ARSITEKTUR FOLDER MODULAR AUTH

Modul Autentikasi akan menggunakan struktur folder yang modular dan granular untuk menjaga kebersihan kode (Clean Architecture Principles).

A. Struktur Folder Utama (lib/features/auth/)
Setiap sub-folder memiliki tanggung jawab yang terpisah untuk memudahkan pengembangan dan maintenance.

1. pages/
- login_page.dart (Halaman Login Utama).
- forgot_password_page.dart (Halaman Lupa Password).
- change_password_page.dart (Halaman Ganti Password).

2. widgets/
- login_form_widget.dart (Widget pembungkus form input login).
- auth_header_widget.dart (Logo aplikasi dan teks heading login).
- auth_footer_widget.dart (Link ke Lupa Password atau bantuan).

3. controllers/
- auth_controller.dart (Mengelola state login, validasi status, dan routing dashboard).
- forgot_password_controller.dart (Mengelola logika pemulihan akses password).

B. Standar Penulisan & Reusability
- File Suffix: Setiap file harus menggunakan akhiran yang jelas (_page.dart, _widget.dart, _controller.dart).
- Komponen Global: Jika komponen digunakan secara luas di modul lain, letakkan di lib/widgets/. Jika hanya untuk Auth, letakkan di lib/features/auth/widgets/.
- Dokumentasi Kode: Berikan komentar minimal 1 baris untuk setiap widget untuk menjelaskan fungsinya.
