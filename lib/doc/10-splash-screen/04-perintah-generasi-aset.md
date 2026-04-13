4. PERINTAH GENERASI ASET DAN CLI COMMANDS

Dokumentasi ini mencantumkan perintah terminal (CLI) untuk men-generate Splash Screen dan Icon Aplikasi secara otomatis menggunakan library yang telah ditentukan.

A. Update Dependencies
Sebelum menjalankan perintah generasi, pastikan semua dependencies di pubspec.yaml telah diunduh:
$ flutter pub get

B. Menjalankan Generator Launcher Icons
Gunakan perintah ini untuk membuat icon aplikasi sesuai konfigurasi:
$ flutter pub run flutter_launcher_icons:main

C. Menjalankan Generator Native Splash
Gunakan perintah ini untuk membuat Splash Screen sesuai konfigurasi:
$ flutter pub run flutter_native_splash:create

D. Menghapus Native Splash (Opsi)
Jika ingin menghapus Splash Screen yang telah di-generate (untuk reset):
$ flutter pub run flutter_native_splash:remove

E. Catatan Tambahan
Perintah ini harus dijalankan setiap kali ada perubahan pada gambar logo atau warna latar belakang di konfigurasi pubspec.yaml.
