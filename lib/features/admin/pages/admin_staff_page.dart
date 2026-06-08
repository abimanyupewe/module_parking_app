import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../services/database_helper.dart';
import '../../../models/user_model.dart';
import '../widgets/staff/adminStaffDataTable.dart';
import '../widgets/staff/adminStaffHeader.dart';
import '../widgets/staff/adminStaffSearchField.dart';

/// Admin Staff Page - Manage petugas dengan tabel dan deactivate functionality
class AdminStaffPage extends StatefulWidget {
  const AdminStaffPage({super.key});

  @override
  State<AdminStaffPage> createState() => _AdminStaffPageState();
}

class _AdminStaffPageState extends State<AdminStaffPage> {
  final _databaseHelper = DatabaseHelper();
  List<UserModel> _staff = [];
  List<UserModel> _filteredStaff = [];
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  /// Load staff data
  Future<void> _loadStaff() async {
    if (_isLoading) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final allUsers = await _databaseHelper.getAllUsers();
      final petugasList = allUsers
          .where(
            (u) =>
                u.role.toLowerCase() == AppConstants.rolePetugas.toLowerCase(),
          )
          .toList();

      if (mounted) {
        setState(() {
          _staff = petugasList;
          _filteredStaff = petugasList;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  /// Apply search filter
  void _applySearch() {
    final query = _searchQuery.toLowerCase();

    _filteredStaff = _staff.where((staff) {
      return staff.namaLengkap.toLowerCase().contains(query) ||
          staff.username.toLowerCase().contains(query);
    }).toList();

    setState(() {});
  }

  /// Deactivate staff
  Future<void> _activateStaff(UserModel staff) async {
    final updatedUser = UserModel(
      idUser: staff.idUser,
      username: staff.username,
      password: staff.password,
      role: staff.role,
      namaLengkap: staff.namaLengkap,
      status: AppConstants.statusAktif,
      securityQuestion: staff.securityQuestion,
      securityAnswer: staff.securityAnswer,
      isDefaultPassword: staff.isDefaultPassword,
    );

    await _databaseHelper.updateUser(updatedUser);
    await _loadStaff();
  }

  /// Deactivate staff
  void _deactivateStaff(UserModel staff) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nonaktifkan Petugas'),
        content: const Text(
          'Apakah Anda yakin ingin menonaktifkan petugas ini? Petugas tidak akan bisa login ke sistem.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final updatedUser = UserModel(
                idUser: staff.idUser,
                username: staff.username,
                password: staff.password,
                role: staff.role,
                namaLengkap: staff.namaLengkap,
                status: AppConstants.statusNonaktif,
                securityQuestion: staff.securityQuestion,
                securityAnswer: staff.securityAnswer,
                isDefaultPassword: staff.isDefaultPassword,
              );

              await _databaseHelper.updateUser(updatedUser);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Petugas berhasil dinonaktifkan'),
                  ),
                );
              }

              await _loadStaff();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Nonaktifkan'),
          ),
        ],
      ),
    );
  }

  /// Get status badge color
  Color _getStatusColor(String status) {
    if (status.toLowerCase() == AppConstants.statusNonaktif.toLowerCase()) {
      return AppColors.danger;
    } else {
      return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminStaffHeader(totalStaff: _filteredStaff.length),
                  const SizedBox(height: 12),

                  AdminStaffSearchField(
                    onChanged: (value) {
                      _searchQuery = value;
                      _applySearch();
                    },
                  ),
                  const SizedBox(height: 16),

                  AdminStaffDataTable(
                    staff: _filteredStaff,
                    statusColorBuilder: _getStatusColor,
                    onDeactivatePressed: _deactivateStaff,
                    onActivatePressed: _activateStaff,
                  ),
                ],
              ),
            ),
    );
  }
}
