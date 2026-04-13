# 03 - Logika Biaya Parkir (Rounding Up)

Dokumentasi ini mengatur sistem perhitungan tarif parkir secara adil dan akurat menggunakan logika pembulatan ke atas.

## **1. Rumus Utama Perhitungan**

| Komponen | Penjelasan |
| :--- | :--- |
| **T1 (Check-in)** | Waktu saat kendaraan masuk. |
| **T2 (Check-out)** | Waktu saat kendaraan keluar. |
| **R (Rate)** | Tarif per jam dari `tb_jenis_kendaraan`. |

### **Algoritma Durasi (Rounding Up)**
Sistem ini menggunakan pembulatan ke atas (`ceil`) untuk setiap menit yang berjalan setelah jam pertama.
1. Hitung total detik: `TotalDetik = T2 - T1`.
2. Hitung jam bayar: `int jamBayar = (TotalDetik / 3600).ceil();`.
3. Hitung total biaya: `TotalBiaya = jamBayar * R;`.

## **2. Contoh Kasus Perhitungan (Motor: Rp 2.000/jam)**

| Skenario | Durasi Real | Durasi Bayar | Total Bayar |
| :--- | :--- | :--- | :--- |
| **Singkat** | 45 Menit | 1 Jam | Rp 2.000 |
| **Lewat Sedikit** | 1 Jam 5 Menit | 2 Jam | Rp 4.000 |
| **Satu Hari** | 24 Jam | 24 Jam | Rp 48.000 |

## **3. Transisi Status di Database**

Saat proses checkout, sistem harus melakukan dua hal secara atomik:
1. **Update `tb_transaksi`**:
   - Set `status = 'Selesai'`.
   - Isi `waktu_keluar` dengan waktu saat ini.
   - Isi `total_biaya` hasil perhitungan.
2. **Update `tb_area_parkir`**:
   - Kurangi kolom `terisi` sebanyak 1 kendaraan untuk `id_area` terkait.

## **4. Checklist Implementasi**
- [ ] Implementasi fungsi `calculateDuration(DateTime in, DateTime out)` di `database_helper.dart`.
- [ ] Integrasi query `UPDATE` untuk `tb_area_parkir` saat checkout.
- [ ] Validasi data agar `total_biaya` tidak bernilai 0 atau negatif.
