# Automatic Log Activity System

Dokumentasi ini mengatur pencatatan aktivitas sistem secara otomatis.

## Logika Operasional
Sistem akan mencatat otomatis setiap perubahan di `tb_transaksi` dan `tb_user` tanpa harus menulis input manual di setiap halaman.

## Implementasi di `lib/services/database_helper.dart`

Tulis fungsi internal `_recordActivity` yang menerima kategori dan deskripsi aktivitas. Fungsi ini harus:
1. Menambah data baru ke `tb_log_aktivitas`.
2. Mencatat ID User yang sedang aktif (diambil dari sesi login).
3. Mengatur kategori ('Transaksi' atau 'Otorisasi').
4. Mencatat detail deskripsi (Misal: 'Update Slot Area A', 'Checkout Kendaraan B').
5. Mengisi timestamp otomatis dengan `DateTime.now().toIso8601String()`.

## Aturan Mutlak
Tabel `tb_log_aktivitas` adalah **INSERT-ONLY**. Tidak boleh ada method `update` atau `delete` yang merujuk pada tabel ini di `DatabaseHelper`.

## Checklist Implementasi
- [ ] Buat fungsi `_recordActivity` di `DatabaseHelper`.
- [ ] Panggil `_recordActivity` otomatis saat transaksi berhasil (parkir masuk/keluar).
- [ ] Panggil `_recordActivity` otomatis saat data user atau master diubah.
- [ ] Pastikan tidak ada UI yang bisa mengedit atau menghapus riwayat log.
