1. MONITORING DAN OPERASIONAL DASHBOARD ADMIN

Halaman Beranda Admin berfokus pada monitoring operasional parkir secara real-time dan memberikan kontrol administratif terhadap kesalahan data.

A. Monitoring Parkir Aktif
- Fokus: Menampilkan daftar kendaraan yang saat ini sedang berada di area parkir (status = 'Parkir').
- Konten: ListView atau DataTable yang menyajikan plat nomor, jenis kendaraan, area, dan waktu masuk.

B. Quick Access Action
- Lokasi: Header dashboard.
- Fitur: Tombol aksi cepat untuk fungsi manajerial seperti refresh status area atau pencarian cepat kendaraan parkir.

C. Koreksi Data (Edit Feature)
- Fungsi: Jika terjadi kesalahan input oleh kasir/petugas, Admin memiliki wewenang untuk menekan tombol 'Edit' pada baris data kendaraan.
- Keamanan: Setiap perubahan data melalui fungsi Edit harus terekam secara otomatis ke dalam tb_log_aktivitas sebagai 'Otorisasi'.
- Catatan: Fungsi Delete di-hide untuk Admin guna menjaga integritas data riwayat.
