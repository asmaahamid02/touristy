import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/widgets.dart';
import '../../utilities/utilities.dart';

enum ImageType { profile, cover }

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const routeName = '/edit-profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _profileImage;
  File? _coverImage;

  Future _pickImage(ImageSource source, {ImageType? imageType}) async {
    final ImagePicker picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: source);

      if (pickedImage == null) return;
      File? img = File(pickedImage.path);

      if (imageType == ImageType.profile) {
        setState(() {
          _profileImage = img;
        });
      } else {
        setState(() {
          _coverImage = img;
        });
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      Navigator.of(context).pop();
    }
  }

  void _showBottomSheet(ImageType? imageType) async {
    ModalBottomSheetCommon.show(
      context,
      ImageOtionsBottomSheet(
          onTap: (source) => _pickImage(source, imageType: imageType)),
      height: 215,
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor:
          brightness == Brightness.light ? AppColors.backgroundWhite : null,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.backgroundLightGrey,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ProfileCover(
                defaultImageProvider: _coverImage != null
                    ? FileImage(_coverImage!) as ImageProvider
                    : null,
                onTap: () => _showBottomSheet(ImageType.cover),
              ),
              ProfileAvatar(
                // imaegUrl: 'https://picsum.photos/200',
                defaultImageProvider: _profileImage != null
                    ? FileImage(_profileImage!) as ImageProvider
                    : null,
                onTap: () => _showBottomSheet(ImageType.profile),
              ),
            ],
          )
        ],
      ),
    );
  }
}
