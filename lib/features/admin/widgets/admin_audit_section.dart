import 'package:flutter/material.dart';
import '../../../config/constants.dart';
import '../../../services/database_helper.dart';
import 'audit/adminAuditDetailDialog.dart';
import 'audit/adminAuditFilterBar.dart';
import 'audit/adminAuditHeader.dart';
import 'audit/adminAuditLogList.dart';

/// Admin Audit Section - Log aktivitas (Read-Only)
class AdminAuditSection extends StatefulWidget {
  const AdminAuditSection({super.key});

  @override
  State<AdminAuditSection> createState() => _AdminAuditSectionState();
}

class _AdminAuditSectionState extends State<AdminAuditSection> {
  final _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = true;
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final logs = await _databaseHelper.getActivityLogs(limit: 100);

      if (mounted) {
        setState(() {
          _logs = logs;
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

  List<Map<String, dynamic>> _getFilteredLogs() {
    if (_selectedFilter == 0) return _logs;
    if (_selectedFilter == 1) {
      return _logs
          .where(
            (log) =>
                log[AppConstants.colKategoriLog] == AppConstants.logTransaksi,
          )
          .toList();
    }
    if (_selectedFilter == 2) {
      return _logs
          .where(
            (log) =>
                log[AppConstants.colKategoriLog] == AppConstants.logOtorisasi,
          )
          .toList();
    }
    return _logs;
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _getFilteredLogs();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminAuditHeader(),
            const SizedBox(height: 24),

            AdminAuditFilterBar(
              selectedFilter: _selectedFilter,
              onFilterChanged: (index) {
                setState(() {
                  _selectedFilter = index;
                });
              },
            ),
            const SizedBox(height: 24),

            // Loading state
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              AdminAuditLogList(logs: filteredLogs, onLogTap: _showLogDetail),
          ],
        ),
      ),
    );
  }

  void _showLogDetail(Map<String, dynamic> log) {
    showAdminAuditDetailDialog(context, log);
  }
}
