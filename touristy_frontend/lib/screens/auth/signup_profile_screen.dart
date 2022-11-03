import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import '../../screens/tabs.dart';
import 'dart:io';

import '../../widgets/logo.dart';
import '../../widgets/image_options_bottom_sheet.dart';
import './signup_location_screen.dart';

class SignupProfileScreen extends StatefulWidget {
  const SignupProfileScreen({super.key});
  static const routeName = '/signup-profile';

  @override
  State<SignupProfileScreen> createState() => _SignupProfileScreenState();
}

class _SignupProfileScreenState extends State<SignupProfileScreen> {
  Map<String, Object> _user = {};
  String _buttonText = 'ADD PROFILE PICTURE';

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future _pickImage(ImageSource source) async {
    try {
      final pickedImage = await _picker.pickImage(source: source);

      if (pickedImage == null) return;
      File? img = File(pickedImage.path);

      setState(() {
        _image = img;
        _buttonText = 'NEXT';
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  void _showBottomSheet() async {
    if (_image == null) {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return ImageOtionsBottomSheet(onTap: _pickImage);
        },
      );
    }
  }

  void _saveForm() async {
    if (_image != null) {
      _user['profile_picture'] = _image as File;
    }

    PermissionStatus locationPermissionStatus =
        await Location().hasPermission();
    if (locationPermissionStatus == PermissionStatus.granted) {
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacementNamed(Tabs.routeName, arguments: _user);
    } else {
      if (!mounted) return;
      Navigator.of(context)
          .pushNamed(SignupLocationScreen.routeName, arguments: _user);
    }
  }

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const LogoHorizontal('assets/images/logo_horizontal.png', 100),
          Expanded(
            child: Column(
              children: [
                ProfileImageContainer(image: _image, onTap: _showBottomSheet),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Show us your best',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 10),
                    Text('SELFIE',
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Theme.of(context).primaryColor,
                                )),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Photos make your profile more engaging',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _image == null ? _showBottomSheet : _saveForm,
                  child: Text(_buttonText),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: _saveForm,
                  child: const Text('SET UP LATER'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileImageContainer extends StatelessWidget {
  final VoidCallback onTap;
  final File? image;
  const ProfileImageContainer({super.key, required this.onTap, this.image});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Center(
            child: Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: Stack(children: [
                  CircleAvatar(
                    backgroundImage: image == null
                        ? const AssetImage('assets/images/profile_picture.png')
                        : FileImage(image as File) as ImageProvider,
                    radius: 150.0,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.image_outlined,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ])),
          ),
        ),
      ),
    );
  }
}
