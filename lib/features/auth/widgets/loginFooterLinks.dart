// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../config/colors.dart';

class LoginFooterLinks extends StatelessWidget {
  const LoginFooterLinks({
    super.key,
    required this.showRegister,
    required this.onRegisterPressed,
    required this.onDebugPressed,
  });

  final bool showRegister;
  final VoidCallback onRegisterPressed;
  final VoidCallback onDebugPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showRegister) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Belum punya akun? ',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              TextButton(
                onPressed: onRegisterPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Daftar',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        // TextButton.icon(
        //   onPressed: onDebugPressed,
        //   icon: const Icon(Icons.bug_report, size: 16),
        //   label: const Text('Debug', style: TextStyle(fontSize: 12)),
        // ),
      ],
    );
  }
}
