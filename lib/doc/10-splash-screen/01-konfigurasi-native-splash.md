1. KONFIGURASI NATIVE SPLASH SCREEN

Splash Screen pada aplikasi ini menggunakan library flutter_native_splash untuk memastikan tampilan branding muncul secara instan saat aplikasi (Cold Start) dibuka.

A. Spesifikasi Tampilan
- Latar Belakang: Putih Bersih (#FFFFFF).
- Logo: Menggunakan assets/images/logo.png yang diletakkan di tengah layar (Center).
- Ketentuan: Splash Screen WAJIB muncul setiap kali aplikasi dibuka, baik user sudah login maupun belum.

B. Konfigurasi pubspec.yaml (Draft)
flutter_native_splash:
  color: "#ffffff"
  image: assets/images/logo.png
  android_12:
    color: "#ffffff"
    image: assets/images/logo.png
  fullscreen: true

C. Android 12+ Support
Konfigurasi khusus android_12 ditambahkan agar splash screen tetap konsisten pada versi Android terbaru, menghindari duplikasi logo atau tampilan yang tidak diinginkan.
