import 'package:flutter/material.dart';

/// Widget reusable untuk white card container di halaman auth
/// Digunakan untuk membungkus form login/signup dengan styling yang konsisten
class AuthCardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const AuthCardContainer({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
