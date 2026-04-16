// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../config/colors.dart';

class DebugLogPanel extends StatelessWidget {
  const DebugLogPanel({super.key, required this.output});

  final String output;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: Text(
        output,
        style: const TextStyle(
          fontFamily: 'Courier',
          fontSize: 11,
          color: Color(0xFF00FF00),
        ),
      ),
    );
  }
}
