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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
