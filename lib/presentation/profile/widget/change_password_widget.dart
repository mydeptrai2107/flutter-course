import 'package:app/presentation/profile/providers/profile_provider.dart';
import 'package:app/sevices/dialog_sevices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    // Validation
    if (_currentPasswordController.text.isEmpty) {
      DialogSevices.notificeDialog(
        context: context,
        isSuccess: false,
        content: 'Vui lòng nhập mật khẩu hiện tại',
      );
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      DialogSevices.notificeDialog(
        context: context,
        isSuccess: false,
        content: 'Vui lòng nhập mật khẩu mới',
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      DialogSevices.notificeDialog(
        context: context,
        isSuccess: false,
        content: 'Mật khẩu mới phải có ít nhất 6 ký tự',
      );
      return;
    }

    if (_confirmPasswordController.text.isEmpty) {
      DialogSevices.notificeDialog(
        context: context,
        isSuccess: false,
        content: 'Vui lòng xác nhận mật khẩu mới',
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      DialogSevices.notificeDialog(
        context: context,
        isSuccess: false,
        content: 'Mật khẩu xác nhận không khớp',
      );
      return;
    }

    final profileProvider = context.read<ProfileProvider>();
    final success = await profileProvider.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (mounted) {
      DialogSevices.notificeDialog(
        context: context,
        isSuccess: success,
        content: success
            ? 'Đổi mật khẩu thành công'
            : 'Đổi mật khẩu thất bại. Vui lòng kiểm tra mật khẩu hiện tại',
      );

      if (success) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              children: [
                // Current Password Field
                _buildPasswordField(
                  controller: _currentPasswordController,
                  label: 'Mật khẩu hiện tại',
                  icon: Icons.lock,
                  isVisible: _showCurrentPassword,
                  onVisibilityChanged: (value) {
                    setState(() => _showCurrentPassword = value);
                  },
                ),

                // New Password Field
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'Mật khẩu mới',
                  icon: Icons.lock_outline,
                  isVisible: _showNewPassword,
                  onVisibilityChanged: (value) {
                    setState(() => _showNewPassword = value);
                  },
                ),

                // Confirm Password Field
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Xác nhận mật khẩu mới',
                  icon: Icons.lock_outline,
                  isVisible: _showConfirmPassword,
                  onVisibilityChanged: (value) {
                    setState(() => _showConfirmPassword = value);
                  },
                ),

                const SizedBox(height: 20),

                // Change Password Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: profileProvider.isLoading
                        ? null
                        : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: profileProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Đổi mật khẩu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isVisible,
    required Function(bool) onVisibilityChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: !isVisible,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.blue),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () => onVisibilityChanged(!isVisible),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
