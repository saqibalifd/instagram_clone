import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerUtil {
  PermissionHandlerUtil._();

  /// Requests camera permission.
  /// Returns true if granted, false otherwise.
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      await _showPermissionDialog(
        context,
        title: 'Camera Permission Required',
        message:
            'Camera access has been permanently denied. Please enable it in app settings to take photos.',
      );
      return false;
    }

    final result = await Permission.camera.request();

    if (result.isGranted) return true;

    if (result.isPermanentlyDenied && context.mounted) {
      await _showPermissionDialog(
        context,
        title: 'Camera Permission Required',
        message:
            'Camera access has been permanently denied. Please enable it in app settings to take photos.',
      );
    }

    return false;
  }

  /// Requests gallery/photos permission.
  /// Returns true if granted, false otherwise.
  static Future<bool> requestGalleryPermission(BuildContext context) async {
    final Permission permission = Platform.isAndroid
        ? Permission.photos
        : Permission.photos;

    final status = await permission.status;

    if (status.isGranted || status.isLimited) return true;

    if (status.isPermanentlyDenied) {
      await _showPermissionDialog(
        context,
        title: 'Gallery Permission Required',
        message:
            'Gallery access has been permanently denied. Please enable it in app settings to choose photos.',
      );
      return false;
    }

    final result = await permission.request();

    if (result.isGranted || result.isLimited) return true;

    if (result.isPermanentlyDenied && context.mounted) {
      await _showPermissionDialog(
        context,
        title: 'Gallery Permission Required',
        message:
            'Gallery access has been permanently denied. Please enable it in app settings to choose photos.',
      );
    }

    return false;
  }

  /// Shows a dialog prompting the user to open app settings.
  static Future<void> _showPermissionDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
