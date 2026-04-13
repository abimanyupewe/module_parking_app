4. ARSITEKTUR FOLDER MODULAR ADMIN

Modul Admin Dashboard akan menggunakan struktur folder yang modular dan granular untuk menjaga kebersihan kode (Clean Architecture Principles).

A. Struktur Folder Utama (lib/features/admin/)
Setiap sub-folder memiliki tanggung jawab yang terpisah untuk memudahkan pengembangan dan maintenance.

1. pages/
- admin_dashboard_page.dart (Halaman Beranda & Monitoring).
- category_area_page.dart (Halaman Master Kategori & Area).
- petugas_management_page.dart (Halaman Manajemen Petugas).
- audit_activity_page.dart (Halaman Audit Log Terbatas).

2. widgets/
- monitoring_list_tile.dart (Widget custom untuk baris daftar parkir).
- category_tabs_widget.dart (Custom TabBar untuk kategori/area).
- admin_summary_grid.dart (Grid untuk membungkus summary_card.dart).

3. controllers/
- admin_dashboard_controller.dart (Mengelola state data parkir aktif).
- category_area_controller.dart (Mengelola state data master).
- petugas_management_controller.dart (Mengelola status user petugas).

B. Standar Penulisan & Reusability
- File Suffix: Setiap file harus menggunakan akhiran yang jelas (_page.dart, _widget.dart, _controller.dart).
- Komponen Global: Jika komponen digunakan secara luas di modul lain, letakkan di lib/widgets/. Jika hanya untuk Admin, letakkan di lib/features/admin/widgets/.
- Dokumentasi Kode: Berikan komentar minimal 1 baris untuk setiap widget untuk menjelaskan fungsinya.
