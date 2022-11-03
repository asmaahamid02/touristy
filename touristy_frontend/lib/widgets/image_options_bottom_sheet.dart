import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageOtionsBottomSheet extends StatelessWidget {
  final Function(ImageSource source) onTap;
  const ImageOtionsBottomSheet({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Center(
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
                // onTap(ImageSource.camera);
              },
              textColor: Theme.of(context).primaryColorDark,
              iconColor: Theme.of(context).primaryColorDark,
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
              textColor: Theme.of(context).primaryColorDark,
              iconColor: Theme.of(context).primaryColorDark,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(context).pop(),
              textColor: Theme.of(context).errorColor,
              iconColor: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
