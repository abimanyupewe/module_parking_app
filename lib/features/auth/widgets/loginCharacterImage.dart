// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LoginCharacterImage extends StatelessWidget {
  const LoginCharacterImage({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image, size: 50));
        },
      ),
    );
  }
}
