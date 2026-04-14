import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../core/preferences/app_preferences.dart';
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

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _initializePreferences();
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
          case AppConstants.roleOwner:
            Navigator.of(context).pushNamed('/owner_dashboard');
            break;
          case AppConstants.roleAdmin:
            Navigator.of(context).pushNamed('/admin_dashboard');
            break;
          case AppConstants.rolePetugas:
            Navigator.of(context).pushNamed('/petugas_dashboard');
            break;
          default:
            setState(() {
              _errorMessage = 'Role user tidak dikenali: $role';
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
                subtitle: 'Masukkan username dan password Anda',
              ),
              const SizedBox(height: 48),

              // Form
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
                  Text(
                    'Belum punya akun? ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: Text(
                      'Daftar',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Debug Button
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed('/debug');
                },
                icon: const Icon(Icons.bug_report, size: 16),
                label: const Text('Debug', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
