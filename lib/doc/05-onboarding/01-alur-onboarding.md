# Alur Onboarding Screen

Dokumentasi ini menjelaskan perjalanan pengguna (user journey) saat pertama kali membuka aplikasi Manajemen Parkir.

## Tujuan Fitur
Memberikan pengenalan singkat mengenai fitur utama aplikasi kepada pengguna baru sebelum diarahkan ke halaman login.

## Logika Kemunculan
Onboarding hanya akan muncul satu kali setelah aplikasi diinstal. Sistem akan memeriksa status di penyimpanan lokal (Shared Preferences) untuk menentukan apakah pengguna harus melihat halaman ini atau langsung ke halaman login.

## Urutan Slide (Carousel)
1. Slide 1: Selamat Datang - Pengenalan singkat aplikasi.
2. Slide 2: Kemudahan Parkir - Penjelasan mengenai manajemen slot real-time.
3. Slide 3: Laporan Terpadu - Penjelasan mengenai fitur analitik bagi owner.

## Alur Navigasi
- Tombol Lanjut: Berpindah ke slide berikutnya.
- Tombol Lewati: Langsung diarahkan ke halaman login dari slide mana pun.
- Tombol Mulai: Muncul hanya di slide terakhir untuk masuk ke halaman login.

## Checklist Implementasi
- [ ] Implementasi PageView untuk slider.
- [ ] Logika tombol Lewati di setiap slide.
- [ ] Logika tombol Mulai di slide terakhir.