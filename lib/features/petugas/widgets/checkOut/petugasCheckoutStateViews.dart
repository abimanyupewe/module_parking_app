// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';

class PetugasCheckoutLoadingView extends StatelessWidget {
  const PetugasCheckoutLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Memuat data transaksi...'),
        ],
      ),
    );
  }
}

class PetugasCheckoutErrorView extends StatelessWidget {
  const PetugasCheckoutErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 48),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.danger),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }
}
