3. ALUR ROUTING DAN ONBOARDING LOGIC

Setelah Native Splash Screen selesai, aplikasi akan menjalankan logika pengecekan awal untuk menentukan halaman mana yang akan ditampilkan kepada pengguna.

A. Initial Page (Setelah Splash Selesai)
Aplikasi memanggil InitialPage atau OnboardingPage sebagai halaman Flutter pertama.

B. Logika Pengecekan (Sequential Check)
1. Pengecekan Onboarding (First-Time User):
   - Sistem mengecek flag isFirstTime (via Local Storage/SharedPreferences).
   - Jika isFirstTime == true: Tampilkan slider Onboarding (Halaman 05-onboarding).
   - Jika isFirstTime == false: Lanjutkan ke pengecekan Session Login.

2. Pengecekan Session Login:
   - Sistem mengecek status login user di SQLite.
   - Jika Belum Login: Arahkan ke login_page.dart.
   - Jika Sudah Login: Arahkan ke Dashboard sesuai role masing-masing (Owner, Admin, atau Petugas).

C. Transisi Antar Halaman
Menggunakan transisi halus (Fade Transition) agar perpindahan dari Splash Screen ke Onboarding atau Login terlihat profesional dan tidak kaku.
