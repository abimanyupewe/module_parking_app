// ignore_for_file: file_names

import 'package:flutter/material.dart';

class OwnerHistorySearchField extends StatelessWidget {
  const OwnerHistorySearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari plat nomor atau merek...',
        prefixIcon: const Icon(Icons.search),
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
