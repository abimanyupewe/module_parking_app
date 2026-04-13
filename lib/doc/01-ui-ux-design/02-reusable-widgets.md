# Reusable Widgets Specification

Dokumentasi ini mengatur pembuatan komponen UI yang bisa digunakan di banyak halaman.

## Widget 1: `CustomTextField`
- **File**: `lib/widgets/custom_textfield.dart`
- **Tampilan**: Latar belakang `#EEF1F7`, border radius halus (8-10px), teks label di atas atau dalam.
- **Parameter**: `controller`, `hintText`, `label`, `obscureText`, `keyboardType`.

## Widget 2: `PrimaryButton`
- **File**: `lib/widgets/primary_button.dart`
- **Tampilan**: Latar belakang `#343858`, teks putih, lebar penuh (full width).
- **Parameter**: `text`, `onPressed`, `isLoading`.

## Widget 3: `SummaryCard`
- **File**: `lib/widgets/summary_card.dart`
- **Tampilan**: Card bayangan halus, ikon di kiri, teks label & nilai di kanan.
- **Parameter**: `title`, `value`, `icon`, `color`.

## Widget 4: `StatusBadge`
- **File**: `lib/widgets/status_badge.dart`
- **Tampilan**: Label kecil (chip) dengan warna dinamis (Hijau = Aktif, Merah = Nonaktif).
- **Parameter**: `text`, `isSuccess`.

## Widget 5: `LogTimelineTile`
- **File**: `lib/widgets/log_timeline_tile.dart`
- **Tampilan**: Garis vertikal di samping (timeline style), teks aktivitas & waktu.
- **Parameter**: `activity`, `time`, `category`.

## Checklist Implementasi
- [ ] Buat `lib/widgets/custom_textfield.dart`.
- [ ] Buat `lib/widgets/primary_button.dart`.
- [ ] Buat `lib/widgets/summary_card.dart`.
- [ ] Buat `lib/widgets/status_badge.dart`.
- [ ] Buat `lib/widgets/log_timeline_tile.dart`.
- [ ] Pastikan widget menerima parameter dinamis (Constructor).
