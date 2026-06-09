import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'permission_handler_util.dart';

class ImagePickerUtil {
  ImagePickerUtil._();

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickFromGallery(
    BuildContext context, {
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final granted = await PermissionHandlerUtil.requestGalleryPermission(
      context,
    );
    if (!granted) return null;

    final XFile? xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    return xFile == null ? null : File(xFile.path);
  }

  static Future<File?> pickFromCamera(
    BuildContext context, {
    bool preferFrontCamera = false,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final granted = await PermissionHandlerUtil.requestCameraPermission(
      context,
    );
    if (!granted) return null;

    final XFile? xFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: preferFrontCamera
          ? CameraDevice.front
          : CameraDevice.rear,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    return xFile == null ? null : File(xFile.path);
  }

  static Future<File?> pick(
    BuildContext context, {
    double? maxWidth,
    double? maxHeight,
    int? imageQuality = 85,
  }) async {
    final ImageSource? source = await _showSourceSheet(context);
    if (source == null) return null;

    // Request the appropriate permission based on chosen source
    final bool granted = source == ImageSource.camera
        ? await PermissionHandlerUtil.requestCameraPermission(context)
        : await PermissionHandlerUtil.requestGalleryPermission(context);

    if (!granted) return null;

    final XFile? xFile = await _picker.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    return xFile == null ? null : File(xFile.path);
  }

  static Future<ImageSource?> _showSourceSheet(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
