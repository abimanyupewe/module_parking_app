import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';

/// Owner SDM Section - Manajemen SDM (penambahan, monitoring, edit, hapus)
class OwnerSdmSection extends StatefulWidget {
  const OwnerSdmSection({Key? key}) : super(key: key);

  @override
  State<OwnerSdmSection> createState() => _OwnerSdmSectionState();
}

class _OwnerSdmSectionState extends State<OwnerSdmSection> {
  String _searchQuery = '';
  String? _selectedRole; // null = semua role

  final List<String> _roles = ['Petugas', 'Admin'];

  final List<Map<String, dynamic>> _allSdm = [
    {
      'id': 1,
      'nama': 'Budi Santoso',
      'role': 'Petugas',
      'status': 'aktif',
      'bergabung': '2024-01-15',
      'username': 'budi_santoso',
    },
    {
      'id': 2,
      'nama': 'Ani Wijaya',
      'role': 'Petugas',
      'status': 'aktif',
      'bergabung': '2024-02-20',
      'username': 'ani_wijaya',
    },
    {
      'id': 3,
      'nama': 'Roni Pratama',
      'role': 'Admin',
      'status': 'aktif',
      'bergabung': '2024-01-10',
      'username': 'roni_pratama',
    },
    {
      'id': 4,
      'nama': 'Siti Nurhaliza',
      'role': 'Petugas',
      'status': 'aktif',
      'bergabung': '2024-03-05',
      'username': 'siti_nurhaliza',
    },
    {
      'id': 5,
      'nama': 'Ahmad Rifki',
      'role': 'Admin',
      'status': 'aktif',
      'bergabung': '2024-01-20',
      'username': 'ahmad_rifki',
    },
  ];

  late List<Map<String, dynamic>> _filteredSdm;

  @override
  void initState() {
    super.initState();
    _filteredSdm = _allSdm;
  }

