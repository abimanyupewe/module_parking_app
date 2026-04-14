import 'package:flutter/material.dart';
import '../../../config/colors.dart';

/// Admin Staff Page - Manage petugas dengan tabel dan deactivate functionality
class AdminStaffPage extends StatefulWidget {
  const AdminStaffPage({Key? key}) : super(key: key);

  @override
  State<AdminStaffPage> createState() => _AdminStaffPageState();
}

class _AdminStaffPageState extends State<AdminStaffPage> {
  late List<Map<String, dynamic>> _staff = [];
  late List<Map<String, dynamic>> _filteredStaff = [];
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
      // Simulasi loading delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Generate mock data
      final staff = _generateMockStaff();

      if (mounted) {
        setState(() {
          _staff = staff;
          _filteredStaff = staff;
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

  /// Generate mock staff data
  List<Map<String, dynamic>> _generateMockStaff() {
    return [
      {
        'id': 1,
        'nama': 'Budi Santoso',
        'username': 'budi_s',
        'email': 'budi@parking.com',
        'joinDate': '2024-01-15',
        'status': 'Aktif',
      },
      {
        'id': 2,
        'nama': 'Ani Wijaya',
        'username': 'ani_w',
        'email': 'ani@parking.com',
        'joinDate': '2024-02-20',
        'status': 'Aktif',
      },
      {
        'id': 3,
        'nama': 'Roni Pratama',
        'username': 'roni_p',
        'email': 'roni@parking.com',
        'joinDate': '2024-01-10',
        'status': 'Aktif',
      },
      {
        'id': 4,
        'nama': 'Siti Nurhaliza',
        'username': 'siti_n',
        'email': 'siti@parking.com',
        'joinDate': '2024-03-05',
        'status': 'Aktif',
      },
      {
        'id': 5,
        'nama': 'Ahmad Rizki',
        'username': 'ahmad_r',
        'email': 'ahmad@parking.com',
        'joinDate': '2024-01-25',
        'status': 'Nonaktif',
      },
    ];
  }

  /// Apply search filter
  void _applySearch() {
    final query = _searchQuery.toLowerCase();

    _filteredStaff = _staff.where((staff) {
      return staff['nama'].toLowerCase().contains(query) ||
          staff['username'].toLowerCase().contains(query) ||
          staff['email'].toLowerCase().contains(query);
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
            onPressed: () {
              Navigator.pop(context);

              // Find and update staff status
              final staffIndex = _staff.indexWhere((s) => s['id'] == staffId);
              if (staffIndex != -1) {
                setState(() {
                  _staff[staffIndex]['status'] = 'Nonaktif';
                });
                _applySearch();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Petugas berhasil dinonaktifkan'),
                  ),
                );
              }
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
    if (status == 'Aktif') {
      return AppColors.success;
    } else {
      return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Petugas'), elevation: 0),
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
                      hintText: 'Cari nama, username, atau email...',
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
                                  'Email',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Join Date',
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
                                final isActive = staff['status'] == 'Aktif';

                                return DataRow(
                                  cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(
                                      Text(
                                        staff['nama'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    DataCell(Text('@${staff['username']}')),
                                    DataCell(
                                      Text(
                                        staff['email'],
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        staff['joinDate'],
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                            staff['status'],
                                          ).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          staff['status'],
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _getStatusColor(
                                              staff['status'],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      isActive
                                          ? ElevatedButton(
                                              onPressed: () {
                                                _deactivateStaff(staff['id']);
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
                                          : Tooltip(
                                              message: 'Petugas sudah nonaktif',
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.inactive
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  'Nonaktif',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors.inactive,
                                                  ),
                                                ),
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
