import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../core/preferences/app_preferences.dart';
import '../../../models/user_selection_model.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_header_widget.dart';
import '../widgets/login_form_widget.dart';

/// Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthController _authController;
  bool _isLoading = false;
  String? _errorMessage;
  UserSelectionModel? _selectedUser;

  // List of test users
  late final List<UserSelectionModel> _testUsers = [
    UserSelectionModel(
      displayName: 'Owner',
      username: 'owner',
      password: '123456',
    ),
    UserSelectionModel(
      displayName: 'Admin',
      username: 'admin1',
      password: '123456',
    ),
    UserSelectionModel(
      displayName: 'Petugas',
      username: 'petugas1',
      password: '123456',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _initializePreferences();
    _selectedUser = _testUsers.first; // Set default ke Owner
  }

  /// Inisialisasi preferences
  void _initializePreferences() async {
    await AppPreferences.init();
  }

  /// Handle login
  Future<void> _handleLogin(String username, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authController.login(username, password);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      // Navigate ke dashboard sesuai role
      final user = result['user'];
      final role = user.role;

      if (mounted) {
        switch (role) {
          case 'owner':
            Navigator.of(context).pushReplacementNamed('/owner_dashboard');
            break;
          case 'admin':
            Navigator.of(context).pushReplacementNamed('/admin_dashboard');
            break;
          case 'petugas':
            Navigator.of(context).pushReplacementNamed('/petugas_dashboard');
            break;
          default:
            setState(() {
              _errorMessage = 'Role user tidak dikenali';
            });
        }
      }
    } else {
      setState(() {
        _errorMessage = result['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // Header
              const SizedBox(height: 40),
              const AuthHeaderWidget(
                title: 'Login',
                subtitle: 'Pilih user atau masukkan username dan password',
              ),
              const SizedBox(height: 32),

              // User Selection Dropdown
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<UserSelectionModel>(
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  value: _selectedUser,
                  items: _testUsers.map((user) {
                    return DropdownMenuItem(
                      value: user,
                      child: Text(user.displayName),
                    );
                  }).toList(),
                  onChanged: (user) {
                    if (user != null) {
                      setState(() {
                        _selectedUser = user;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Auto-login with selected user button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => _selectedUser != null
                            ? _handleLogin(
                                _selectedUser!.username,
                                _selectedUser!.password,
                              )
                            : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    _isLoading ? 'Logging in...' : 'Login Dengan User Terpilih',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Container(height: 1, color: AppColors.border),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'atau',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(height: 1, color: AppColors.border),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Form untuk manual input
              LoginFormWidget(
                onSubmit: _handleLogin,
                isLoading: _isLoading,
                errorMessage: _errorMessage,
              ),
              const SizedBox(height: 24),

              // Footer Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/forgot_password');
                    },
                    child: Text(
                      'Lupa Password?',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.inactive,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
