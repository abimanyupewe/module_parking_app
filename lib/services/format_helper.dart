import 'package:intl/intl.dart';

/// Helper class untuk formatting data
class FormatHelper {
  /// Format nilai ke format Rupiah
  static String formatRupiah(int value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  /// Format tanggal ke format Indonesia
  static String formatFullDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dateTime);
  }

  /// Format tanggal saja
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(dateTime);
  }

  /// Format waktu saja
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm', 'id_ID').format(dateTime);
  }

  /// Format tanggal dan waktu singkat
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm', 'id_ID').format(dateTime);
  }

  /// Format durasi dalam jam:menit:detik
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Format durasi ke teks yang lebih readable
  static String formatDurationReadable(Duration duration) {
    if (duration.inHours > 0) {
      final minutes = duration.inMinutes.remainder(60);
      return '${duration.inHours} jam ${minutes} menit';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} menit';
    } else {
      return '${duration.inSeconds} detik';
    }
  }

  /// Format nama untuk display (capitalize)
  static String formatName(String name) {
    return name
        .toLowerCase()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Format plat nomor
  static String formatPlatNomor(String plat) {
    return plat.toUpperCase();
  }

  /// Validasi format plat nomor
  static bool isValidPlatNomor(String plat) {
    final regex = RegExp(r'^[A-Z]{1,3}\s?\d{1,4}\s?[A-Z]{1,3}$');
    return regex.hasMatch(plat.trim());
  }

  /// Get bulan dalam Bahasa Indonesia
  static String getMonthInIndonesian(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  /// Get hari dalam Bahasa Indonesia
  static String getDayInIndonesian(int day) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[day - 1];
  }

  /// Format jam parkir (untuk perhitungan biaya)
  static int calculateParkingHours(DateTime checkIn, DateTime checkOut) {
    final durationSeconds = checkOut.difference(checkIn).inSeconds;
    return (durationSeconds / 3600).ceil();
  }

  /// Format biaya parkir
  static String formatParkingCost(int hours, int ratePerHour) {
    final totalCost = hours * ratePerHour;
    return formatRupiah(totalCost);
  }
}
