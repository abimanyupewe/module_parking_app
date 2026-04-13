# Spesifikasi UI Onboarding

Dokumentasi ini menentukan komponen visual dan tata letak halaman Onboarding agar tetap konsisten dengan panduan desain aplikasi.

## Elemen Layout
Halaman Onboarding harus mengikuti struktur layout berikut untuk setiap slide:
1. Bagian Atas: Ilustrasi (gambar representasi fitur).
2. Bagian Tengah: Judul (font besar, bold, warna Primary).
3. Bagian Bawah: Deskripsi (font kecil, warna Inactive).
4. Penanda Halaman: Indikator titik (dots) di bawah deskripsi.

## Komponen Visual
- Ilustrasi: Ukuran 250px - 300px, posisi tengah.
- Judul: Typography Heading 1, Align Center.
- Deskripsi: Typography Body, Align Center, Padding horizontal 24px.
- Indikator Halaman (Dots): Warna Primary untuk halaman aktif, warna Secondary/Inactive untuk halaman lainnya.

## Tombol Navigasi
- Gunakan PrimaryButton untuk tombol "Mulai" di slide terakhir.
- Gunakan TextButton untuk tombol "Lewati" di bagian atas halaman (Floating).
- Gunakan IconButton (Arrow) untuk tombol "Lanjut" di bagian bawah.

## Checklist Implementasi
- [ ] Implementasi layout simetris (Ilustrasi, Judul, Deskripsi).
- [ ] Penggunaan warna dari AppColors.
- [ ] Animasi transisi antar slide halus.
- [ ] Indikator titik (dots) berubah saat slide digeser.