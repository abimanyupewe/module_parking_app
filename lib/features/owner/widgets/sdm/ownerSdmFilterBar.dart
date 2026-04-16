// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../widgets/widgets.dart';

class OwnerSdmFilterBar extends StatelessWidget {
  const OwnerSdmFilterBar({
    super.key,
    required this.selectedRole,
    required this.roles,
    required this.onSearchChanged,
    required this.onRoleChanged,
    required this.onReset,
  });

  final String? selectedRole;
  final List<String> roles;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CustomSearchBar(
            hintText: 'Cari nama SDM...',
            onChanged: onSearchChanged,
            prefixIcon: Icons.search,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.tertiary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String?>(
              isExpanded: true,
              underline: const SizedBox(),
              value: selectedRole,
              hint: const Text('Semua'),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Semua'),
                  ),
                ),
                ...roles.map((role) {
                  return DropdownMenuItem<String?>(
                    value: role,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(role),
                    ),
                  );
                }),
              ],
              onChanged: onRoleChanged,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Reset'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tertiary,
              foregroundColor: AppColors.black,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }
}
