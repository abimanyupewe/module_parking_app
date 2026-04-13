# Assets & Images Management

Dokumentasi ini mengatur penggunaan aset visual dalam aplikasi.

## Daftar Aset

| Aset | Kegunaan | Lokasi |
| :--- | :--- | :--- |
| `logo_app.png` | Logo utama di halaman login dan dashboard. | `assets/images/` |
| `ic_motor.png` | Icon representasi kendaraan roda 2. | `assets/images/` |
| `ic_mobil.png` | Icon representasi kendaraan roda 4. | `assets/images/` |
| `placeholder.png` | Gambar default jika data tidak ada. | `assets/images/` |

## Catatan Implementasi
Daftarkan folder aset di `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/
```

## Checklist Implementasi
- [ ] Buat folder `assets/images/` di root project.
- [ ] Masukkan file gambar yang dibutuhkan.
- [ ] Daftarkan di `pubspec.yaml`.
- [ ] Jalankan `flutter pub get`.
