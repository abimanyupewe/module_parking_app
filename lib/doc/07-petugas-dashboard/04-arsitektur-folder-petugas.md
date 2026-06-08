4. ARSITEKTUR FOLDER MODULAR PETUGAS

Modul Petugas Dashboard akan menggunakan struktur folder yang modular dan granular untuk menjaga kebersihan kode (Clean Architecture Principles).

A. Struktur Folder Utama (lib/features/petugas/)
Setiap sub-folder memiliki tanggung jawab yang terpisah untuk memudahkan pengembangan dan maintenance yang cepat.

1. pages/
- petugas_dashboard_page.dart (Halaman Beranda & Operasional).
- vehicle_in_page.dart (Halaman Form Kendaraan Masuk).
- vehicle_out_page.dart (Halaman Form Kendaraan Keluar).
- shift_history_page.dart (Halaman Riwayat Shift Petugas).

2. widgets/
- slot_info_card.dart (Widget untuk sisa slot area).
- checkout_modal_dialog.dart (Widget dialog checkout & bill summary).
- vehicle_in_form.dart (Widget form input plat nomor & merk).
- petugas_summary_grid.dart (Grid pembungkus summary_card.dart).

3. controllers/
- petugas_dashboard_controller.dart (Mengelola state operasional masuk/keluar).
- vehicle_checkout_controller.dart (Logika kalkulasi durasi & biaya parkir).
- shift_history_controller.dart (Mengelola data transaksi harian petugas).

B. Standar Penulisan & Reusability
- File Suffix: Setiap file harus menggunakan akhiran yang jelas (_page.dart, _widget.dart, _controller.dart).
- Komponen Global: Jika komponen digunakan secara luas di modul lain, letakkan di lib/widgets/. Jika hanya untuk Petugas, letakkan di lib/features/petugas/widgets/.
- Dokumentasi Kode: Berikan komentar minimal 1 baris untuk setiap widget untuk menjelaskan fungsinya secara teknis.
