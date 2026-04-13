# 01 - Format Rupiah & Tanggal (Shared Logic)

Dokumentasi ini mengatur standarisasi format data agar konsisten di seluruh bagian aplikasi (UI, Struk, Laporan).

## **1. Persiapan Dependencies**

Tambahkan paket `intl` untuk format mata uang dan tanggal:

```yaml
dependencies:
  intl: ^0.19.0
```

## **2. Format Mata Uang (Rupiah)**

Gunakan `NumberFormat` dari `intl` untuk menampilkan nominal biaya.

| Input (int) | Output (String) | Contoh |
| :--- | :--- | :--- |
| `2000` | `Rp 2.000` | `NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(2000)` |

## **3. Format Tanggal & Waktu**

| Kegunaan | Pola Format | Contoh |
| :--- | :--- | :--- |
| **Log Aktivitas** | `dd MMM yyyy, HH:mm` | `13 Apr 2026, 14:30` |
| **Karcis Masuk** | `dd/MM/yyyy HH:mm:ss` | `13/04/2026 14:30:15` |
| **Laporan Harian** | `EEEE, dd MMMM yyyy` | `Senin, 13 April 2026` |

## **4. Shared Helper Class**

Buatlah file `lib/services/format_helper.dart` yang berisi static method untuk:
1.  **Format Mata Uang:** `static String formatRupiah(int nominal)`.
2.  **Format Tanggal:** `static String formatFullDate(DateTime dt)`.
3.  **Format Jam:** `static String formatTime(DateTime dt)`.

## **5. Checklist Implementasi**

- [ ] Pastikan `intl` sudah terdaftar di `pubspec.yaml`.
- [ ] Buat class `FormatHelper` di `lib/services/`.
- [ ] Terapkan `FormatHelper.formatRupiah` pada Dashboard & Struk PDF.
