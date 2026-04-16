import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_card_container.dart';
import '../widgets/registerCharacterImage.dart';
import '../widgets/registerInputField.dart';
import '../widgets/registerMessageBanner.dart';
import '../widgets/registerSubmitButton.dart';
import '../widgets/registerFooterLink.dart';

/// Registration Page - Khusus untuk Owner
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late AuthController _authController;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  final _namaLengkapController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
  }

  /// Handle registration
  Future<void> _handleRegister() async {
    // Validasi empty fields
    if (_namaLengkapController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Semua field harus diisi';
        _successMessage = null;
      });
      return;
    }

    // Validasi password match
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Password konfirmasi tidak sesuai';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final result = await _authController.registerOwner(
      namaLengkap: _namaLengkapController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      setState(() {
        _successMessage = result['message'];
        _errorMessage = null;
      });

      // Clear fields
      _namaLengkapController.clear();
      _usernameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      // Navigate to login after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      setState(() {
        _errorMessage = result['message'];
        _successMessage = null;
      });
    }
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Spacing dari top
              const SizedBox(height: 24),

              // Character Image - untuk owner
              const RegisterCharacterImage(),
              const SizedBox(height: 40),

              // Auth Card Container dengan form
              AuthCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Role Akun',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.lock_outline,
                            color: AppColors.inactive,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Owner (tetap)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    RegisterInputField(
                      label: 'Nama Lengkap',
                      controller: _namaLengkapController,
                      hintText: 'Masukkan nama lengkap Anda',
                      isLoading: _isLoading,
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),

                    RegisterInputField(
                      label: 'Nama Pengguna',
                      controller: _usernameController,
                      hintText: 'Masukkan nama pengguna',
                      isLoading: _isLoading,
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),

                    RegisterInputField(
                      label: 'Kata Sandi',
                      controller: _passwordController,
                      hintText: '••••••••',
                      isLoading: _isLoading,
                      prefixIcon: Icons.lock_outline,
                      obscureText: !_showPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.inactive,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    RegisterInputField(
                      label: 'Konfirmasi Kata Sandi',
                      controller: _confirmPasswordController,
                      hintText: '••••••••',
                      isLoading: _isLoading,
                      prefixIcon: Icons.lock_outline,
                      obscureText: !_showConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.inactive,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 28),

                    if (_errorMessage != null)
                      RegisterMessageBanner(
                        message: _errorMessage!,
                        isError: true,
                      ),

                    if (_successMessage != null)
                      RegisterMessageBanner(
                        message: _successMessage!,
                        isError: false,
                      ),

                    RegisterSubmitButton(
                      isLoading: _isLoading,
                      onPressed: _handleRegister,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              RegisterFooterLink(
                onLoginPressed: () {
                  Navigator.of(context).pushNamed('/login');
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
