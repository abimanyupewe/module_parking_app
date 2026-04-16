import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../services/database_helper.dart';
import '../../../services/error_handler.dart';
import '../../../models/jenis_kendaraan_model.dart';
import '../../../models/area_parkir_model.dart';
import '../../../widgets/widgets.dart';

/// Admin Master Data Section - CRUD Kategori & Area
class AdminMasterDataSection extends StatefulWidget {
  const AdminMasterDataSection({Key? key}) : super(key: key);

  @override
  State<AdminMasterDataSection> createState() => _AdminMasterDataSectionState();
}

class _AdminMasterDataSectionState extends State<AdminMasterDataSection> {
  int _selectedTabIndex = 0;
  int? _selectedKategoriId;
  final _databaseHelper = DatabaseHelper();

  List<JenisKendaraanModel> _kategori = [];
  List<AreaParkirModel> _area = [];
  bool _isLoadingKategori = true;
  bool _isLoadingArea = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoadingKategori = true;
        _isLoadingArea = true;
        _errorMessage = null;
      });

      final kategoriList = await _databaseHelper.getAllJenisKendaraan();
      final areaList = await _databaseHelper.getAllAreaParkir();

      if (mounted) {
        setState(() {
          _kategori = kategoriList;
          _area = areaList;
          _isLoadingKategori = false;
          _isLoadingArea = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading data: $e';
          _isLoadingKategori = false;
          _isLoadingArea = false;
        });
      }
    }
  }

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
    if (_isLoadingKategori) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          'Error: $_errorMessage',
          style: const TextStyle(color: AppColors.danger),
        ),
      );
    }

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
          child: _kategori.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada kategori',
                    style: TextStyle(color: AppColors.inactive),
                  ),
                )
              : ListView.builder(
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
                                  kat.namaJenis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp ${kat.tarifPerJam}/jam',
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
                                onTap: () => _deleteKategori(kat.idJenis ?? 0),
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
    if (_isLoadingArea) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          'Error: $_errorMessage',
          style: const TextStyle(color: AppColors.danger),
        ),
      );
    }

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
          child: _area.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada area',
                    style: TextStyle(color: AppColors.inactive),
                  ),
                )
              : ListView.builder(
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
                                  ar.namaArea,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_getKategoriNama(ar.idJenis)} • Kapasitas: ${ar.kapasitas}',
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
                                onTap: () => _deleteArea(ar.idArea ?? 0),
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

  void _showKategoriDialog(JenisKendaraanModel? data) {
    final namaController = TextEditingController(text: data?.namaJenis ?? '');
    final tarifController = TextEditingController(
      text: data?.tarifPerJam.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(data == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: namaController,
              label: 'Nama Kategori',
              hint: 'Misal: Motor Roda 2',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: tarifController,
              label: 'Tarif/Jam (Rp)',
              hint: '2000',
              inputType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                if (namaController.text.isEmpty ||
                    tarifController.text.isEmpty) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Semua field harus diisi')),
                    );
                  }
                  return;
                }

                // Check apakah kategori sudah ada (hanya saat insert, bukan edit)
                if (data == null) {
                  final isDuplicate = await _databaseHelper
                      .isDuplicateJenisKendaraan(namaController.text);
                  if (isDuplicate) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Kategori \'${namaController.text}\' sudah ada dalam database. Silakan gunakan nama yang berbeda.',
                          ),
                        ),
                      );
                    }
                    return;
                  }
                }

                final tarif = int.tryParse(tarifController.text) ?? 0;
                final kategori = JenisKendaraanModel(
                  idJenis: data?.idJenis,
                  namaJenis: namaController.text,
                  tarifPerJam: tarif,
                );

                if (data == null) {
                  await _databaseHelper.insertJenisKendaraan(kategori);
                } else {
                  await _databaseHelper.updateJenisKendaraan(kategori);
                }

                if (mounted) {
                  Navigator.pop(context);
                  await _loadData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Kategori ${namaController.text} berhasil ${data == null ? 'ditambahkan' : 'diperbarui'}',
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  final errorMsg = ErrorHandler.transformError(e);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(errorMsg)));
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAreaDialog(AreaParkirModel? data) {
    _selectedKategoriId = data?.idJenis;
    final namaController = TextEditingController(text: data?.namaArea ?? '');
    final kapasitasController = TextEditingController(
      text: data?.kapasitas.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(data == null ? 'Tambah Area' : 'Edit Area'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: namaController,
                label: 'Nama Area',
                hint: 'Misal: Blok A',
              ),
              const SizedBox(height: 12),
              // Kategori Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kategori',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<int?>(
                      value: _selectedKategoriId,
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: const Text('Pilih Kategori'),
                      items: _kategori.map((kat) {
                        return DropdownMenuItem<int?>(
                          value: kat.idJenis,
                          child: Text(kat.namaJenis),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedKategoriId = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: kapasitasController,
                label: 'Kapasitas',
                hint: '50',
                inputType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (namaController.text.isEmpty) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nama area harus diisi')),
                      );
                    }
                    return;
                  }

                  if (_selectedKategoriId == null) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pilih kategori terlebih dahulu'),
                        ),
                      );
                    }
                    return;
                  }

                  // Check apakah area sudah ada (hanya saat insert, bukan edit)
                  if (data == null) {
                    final isDuplicate = await _databaseHelper
                        .isDuplicateAreaParkir(namaController.text);
                    if (isDuplicate) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Area \'${namaController.text}\' sudah ada dalam database. Silakan gunakan nama yang berbeda.',
                            ),
                          ),
                        );
                      }
                      return;
                    }
                  }

                  final kapasitas = int.tryParse(kapasitasController.text) ?? 0;
                  final area = AreaParkirModel(
                    idArea: data?.idArea,
                    namaArea: namaController.text,
                    idJenis: _selectedKategoriId ?? 0,
                    kapasitas: kapasitas,
                    terisi: data?.terisi ?? 0,
                  );

                  if (data == null) {
                    await _databaseHelper.insertAreaParkir(area);
                  } else {
                    await _databaseHelper.updateAreaParkir(area);
                  }

                  if (mounted) {
                    Navigator.pop(context);
                    await _loadData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Area ${namaController.text} berhasil ${data == null ? 'ditambahkan' : 'diperbarui'}',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    final errorMsg = ErrorHandler.transformError(e);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(errorMsg)));
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteKategori(int idKategori) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Anda yakin ingin menghapus kategori ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              try {
                Navigator.pop(context);
                await _databaseHelper.deleteJenisKendaraan(idKategori);
                await _loadData();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kategori dihapus')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  final errorMsg = ErrorHandler.transformError(e);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(errorMsg)));
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteArea(int idArea) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Anda yakin ingin menghapus area ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              try {
                Navigator.pop(context);
                await _databaseHelper.deleteAreaParkir(idArea);
                await _loadData();
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Area dihapus')));
                }
              } catch (e) {
                if (mounted) {
                  final errorMsg = ErrorHandler.transformError(e);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(errorMsg)));
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  /// Get kategori nama by kategori id
  String _getKategoriNama(int idJenis) {
    try {
      final kat = _kategori.firstWhere((k) => k.idJenis == idJenis);
      return kat.namaJenis;
    } catch (e) {
      return 'Unknown';
    }
  }
}
