import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/providers/auth.dart';
import 'package:touristy_frontend/screens/auth/signup_location_screen.dart';
import 'package:touristy_frontend/utilities/location_handler.dart';
import 'package:touristy_frontend/utilities/modal_bottom_sheet.dart';
import 'package:touristy_frontend/utilities/snakebar.dart';
import 'package:touristy_frontend/utilities/theme.dart';

import '../../widgets/widgets.dart';

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
  bool _isLoading = false;

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
      ModalBottomSheetCommon.show(
        context,
        ImageOtionsBottomSheet(onTap: _pickImage),
        height: 215,
      );
    }
  }

  Future<void> _saveForm() async {
    if (_image != null) {
      _user['profile_picture'] = _image as File;
    }

    PermissionStatus locationPermissionStatus =
        await Location().requestPermission();
    //ask for permission if not granted

    if (locationPermissionStatus == PermissionStatus.granted) {
      try {
        setState(() {
          _isLoading = true;
        });
        final location = Location();
        final currentLocation = await location.getLocation();
        _user['latitude'] = currentLocation.latitude as double;
        _user['longitude'] = currentLocation.longitude as double;
        if (!mounted) return;
        _user['address'] = await LocationHandler.getAddressFromLatLng(
            context,
            currentLocation.latitude as double,
            currentLocation.longitude as double);
        if (!mounted) return;

        await Provider.of<Auth>(context, listen: false).signup(_user);

        if (!mounted) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed('/');
      } on HttpException catch (error) {
        final errorMessage = error.toString();
        if (!mounted) return;
        SnakeBarCommon.show(context, errorMessage);
      } catch (error) {
        if (!mounted) return;
        SnakeBarCommon.show(context, error.toString());
      }
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } else {
      if (!mounted) return;
      Navigator.of(context)
          .pushNamed(SignupLocationScreen.routeName, arguments: _user);
    }
  }

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor:
          brightness == Brightness.light ? Theme.of(context).cardColor : null,
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LogoHorizontal(
              brightness == Brightness.light
                  ? 'assets/images/logo_horizontal.png'
                  : 'assets/images/login_dark.png',
              100),
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
                    const Text('SELFIE',
                        style: TextStyle(
                            color: AppColors.secondary, fontSize: 20.0)),
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
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton(
                      onTap: _image == null ? _showBottomSheet : _saveForm,
                      textLabel: _buttonText,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                        onPressed: _image == null ? _saveForm : null,
                        child: const Text(
                          'SET UP LATER',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
                  color: Theme.of(context).cardColor,
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
