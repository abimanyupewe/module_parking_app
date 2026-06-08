import 'package:flutter/material.dart';
import '../../../widgets/widgets.dart';

/// Widget form untuk login
class LoginFormWidget extends StatefulWidget {
  final Function(String username, String password) onSubmit;
  final bool isLoading;
  final String? errorMessage;

  const LoginFormWidget({
    Key? key,
    required this.onSubmit,
    this.isLoading = false,
    this.errorMessage,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _usernameController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Username Field
          CustomTextField(
            label: 'Username',
            hint: 'Masukkan username',
            controller: _usernameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username tidak boleh kosong';
              }
              if (value.length < 3) {
                return 'Username minimal 3 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password Field
          CustomTextField(
            label: 'Password',
            hint: 'Masukkan password',
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password tidak boleh kosong';
              }
              if (value.length < 6) {
                return 'Password minimal 6 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Error Message
          if (widget.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                widget.errorMessage!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Login Button
          PrimaryButton(
            label: 'Login',
            onPressed: _handleSubmit,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}
