# Logika Persistensi Onboarding

Dokumentasi ini menjelaskan detail teknis penyimpanan status onboarding dan logika navigasi aplikasi.

## Penyimpanan Lokal (Shared Preferences)
Fitur Onboarding akan menyimpan flag status di penyimpanan lokal perangkat untuk menandai apakah pengguna sudah pernah melihatnya atau belum.

- Key: `is_first_run`
- Tipe Data: Boolean
- Nilai Default: `true` (Belum melihat onboarding)

## Mekanisme Pengecekan (main.dart)
Setiap aplikasi dibuka (saat Splash Screen), aplikasi akan melakukan pengecekan:
1. Baca status `is_first_run` dari SharedPreferences.
2. Jika `is_first_run` bernilai `true`:
   - Arahkan ke halaman `OnboardingPage`.
3. Jika `is_first_run` bernilai `false`:
   - Lanjutkan ke pemeriksaan status login (`is_logged_in`).
   - Jika sudah login, ke `Dashboard`.
   - Jika belum login, ke `LoginPage`.

## Update Status Persistensi
Status `is_first_run` harus diubah menjadi `false` saat:
- Pengguna menekan tombol "Mulai" di slide terakhir.
- Pengguna menekan tombol "Lewati" di slide mana pun.

## Checklist Implementasi
- [ ] Tambahkan package `shared_preferences` di pubspec.yaml.
- [ ] Implementasi fungsi `setSeenOnboarding()` untuk mengubah flag.
- [ ] Implementasi fungsi `checkFirstRun()` di Splash Screen.
- [ ] Logika pengalihan (redirection) ke Onboarding atau Login.