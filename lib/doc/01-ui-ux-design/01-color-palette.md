# Panduan UI/UX: Palet Warna & Tema

Dokumentasi ini mengatur skema warna utama untuk menjaga konsistensi visual aplikasi Manajemen Parkir.

## Konfigurasi Warna (Hex Codes)

| Elemen | Hex Code | Penggunaan |
| :--- | :--- | :--- |
| **Background** | `#FFFFFF` | Latar belakang utama aplikasi (Scaffold). |
| **Primary** | `#343858` | App Bar, heading utama, icon aktif, tombol aksi utama. |
| **Secondary** | `#EEF4FF` | Highlight, latar belakang Card/Tab aktif, indikator "Aman". |
| **Tertiary** | `#EEF1F7` | Latar belakang TextField, efek hover, latar tabel data. |
| **Inactive** | `#737686` | Teks sekunder, label form, border, icon tidak aktif. |
| **Danger** | `Material Red` | Peringatan (Slot Penuh, Hapus, Akun Nonaktif). |

## Catatan Implementasi
Definisikan warna-warna di atas di dalam file `lib/config/colors.dart`:
```dart
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF343858);
  static const secondary = Color(0xFFEEF4FF);
  // Tambahkan warna lainnya
}
```

## Checklist Implementasi
- [ ] Buat file `lib/config/colors.dart`.
- [ ] Definisikan semua warna Hex di atas.
- [ ] Gunakan `AppColors` di `ThemeData` pada `main.dart`.
