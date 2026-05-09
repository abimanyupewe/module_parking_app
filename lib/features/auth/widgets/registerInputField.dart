// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../config/colors.dart';

class RegisterInputField extends StatelessWidget {
  const RegisterInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.isLoading,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool isLoading;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          enabled: !isLoading,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            prefixIcon: Icon(prefixIcon, color: AppColors.inactive, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.secondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            hintStyle: const TextStyle(color: AppColors.inactive, fontSize: 14),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
