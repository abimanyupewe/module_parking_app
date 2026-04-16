// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DebugActionButton extends StatelessWidget {
  const DebugActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final style = backgroundColor == null
        ? null
        : ElevatedButton.styleFrom(backgroundColor: backgroundColor);

    if (icon == null) {
      return ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: Text(label),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: style,
    );
  }
}
