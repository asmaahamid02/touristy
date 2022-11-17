import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageOtionsBottomSheet extends StatelessWidget {
  final Function(ImageSource source) onTap;
  const ImageOtionsBottomSheet({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Photo'),
            onTap: () async {
              PermissionStatus status = await Permission.camera.status;

              if (status.isGranted) {
                onTap(ImageSource.camera);
              } else {
                openAppSettings();
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Browse Gallery'),
            onTap: () async {
              PermissionStatus status = await Permission.storage.status;

              if (status.isGranted) {
                onTap(ImageSource.gallery);
              } else {
                openAppSettings();
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text('Cancel'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
