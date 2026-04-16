import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../services/database_helper.dart';
import '../../../models/user_model.dart';

/// Debug Page untuk Testing Database Operations
class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

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
            // Debug Output
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
              child: Text(
                _debugOutput,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 11,
                  color: Color(0xFF00FF00),
                ),
              ),
            ),

            // Test Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Test Operations',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _testInsertUser,
                    child: const Text('Test Insert User'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _testGetAllUsers,
                    child: const Text('Get All Users'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _testGetUserByUsername('owner'),
                    child: const Text('Get User: owner'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _clearLog,
                    child: const Text('Clear Log'),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 8),
                    child: Text(
                      'Clear Data Options',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.danger,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _clearActivityLogs,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Clear Activity Logs'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _clearKendaraan,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Clear Vehicles'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _clearTransaksi,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Clear Transactions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _clearUsers,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Clear Users (Keep Master Data)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _clearAllData,
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Clear ALL Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _resetDatabase,
                    icon: const Icon(Icons.restore),
                    label: const Text('Reset Database (Drop & Recreate)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _deleteDatabaseFile,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Delete Database File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8B0000),
                    ),
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
