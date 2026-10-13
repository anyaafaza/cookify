import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../services/user_photo_service.dart';

class UserAvatar extends StatefulWidget {
  final String userEmail;
  final String userName;
  final double size;
  final Color? backgroundColor;
  final bool showBorder;

  const UserAvatar({
    super.key,
    required this.userEmail,
    required this.userName,
    this.size = 40,
    this.backgroundColor,
    this.showBorder = false,
  });

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  Uint8List? _photoBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhoto();
  }

  @override
  void didUpdateWidget(UserAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kalau email berubah, reload foto
    if (oldWidget.userEmail != widget.userEmail) {
      _loadPhoto();
    }
  }

  Future<void> _loadPhoto() async {
    if (mounted) setState(() => _isLoading = true);
    final bytes = await UserPhotoService.getPhoto(widget.userEmail);
    if (mounted) {
      setState(() {
        _photoBytes = bytes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kalau ada foto → tampilkan gambar
    if (_photoBytes != null && _photoBytes!.isNotEmpty) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: widget.showBorder
              ? Border.all(color: Colors.white, width: 3)
              : null,
        ),
        child: ClipOval(
          child: Image.memory(
            _photoBytes!,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final initial =
        widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U';

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.backgroundColor != null
              ? [widget.backgroundColor!, widget.backgroundColor!]
              : [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: widget.showBorder
            ? Border.all(color: Colors.white, width: 3)
            : null,
      ),
      child: Center(
        child: _isLoading
            ? SizedBox(
                width: widget.size * 0.4,
                height: widget.size * 0.4,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                initial,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.size * 0.4,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
      ),
    );
  }
}
