# 01 - Konfigurasi & Flow Cetak PDF (Printing Module)

Dokumentasi ini mengatur teknis pembuatan dan pencetakan struk parkir menggunakan PDF.

## **1. Persiapan Dependencies**

Tambahkan paket berikut ke dalam `pubspec.yaml`:

```yaml
dependencies:
  pdf: ^3.10.0      # Library untuk membuat dokumen PDF
  printing: ^5.11.0   # Library untuk cetak dan preview PDF
```

Jalankan perintah berikut:
`flutter pub get`

## **2. Spesifikasi Desain Struk (Roll Paper Mode)**

Aplikasi ini menggunakan standar struk kasir agar hemat kertas.

| Properti | Nilai |
| :--- | :--- |
| **Lebar Kertas** | 58 mm atau 80 mm (Dapat disesuaikan). |
| **Font** | Standard Serif atau Monospaced (Courier). |
| **QR/Barcode** | Menggunakan QR Code berisi `id_transaksi` (Optional). |

## **3. Alur Kerja (Printing Workflow)**

1.  **Trigger (User Action):**
    -   **Masuk:** Petugas tekan "Simpan & Cetak Karcis".
    -   **Keluar:** Petugas tekan "Bayar & Cetak Struk".
2.  **Data Retrieval:** Mengambil data transaksi terakhir (termasuk plat nomor, jenis, tarif, dan durasi).
3.  **Document Construction:** Membangun `pw.Document` menggunakan layout yang menyerupai struk belanja.
4.  **Preview Display:** Memanggil widget `PdfPreview` agar petugas bisa melihat tampilan struk di layar sebelum mencetak.
5.  **Output Options:**
    -   **Print:** Mengirim langsung ke printer (Bluetooth/Network).
    -   **Share:** Mengirim struk via WhatsApp atau Email.

## **4. Struktur Komponen Struk (Struktur Visual)**

| Bagian | Elemen |
| :--- | :--- |
| **Header** | Logo (Opsional), Nama Parkir, Alamat Blok/Lahan. |
| **Body** | Nomor Plat (Besar), Jam Masuk/Keluar, Durasi, Total Biaya. |
| **Footer** | Pesan Terima Kasih, ID Petugas, Teks: "Simpan karcis ini". |

## **5. Checklist Implementasi**

- [ ] Tambahkan dependencies `pdf` dan `printing`.
- [ ] Buat file `lib/services/pdf_service.dart`.
- [ ] Implementasi fungsi `generateKarcisMasuk(Transaksi model)`.
- [ ] Implementasi fungsi `generateStrukKeluar(Transaksi model)`.
