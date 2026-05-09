// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DebugActionSection extends StatelessWidget {
  const DebugActionSection({
    super.key,
    required this.title,
    required this.titleColor,
    required this.children,
  });

  final String title;
  final Color titleColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
