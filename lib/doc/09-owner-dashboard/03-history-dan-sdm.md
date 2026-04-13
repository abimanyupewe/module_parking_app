3. HISTORY GLOBAL DAN MANAJEMEN SDM

Halaman History Global dan Manajemen SDM memberikan kontrol lebih tinggi bagi Owner terhadap data transaksi lama dan status akun petugas.

A. Halaman History Global
- Fitur: Data Table berisi seluruh riwayat transaksi (tb_transaksi).
- Search Filter: Search bar di pojok kanan atas dengan latar belakang #EEF1F7.
- Input: Pencarian berdasarkan plat nomor kendaraan secara real-time.
- Filter Tambahan: Filter berdasarkan status parkir (Parkir atau Selesai).

B. Halaman Manajemen SDM (User Control)
- Fitur: Halaman daftar karyawan dari tb_user.
- FAB (Floating Action Button): Tombol "Tambah SDM Baru" untuk menambah Admin atau Petugas.
- Status Akun: Toggle Switch untuk mengubah status user (Aktif/Nonaktif) secara instan.
- Visual: Indikator status_badge.dart (Hijau untuk 'Aktif', Merah untuk 'Nonaktif').

C. Validasi Keamanan
- Login Check: Setiap user dengan status 'nonaktif' di tb_user secara otomatis dilarang login ke sistem.
- Filter Role: Owner dapat mengawasi seluruh role petugas dan admin dalam satu tampilan list.
