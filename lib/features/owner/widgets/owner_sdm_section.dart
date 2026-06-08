import 'package:flutter/material.dart';
import '../../../config/constants.dart';
import '../../../services/database_helper.dart';
import '../../../models/user_model.dart';
import 'sdm/ownerSdmHeader.dart';
import 'sdm/ownerSdmSummary.dart';
import 'sdm/ownerSdmFilterBar.dart';
import 'sdm/ownerSdmTable.dart';
import 'sdm/ownerSdmDialogs.dart';

/// Owner SDM Section - Manajemen SDM (penambahan, monitoring, edit, hapus)
class OwnerSdmSection extends StatefulWidget {
  const OwnerSdmSection({super.key});

  @override
  State<OwnerSdmSection> createState() => _OwnerSdmSectionState();
}

class _OwnerSdmSectionState extends State<OwnerSdmSection> {
  final _databaseHelper = DatabaseHelper();
  String _searchQuery = '';
  String? _selectedRole;

  List<UserModel> _allSdm = [];
  List<UserModel> _filteredSdm = [];
  bool _isLoading = true;

  final List<String> _roles = ['Petugas', 'Admin'];

  @override
  void initState() {
    super.initState();
    _loadSDM();
  }

  Future<void> _loadSDM() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get all users and filter by Petugas and Admin roles
      final allUsers = await _databaseHelper.getAllUsers();
      final filteredUsers = allUsers
          .where(
            (user) =>
                user.role.toLowerCase() ==
                    AppConstants.rolePetugas.toLowerCase() ||
                user.role.toLowerCase() ==
                    AppConstants.roleAdmin.toLowerCase() ||
                user.role == 'Petugas' ||
                user.role == 'Admin',
          )
          .toList();

      if (mounted) {
        setState(() {
          _allSdm = filteredUsers;
          _filteredSdm = _allSdm;
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
        ).showSnackBar(SnackBar(content: Text('Error loading SDM: $e')));
      }
    }
  }

  void _applyFilters() {
    _filteredSdm = _allSdm.where((item) {
      // Filter berdasarkan search query (nama)
      if (!item.namaLengkap.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      )) {
        return false;
      }

      // Filter berdasarkan role
      if (_selectedRole != null) {
        if (item.role.toLowerCase() != _selectedRole!.toLowerCase()) {
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
          OwnerSdmHeader(
            filteredCount: _filteredSdm.length,
            totalCount: _allSdm.length,
            onAddPressed: _showAddDialog,
          ),
          const SizedBox(height: 24),

          OwnerSdmSummary(allSdm: _allSdm),
          const SizedBox(height: 24),

          OwnerSdmFilterBar(
            selectedRole: _selectedRole,
            roles: _roles,
            onSearchChanged: _onSearchChanged,
            onRoleChanged: _onRoleChanged,
            onReset: _clearFilters,
          ),
          const SizedBox(height: 16),

          OwnerSdmTable(
            data: _filteredSdm,
            isLoading: _isLoading,
            searchQuery: _searchQuery,
            selectedRole: _selectedRole,
            onEdit: _showEditDialog,
            onToggleStatus: _toggleSdmStatus,
            onDelete: _removeSDM,
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    showOwnerSdmAddDialog(
      context: context,
      databaseHelper: _databaseHelper,
      roles: _roles,
      reloadData: _loadSDM,
    );
  }

  void _showEditDialog(UserModel staff) {
    showOwnerSdmEditDialog(
      context: context,
      databaseHelper: _databaseHelper,
      staff: staff,
      roles: _roles,
      reloadData: _loadSDM,
    );
  }

  void _toggleSdmStatus(UserModel sdm) {
    showOwnerSdmToggleStatusDialog(
      context: context,
      databaseHelper: _databaseHelper,
      sdm: sdm,
      reloadData: _loadSDM,
    );
  }

  void _removeSDM(UserModel sdm) {
    showOwnerSdmDeleteDialog(
      context: context,
      databaseHelper: _databaseHelper,
      sdm: sdm,
      reloadData: _loadSDM,
    );
  }
}
