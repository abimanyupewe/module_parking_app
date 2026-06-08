import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../services/database_helper.dart';
import '../../../models/user_model.dart';
import '../widgets/debugActionButton.dart';
import '../widgets/debugActionSection.dart';
import '../widgets/debugLogPanel.dart';

/// Debug Page untuk Testing Database Operations
class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String _debugOutput = 'Ready for testing...\n';

  void _addLog(String message) {
    setState(() {
      _debugOutput +=
          '${DateTime.now().toString().substring(11, 19)} - $message\n';
    });
  }

  void _clearLog() {
    setState(() {
      _debugOutput = 'Log cleared\n';
    });
  }

  Future<void> _testInsertUser() async {
    _addLog('Testing insert user...');
    try {
      final testUser = UserModel(
        namaLengkap: 'Debug User',
        username: 'debuguser_${DateTime.now().millisecondsSinceEpoch}',
        password: 'hashedpassword123456789012345678901234567890',
        role: 'Owner',
        status: 'aktif',
      );

      _addLog('User object created: $testUser');
      _addLog('User map: ${testUser.toMap()}');

      final result = await _dbHelper.insertUser(testUser);
      _addLog('Insert result: $result');

      if (result > 0) {
        _addLog('SUCCESS: User inserted with ID $result');
      } else {
        _addLog('FAILED: Insert returned $result');
      }
    } catch (e) {
      _addLog('ERROR: ${e.toString()}');
    }
  }

  Future<void> _testGetAllUsers() async {
    _addLog('Fetching all users...');
    try {
      final users = await _dbHelper.getAllUsers();
      _addLog('Found ${users.length} users:');
      for (var user in users) {
        _addLog('  - ${user.username} (${user.role})');
      }
    } catch (e) {
      _addLog('ERROR: ${e.toString()}');
    }
  }

  Future<void> _testGetUserByUsername(String username) async {
    _addLog('Getting user: $username');
    try {
      final user = await _dbHelper.getUserByUsername(username);
      if (user != null) {
        _addLog('Found: $user');
      } else {
        _addLog('User not found');
      }
    } catch (e) {
      _addLog('ERROR: ${e.toString()}');
    }
  }

  Future<void> _clearAllData() async {
    _addLog('Clearing ALL data from database...');
    try {
      await _dbHelper.clearAllData();
      _addLog('SUCCESS: All data cleared');
    } catch (e) {
      _addLog('ERROR: ${e.toString()}');
    }
  }

  Future<void> _clearUsers() async {
    _addLog('Clearing user data...');
    try {
      await _dbHelper.clearUsers();
      _addLog('SUCCESS: All users deleted');
    } catch (e) {
      _addLog('ERROR: ${e.toString()}');
    }
  }

  Future<void> _clearTransaksi() async {
    _addLog('Clearing transaksi data...');
    try {
      await _dbHelper.clearTransaksi();
      _addLog('SUCCESS: All transactions deleted');
    } catch (e) {
      _addLog('ERROR: ${e.toString()}');
    }
  }

  Future<void> _clearKendaraan() async {
    _addLog('Clearing kendaraan data...');
    try {
      await _dbHelper.clearKendaraan();
      _addLog('SUCCESS: All vehicles deleted');
    } catch (e) {
      _addLog('ERROR: ${e.toString()}');
    }
  }

  Future<void> _clearActivityLogs() async {
    _addLog('Clearing activity logs...');
    try {
      await _dbHelper.clearActivityLogs();
      _addLog('SUCCESS: All activity logs deleted');
    } catch (e) {
      _addLog('ERROR: ${e.toString()}');
    }
  }

  Future<void> _resetDatabase() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Database?'),
        content: const Text(
          'This will DROP all tables and recreate the schema. All data will be lost!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              _addLog('Resetting database...');
              try {
                await _dbHelper.resetDatabase();
                _addLog('SUCCESS: Database reset and schema recreated');
              } catch (e) {
                _addLog('ERROR: ${e.toString()}');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDatabaseFile() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Database File?'),
        content: const Text(
          'This will completely delete the database file. The app will recreate it on next launch.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              _addLog('Deleting database file...');
              try {
                await _dbHelper.deleteDatabaseFile();
                _addLog('SUCCESS: Database file deleted');
              } catch (e) {
                _addLog('ERROR: ${e.toString()}');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Debug'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DebugLogPanel(output: _debugOutput),

            // Test Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DebugActionSection(
                    title: 'Test Operations',
                    titleColor: AppColors.primary,
                    children: [
                      DebugActionButton(
                        label: 'Test Insert User',
                        onPressed: _testInsertUser,
                      ),
                      const SizedBox(height: 8),
                      DebugActionButton(
                        label: 'Get All Users',
                        onPressed: _testGetAllUsers,
                      ),
                      const SizedBox(height: 8),
                      DebugActionButton(
                        label: 'Get User: owner',
                        onPressed: () => _testGetUserByUsername('owner'),
                      ),
                      const SizedBox(height: 8),
                      DebugActionButton(
                        label: 'Clear Log',
                        onPressed: _clearLog,
                      ),
                    ],
                  ),
                  DebugActionSection(
                    title: 'Clear Data Options',
                    titleColor: AppColors.danger,
                    children: [
                      DebugActionButton(
                        label: 'Clear Activity Logs',
                        onPressed: _clearActivityLogs,
                        icon: Icons.delete_outline,
                        backgroundColor: AppColors.warning,
                      ),
                      const SizedBox(height: 8),
                      DebugActionButton(
                        label: 'Clear Vehicles',
                        onPressed: _clearKendaraan,
                        icon: Icons.delete_outline,
                        backgroundColor: AppColors.warning,
                      ),
                      const SizedBox(height: 8),
                      DebugActionButton(
                        label: 'Clear Transactions',
                        onPressed: _clearTransaksi,
                        icon: Icons.delete_outline,
                        backgroundColor: AppColors.warning,
                      ),
                      const SizedBox(height: 8),
                      DebugActionButton(
                        label: 'Clear Users (Keep Master Data)',
                        onPressed: _clearUsers,
                        icon: Icons.delete_outline,
                        backgroundColor: AppColors.warning,
                      ),
                      const SizedBox(height: 8),
                      DebugActionButton(
                        label: 'Clear ALL Data',
                        onPressed: _clearAllData,
                        icon: Icons.delete_sweep,
                        backgroundColor: AppColors.danger,
                      ),
                      const SizedBox(height: 8),
                      DebugActionButton(
                        label: 'Reset Database (Drop & Recreate)',
                        onPressed: _resetDatabase,
                        icon: Icons.restore,
                        backgroundColor: AppColors.danger,
                      ),
                      const SizedBox(height: 8),
                      DebugActionButton(
                        label: 'Delete Database File',
                        onPressed: _deleteDatabaseFile,
                        icon: Icons.delete_forever,
                        backgroundColor: const Color(0xFF8B0000),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
