import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../services/database_helper.dart';
import '../../../models/user_model.dart';

/// Admin Staff Page - Manage petugas dengan tabel dan deactivate functionality
class AdminStaffPage extends StatefulWidget {
  const AdminStaffPage({Key? key}) : super(key: key);

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
  void _deactivateStaff(int staffId) {
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

              // Find and update staff status
              final staff = _staff.firstWhere((s) => s.idUser == staffId);

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
                  // Title
                  Text(
                    'Data Petugas Parkir',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total: ${_filteredStaff.length} petugas',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),

                  // Search Field
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari nama, username...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (value) {
                      _searchQuery = value;
                      _applySearch();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Data Table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _filteredStaff.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                'Tidak ada data petugas',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                        : DataTable(
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'No',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Nama',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Username',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Status',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Aksi',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              _filteredStaff.length,
                              (index) {
                                final staff = _filteredStaff[index];
                                final isActive =
                                    staff.status == AppConstants.statusAktif;

                                return DataRow(
                                  cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(
                                      Text(
                                        staff.namaLengkap,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    DataCell(Text('@${staff.username}')),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                            staff.status,
                                          ).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          staff.status,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _getStatusColor(
                                              staff.status,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      isActive
                                          ? ElevatedButton(
                                              onPressed: () {
                                                _deactivateStaff(staff.idUser!);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.danger,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                              ),
                                              child: const Text(
                                                'Nonaktifkan',
                                                style: TextStyle(fontSize: 11),
                                              ),
                                            )
                                          : ElevatedButton(
                                              onPressed: () async {
                                                final updatedUser = UserModel(
                                                  idUser: staff.idUser,
                                                  username: staff.username,
                                                  password: staff.password,
                                                  role: staff.role,
                                                  namaLengkap:
                                                      staff.namaLengkap,
                                                  status:
                                                      AppConstants.statusAktif,
                                                  securityQuestion:
                                                      staff.securityQuestion,
                                                  securityAnswer:
                                                      staff.securityAnswer,
                                                  isDefaultPassword:
                                                      staff.isDefaultPassword,
                                                );
                                                await _databaseHelper
                                                    .updateUser(updatedUser);
                                                await _loadStaff();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.success,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                              ),
                                              child: const Text(
                                                'Aktifkan',
                                                style: TextStyle(fontSize: 11),
                                              ),
                                            ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
