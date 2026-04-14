import 'package:flutter/material.dart';
import '../../../config/colors.dart';

/// Widget untuk memilih role (Owner, Admin, Staff) di pojok kanan atas
class AuthRoleSelector extends StatefulWidget {
  final String initialRole;
  final ValueChanged<String> onRoleChanged;

  const AuthRoleSelector({
    Key? key,
    required this.initialRole,
    required this.onRoleChanged,
  }) : super(key: key);

  @override
  State<AuthRoleSelector> createState() => _AuthRoleSelectorState();
}

class _AuthRoleSelectorState extends State<AuthRoleSelector> {
  late String _selectedRole;

  final List<String> _roles = ['Owner', 'Admin', 'Staff'];

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 24, top: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButton<String>(
            value: _selectedRole,
            underline: const SizedBox(),
            isDense: true,
            onChanged: (String? newRole) {
              if (newRole != null && newRole != _selectedRole) {
                setState(() {
                  _selectedRole = newRole;
                });
                widget.onRoleChanged(newRole);
              }
            },
            items: _roles.map<DropdownMenuItem<String>>((String role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(
                  role,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              );
            }).toList(),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
