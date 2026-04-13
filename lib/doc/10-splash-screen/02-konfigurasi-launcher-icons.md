2. KONFIGURASI LAUNCHER ICONS

Launcher Icons pada aplikasi ini menggunakan library flutter_launcher_icons untuk mempermudah pembuatan icon aplikasi secara profesional dan otomatis.

A. Spesifikasi Icon
- Aset Utama: assets/images/logo.png.
- Background: Putih Bersih (#FFFFFF).
- Android & iOS: Konfigurasi android: true dan ios: true diaktifkan.

B. Konfigurasi pubspec.yaml (Draft)
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/logo.png"
  min_sdk_android: 21
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/images/logo.png"

C. Konsistensi Branding
Icon aplikasi harus selaras dengan logo yang ada di Splash Screen agar pengguna mendapatkan pengalaman branding yang konsisten dari saat memilih aplikasi hingga aplikasi terbuka.
