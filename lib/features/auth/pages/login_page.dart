import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../config/image_assets.dart';
import '../../../core/preferences/app_preferences.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_card_container.dart';
import '../widgets/auth_role_selector.dart';
import '../widgets/loginCharacterImage.dart';
import '../widgets/loginFooterLinks.dart';
import '../widgets/loginInputField.dart';
import '../widgets/loginMessageBanner.dart';
import '../widgets/loginSubmitButton.dart';

/// Login Page - Dengan role selector dan layout sesuai referensi
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthController _authController;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedRole = 'Owner';

  // Form controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  final Map<String, String> _roleImageMap = {
    'Owner': ImageAssets.personTablet,
    'Admin': ImageAssets.characterPortrait,
    'Staff': ImageAssets.characterCheerful,
  };

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

  /// Ambil image character berdasarkan role
  Widget _getCharacterImage() {
    final imagePath =
        _roleImageMap[_selectedRole] ?? ImageAssets.characterPortrait;
    return LoginCharacterImage(imagePath: imagePath);
  }

  /// Handle role change
  void _handleRoleChange(String newRole) {
    setState(() {
      _selectedRole = newRole;
      _errorMessage = null;
    });
  }

  /// Handle login
  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Username dan password harus diisi';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authController.login(
      _usernameController.text,
      _passwordController.text,
      _selectedRole,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      final user = result['user'];
      final role = user.role.toString().toLowerCase();

      if (mounted) {
        switch (role) {
          case AppConstants.roleOwner:
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/owner_dashboard', (route) => false);
            break;
          case AppConstants.roleAdmin:
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/admin_dashboard', (route) => false);
            break;
          case AppConstants.rolePetugas:
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/petugas_dashboard', (route) => false);
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
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spacing dari top
                  const SizedBox(height: 24),

                  // Character Image - dinamis berdasarkan role
                  _getCharacterImage(),

                  // Auth Card Container dengan form
                  AuthCardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LoginInputField(
                          label: 'Nama Pengguna',
                          controller: _usernameController,
                          hintText: 'Masukkan nama pengguna',
                          isLoading: _isLoading,
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 24),

                        LoginInputField(
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

                        const SizedBox(height: 28),

                        // Error Message
                        if (_errorMessage != null)
                          LoginMessageBanner(message: _errorMessage!),

                        // Sign In Button
                        LoginSubmitButton(
                          isLoading: _isLoading,
                          onPressed: _handleLogin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  LoginFooterLinks(
                    showRegister:
                        _selectedRole.toLowerCase() ==
                        AppConstants.roleOwner.toLowerCase(),
                    onRegisterPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    onDebugPressed: () {
                      Navigator.of(context).pushNamed('/debug');
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            // Role Selector - Positioned di top right
            AuthRoleSelector(
              initialRole: _selectedRole,
              onRoleChanged: _handleRoleChange,
            ),
          ],
        ),
      ),
    );
  }
}
