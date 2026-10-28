import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final _passwordFormKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isChangingPassword = false;
  bool _showPasswordSection = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentData() async {
    final name = await AuthService.getUserName();
    final email = await AuthService.getUserEmail();

    if (mounted) {
      setState(() {
        _nameController.text = name;
        _emailController.text = email;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
  }

  Future<void> _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    setState(() => _isChangingPassword = true);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isChangingPassword = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fitur ganti password via API sedang dikembangkan'),
          backgroundColor: AppColors.primary,
        ),
      );
    }

    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    setState(() => _showPasswordSection = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : Colors.grey[50];
    final borderColor = isDark ? AppColors.darkBorder : Colors.grey[200]!;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // FORM INFO DASAR
            Text(
              'Informasi Dasar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    hint: 'Masukkan nama lengkap',
                    label: 'Nama Lengkap',
                    prefixIcon: Icons.person_outline,
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      if (value.trim().length < 2) {
                        return 'Nama minimal 2 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    hint: 'Masukkan email',
                    label: 'Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Simpan Perubahan',
                    isLoading: _isLoading,
                    onPressed: _saveProfile,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            // GANTI PASSWORD
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  // Header toggle
                  InkWell(
                    onTap: () {
                      setState(
                        () => _showPasswordSection = !_showPasswordSection,
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Ganti Password',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                color: textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            _showPasswordSection
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Form ganti password
                  if (_showPasswordSection) ...[
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _passwordFormKey,
                        child: Column(
                          children: [
                            AppTextField(
                              hint: 'Masukkan password lama',
                              label: 'Password Lama',
                              prefixIcon: Icons.lock_outline,
                              isPassword: true,
                              controller: _oldPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password lama tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            AppTextField(
                              hint: 'Minimal 6 karakter',
                              label: 'Password Baru',
                              prefixIcon: Icons.lock_reset,
                              isPassword: true,
                              controller: _newPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password baru tidak boleh kosong';
                                }
                                if (value.length < 6) {
                                  return 'Password minimal 6 karakter';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            AppTextField(
                              hint: 'Ulangi password baru',
                              label: 'Konfirmasi Password',
                              prefixIcon: Icons.lock_reset,
                              isPassword: true,
                              controller: _confirmPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Konfirmasi tidak boleh kosong';
                                }
                                if (value != _newPasswordController.text) {
                                  return 'Password tidak sama';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            AppButton(
                              text: 'Ganti Password',
                              isLoading: _isChangingPassword,
                              onPressed: _changePassword,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
