4. ARSITEKTUR FOLDER MODULAR OWNER

Modul Owner Dashboard akan menggunakan struktur folder yang modular dan granular untuk menjaga kebersihan kode (Clean Architecture Principles).

A. Struktur Folder Utama (lib/features/owner/)
Setiap sub-folder memiliki tanggung jawab yang terpisah untuk memudahkan pengembangan dan maintenance.

1. pages/
- owner_dashboard_page.dart (Halaman Beranda & Analytics).
- log_activity_page.dart (Halaman Audit Log Otomatis).
- management_sdm_page.dart (Halaman Manajemen Karyawan).
- history_global_page.dart (Halaman Riwayat Transaksi).

2. widgets/
- quick_access_section.dart (Filter waktu & tombol aksi cepat).
- revenue_summary_grid.dart (Grid untuk membungkus summary_card.dart).
- recent_transaction_table.dart (Tabel mini ringkasan transaksi).
- log_filter_tabs.dart (Custom TabBar untuk kategori log).

3. controllers/
- owner_dashboard_controller.dart (Mengelola state data agregasi SQLite).
- log_activity_controller.dart (Mengelola fetching data log otomatis).
- management_sdm_controller.dart (Mengelola perubahan status user dan penambahan user).

B. Standar Penulisan & Reusability
- File Suffix: Setiap file harus menggunakan akhiran yang jelas (_page.dart, _widget.dart, _controller.dart).
- Komponen Global: Jika komponen digunakan secara luas di modul lain, letakkan di lib/widgets/. Jika hanya untuk Owner, letakkan di lib/features/owner/widgets/.
- Dokumentasi Kode: Berikan komentar minimal 1 baris untuk setiap widget untuk menjelaskan fungsinya.
