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
                subtitle: 'Pilih user atau masukkan username dan password',
              ),
              const SizedBox(height: 32),

              // Quick Select User Buttons (untuk testing)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.surface,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Select User (Testing)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Owner Button
                    _buildQuickSelectButton(
                      context,
                      label: 'Owner',
                      username: 'owner',
                      onPressed: () => _handleLogin('owner', '123456'),
                    ),
                    const SizedBox(height: 8),
                    // Admin Button
                    _buildQuickSelectButton(
                      context,
                      label: 'Admin',
                      username: 'admin1',
                      onPressed: () => _handleLogin('admin1', '123456'),
                    ),
                    const SizedBox(height: 8),
                    // Petugas Button
                    _buildQuickSelectButton(
                      context,
                      label: 'Petugas',
                      username: 'petugas1',
                      onPressed: () => _handleLogin('petugas1', '123456'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

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

  /// Build quick select button
  Widget _buildQuickSelectButton(
    BuildContext context, {
    required String label,
    required String username,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 10),
          side: BorderSide(color: AppColors.primary),
        ),
        child: Text(
          '$label ($username)',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
