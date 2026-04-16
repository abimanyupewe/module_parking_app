// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../config/image_assets.dart';

class RegisterCharacterImage extends StatelessWidget {
  const RegisterCharacterImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Image.asset(
        ImageAssets.characterPortrait,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image, size: 50));
        },
      ),
    );
  }
}