  void _applyFilters() {
    _filteredSdm = _allSdm.where((item) {
      // Filter berdasarkan search query (nama)
      if (!item['nama'].toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // Filter berdasarkan role
      if (_selectedRole != null) {
        if (item['role'] != _selectedRole) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onRoleChanged(String? value) {
    setState(() {
      _selectedRole = value;
      _applyFilters();
    });
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedRole = null;
      _filteredSdm = _allSdm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manajemen SDM',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_filteredSdm.length} dari ${_allSdm.length} anggota',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              FloatingActionButton.small(
                onPressed: () => _showAddDialog(),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.tertiary),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total SDM', '${_allSdm.length}', Icons.people),
                _buildStatCard(
                  'Aktif',
                  '${_allSdm.where((s) => s['status'] == 'aktif').length}',
                  Icons.check_circle,
                ),
                _buildStatCard(
                  'Admin',
                  '${_allSdm.where((s) => s['role'] == 'Admin').length}',
                  Icons.admin_panel_settings,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Filter Row (Search + Role Filter + Clear)
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomSearchBar(
                  hintText: 'Cari nama SDM...',
                  onChanged: _onSearchChanged,
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
                    value: _selectedRole,
                    hint: const Text('Semua Role'),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Semua Role'),
                        ),
                      ),
                      ..._roles.map((role) {
                        return DropdownMenuItem<String?>(
                          value: role,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(role),
                          ),
                        );
                      }),
                    ],
                    onChanged: _onRoleChanged,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _clearFilters,
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
          ),
          const SizedBox(height: 16),

          // Data Table
          if (_filteredSdm.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  _searchQuery.isEmpty && _selectedRole == null
                      ? 'Tidak ada SDM'
                      : 'SDM tidak ditemukan',
                  style: const TextStyle(color: AppColors.inactive),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                horizontalMargin: 0,
                headingRowColor: WidgetStateProperty.all(
                  AppColors.tertiary.withValues(alpha: 0.5),
                ),
                dataRowColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.secondary.withValues(alpha: 0.5);
                  }
                  return AppColors.white;
                }),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Nama',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Role',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Bergabung',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Aksi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
                rows: List.generate(_filteredSdm.length, (index) {
                  final sdm = _filteredSdm[index];
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          sdm['nama'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          sdm['username'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      DataCell(
                        Text(sdm['role'], style: const TextStyle(fontSize: 12)),
                      ),
                      DataCell(
                        StatusBadge(status: sdm['status'], fontSize: 11),
                      ),
                      DataCell(
                        Text(
                          sdm['bergabung'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 32,
                              child: OutlinedButton(
                                onPressed: () => _showEditDialog(sdm),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 32,
                              child: OutlinedButton(
                                onPressed: () => _removeSDM(sdm['id']),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.danger,
                                  side: const BorderSide(
                                    color: AppColors.danger,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                child: const Text(
                                  'Hapus',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.inactive),
        ),
      ],
    );
  }

  void _showAddDialog() {
    final namaController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    String? selectedRole;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Tambah SDM Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: namaController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: usernameController,
                  label: 'Username',
                  hint: 'username_unik',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  hint: 'Masukkan password',
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Role',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.tertiary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: selectedRole,
                        hint: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Pilih Role'),
                        ),
                        items: _roles.map((role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(role),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedRole = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validation
                if (namaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nama tidak boleh kosong')),
                  );
                  return;
                }
                if (usernameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Username tidak boleh kosong'),
                    ),
                  );
                  return;
                }
                if (passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password tidak boleh kosong'),
                    ),
                  );
                  return;
                }
                if (selectedRole == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilih role terlebih dahulu')),
                  );
                  return;
                }

                // Add SDM
                setState(() {
                  _allSdm.add({
                    'id':
                        (_allSdm.isNotEmpty ? _allSdm.last['id'] as int : 0) +
                        1,
                    'nama': namaController.text,
                    'username': usernameController.text,
                    'role': selectedRole,
                    'status': 'aktif',
                    'bergabung': DateTime.now().toString().split(
                      ' ',
                    )[0], // Format: YYYY-MM-DD
                  });
                  _applyFilters();
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'SDM ${namaController.text} berhasil ditambahkan',
                    ),
                  ),
                );
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> staff) {
    final namaController = TextEditingController(text: staff['nama']);
    final usernameController = TextEditingController(text: staff['username']);
    final passwordController = TextEditingController();
    String? selectedRole = staff['role'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit SDM'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: namaController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: usernameController,
                  label: 'Username',
                  hint: 'username_unik',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: passwordController,
                  label: 'Password Baru (Kosongkan jika tidak ingin diubah)',
                  hint: 'Masukkan password baru',
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Role',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.tertiary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: selectedRole,
                        items: _roles.map((role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(role),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedRole = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validation
                if (namaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nama tidak boleh kosong')),
                  );
                  return;
                }
                if (usernameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Username tidak boleh kosong'),
                    ),
                  );
                  return;
                }

                // Update SDM
                setState(() {
                  final index = _allSdm.indexWhere(
                    (s) => s['id'] == staff['id'],
                  );
                  if (index != -1) {
                    _allSdm[index]['nama'] = namaController.text;
                    _allSdm[index]['username'] = usernameController.text;
                    _allSdm[index]['role'] = selectedRole;
                    // Password tidak disimpan di sini (biasanya di backend)
                    _applyFilters();
                  }
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'SDM ${namaController.text} berhasil diperbarui',
                    ),
                  ),
                );
              },
              child: const Text('Perbarui'),
            ),
          ],
        ),
      ),
    );
  }

  void _removeSDM(int sdmId) {
    final sdm = _allSdm.firstWhere((s) => s['id'] == sdmId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus SDM'),
        content: Text('Anda yakin ingin menghapus ${sdm['nama']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allSdm.removeWhere((s) => s['id'] == sdmId);
                _applyFilters();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('SDM ${sdm['nama']} berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
