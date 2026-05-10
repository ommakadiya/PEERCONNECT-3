import 'package:flutter/material.dart';
import 'package:peerconnect/utils/constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would re-authenticate with Firebase using current password
      // and then call user.updatePassword(). For now, just simulate success.
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully!', style: TextStyle(color: AppConstants.textPrimary)),
          backgroundColor: AppConstants.successColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppConstants.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Change Password', style: TextStyle(color: AppConstants.textPrimary, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingLg),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(Icons.lock_reset, size: 80, color: AppConstants.secondaryColor),
                    const SizedBox(height: 24),
                    const Text(
                      'Create a new password that is at least 6 characters long.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppConstants.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                    _buildPasswordField(
                      'Current Password', 
                      _currentPasswordController, 
                      _obscureCurrent, 
                      () => setState(() => _obscureCurrent = !_obscureCurrent)
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      'New Password', 
                      _newPasswordController, 
                      _obscureNew, 
                      () => setState(() => _obscureNew = !_obscureNew),
                      validator: (val) {
                        if (val == null || val.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      }
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      'Confirm New Password', 
                      _confirmPasswordController, 
                      _obscureConfirm, 
                      () => setState(() => _obscureConfirm = !_obscureConfirm),
                      validator: (val) {
                        if (val != _newPasswordController.text) return 'Passwords do not match';
                        return null;
                      }
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.secondaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Update Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscure, VoidCallback toggleObscure, {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: AppConstants.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppConstants.textSecondary),
        prefixIcon: const Icon(Icons.lock_outline, color: AppConstants.accentColor),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: AppConstants.textMuted),
          onPressed: toggleObscure,
        ),
        filled: true,
        fillColor: AppConstants.surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppConstants.primaryColor.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppConstants.primaryColor.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.primaryColor),
        ),
      ),
      validator: validator ?? (value) => value == null || value.isEmpty ? 'Required field' : null,
    );
  }
}
