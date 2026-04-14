import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../config/image_assets.dart';
import '../../../core/preferences/app_preferences.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_card_container.dart';
import '../widgets/auth_role_selector.dart';

/// Login Page - Dengan role selector dan layout sesuai referensi
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
  bool _keepSignedIn = false;

  final Map<String, String> _roleImageMap = {
    'Owner': ImageAssets.characterPortrait,
    'Admin': ImageAssets.characterCheerful,
    'Staff': ImageAssets.characterPortrait,
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

  /// Ambil SVG character image berdasarkan role
  Widget _getCharacterImage() {
    final imagePath =
        _roleImageMap[_selectedRole] ?? ImageAssets.characterPortrait;
    return SizedBox(
      width: 200,
      height: 200,
      child: SvgPicture.asset(
        imagePath,
        fit: BoxFit.contain,
        placeholderBuilder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
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
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      final user = result['user'];
      final role = user.role;

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
                children: [
                  // Spacing dari top
                  const SizedBox(height: 16),

                  // Character Image SVG - dinamis berdasarkan role
                  _getCharacterImage(),
                  const SizedBox(height: 32),

                  // Auth Card Container dengan form
                  AuthCardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username Field
                        Text(
                          'Username',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _usernameController,
                          enabled: !_isLoading,
                          decoration: InputDecoration(
                            hintText: 'Enter your username',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: AppColors.inactive,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: AppColors.secondary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: AppColors.inactive,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 20),

                        // Password Field dengan link Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Password',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Handle forgot password
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: AppColors.inactive,
                              size: 20,
                            ),
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
                            filled: true,
                            fillColor: AppColors.secondary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: AppColors.inactive,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),

                        // Keep me signed in checkbox
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _keepSignedIn,
                                onChanged: (value) {
                                  setState(() {
                                    _keepSignedIn = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Keep me signed in',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: AppColors.inactive),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Error Message
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.danger),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppColors.danger,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: AppColors.danger,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Footer - Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Debug Button
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/debug');
                    },
                    icon: const Icon(Icons.bug_report, size: 16),
                    label: const Text('Debug', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(height: 24),
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
