// ignore_for_file: file_names

import 'package:flutter/material.dart';

class OwnerHistorySearchBar extends StatelessWidget {
  const OwnerHistorySearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.prefixIcon = Icons.search,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
