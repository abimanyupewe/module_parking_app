import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';

/// Admin Master Data Section - CRUD Kategori & Area
class AdminMasterDataSection extends StatefulWidget {
  const AdminMasterDataSection({Key? key}) : super(key: key);

  @override
  State<AdminMasterDataSection> createState() => _AdminMasterDataSectionState();
}

class _AdminMasterDataSectionState extends State<AdminMasterDataSection> {
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _kategori = [
    {'id': 1, 'nama': 'Motor Roda 2', 'tarif': 2000},
    {'id': 2, 'nama': 'Mobil', 'tarif': 5000},
    {'id': 3, 'nama': 'Truk', 'tarif': 10000},
  ];

  final List<Map<String, dynamic>> _area = [
    {'id': 1, 'nama': 'Blok A', 'kategori': 'Motor Roda 2', 'kapasitas': 50},
    {'id': 2, 'nama': 'Blok B', 'kategori': 'Mobil', 'kapasitas': 30},
    {'id': 3, 'nama': 'Blok C', 'kategori': 'Truk', 'kapasitas': 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Tab buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedTabIndex == 0
                          ? AppColors.primary
                          : AppColors.tertiary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Kategori',
                        style: TextStyle(
                          color: _selectedTabIndex == 0
                              ? AppColors.white
                              : AppColors.inactive,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedTabIndex == 1
                          ? AppColors.primary
                          : AppColors.tertiary,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Area',
                        style: TextStyle(
                          color: _selectedTabIndex == 1
                              ? AppColors.white
                              : AppColors.inactive,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Content
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildKategoriList()
                : _buildAreaList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriList() {
    return Column(
      children: [
        // Add button
        PrimaryButton(
          label: 'Tambah Kategori',
          onPressed: () => _showKategoriDialog(null),
          width: double.infinity,
          icon: const Icon(Icons.add),
        ),
        const SizedBox(height: 16),
        // List
        Expanded(
          child: ListView.builder(
            itemCount: _kategori.length,
            itemBuilder: (context, index) {
              final kat = _kategori[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.tertiary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kat['nama'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${kat['tarif']}/jam',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.inactive,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Edit'),
                          onTap: () => _showKategoriDialog(kat),
                        ),
                        PopupMenuItem(
                          child: const Text('Hapus'),
                          onTap: () => _deleteKategori(index),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAreaList() {
    return Column(
      children: [
        // Add button
        PrimaryButton(
          label: 'Tambah Area',
          onPressed: () => _showAreaDialog(null),
          width: double.infinity,
          icon: const Icon(Icons.add),
        ),
        const SizedBox(height: 16),
        // List
        Expanded(
          child: ListView.builder(
            itemCount: _area.length,
            itemBuilder: (context, index) {
              final ar = _area[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.tertiary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ar['nama'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${ar['kategori']} • Kapasitas: ${ar['kapasitas']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.inactive,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Edit'),
                          onTap: () => _showAreaDialog(ar),
                        ),
                        PopupMenuItem(
                          child: const Text('Hapus'),
                          onTap: () => _deleteArea(index),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showKategoriDialog(Map<String, dynamic>? data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(data == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Nama Kategori',
              hint: 'Misal: Motor Roda 2',
              initialValue: data?['nama'],
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Tarif/Jam (Rp)',
              hint: '2000',
              inputType: TextInputType.number,
              initialValue: data?['tarif'].toString(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data kategori disimpan')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAreaDialog(Map<String, dynamic>? data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(data == null ? 'Tambah Area' : 'Edit Area'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Nama Area',
              hint: 'Misal: Blok A',
              initialValue: data?['nama'],
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Kategori',
              hint: 'Pilih kategori',
              initialValue: data?['kategori'],
              readOnly: true,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Kapasitas',
              hint: '50',
              inputType: TextInputType.number,
              initialValue: data?['kapasitas'].toString(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data area disimpan')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteKategori(int index) {
    setState(() {
      _kategori.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Kategori dihapus')));
  }

  void _deleteArea(int index) {
    setState(() {
      _area.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Area dihapus')));
  }
}
