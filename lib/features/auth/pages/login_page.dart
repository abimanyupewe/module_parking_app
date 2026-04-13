import 'package:flutter/material.dart';
import '../../../config/colors.dart';
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
