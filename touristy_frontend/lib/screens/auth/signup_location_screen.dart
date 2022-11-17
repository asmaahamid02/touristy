import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'package:provider/provider.dart';
import 'package:touristy_frontend/exceptions/http_exception.dart';
import 'package:touristy_frontend/providers/auth.dart';
import 'package:touristy_frontend/utilities/location_handler.dart';
import 'package:touristy_frontend/utilities/snakebar.dart';
import 'package:touristy_frontend/utilities/theme.dart';
import '../../widgets/widgets.dart';

class SignupLocationScreen extends StatefulWidget {
  const SignupLocationScreen({super.key});
  static const routeName = '/signup-location';

  @override
  State<SignupLocationScreen> createState() => _SignupLocationScreenState();
}

class _SignupLocationScreenState extends State<SignupLocationScreen> {
  final Location location = Location();
  Map<String, Object> _user = {};

  PermissionStatus? _permissionStatus;

  bool _isLoading = false;

//check if the user has granted the location permission
  Future<void> _checkPermission() async {
    final status = await location.hasPermission();
    setState(() {
      _permissionStatus = status;
    });
  }

  //request the user to grant the location permission
  Future<void> _requestPermission() async {
    if (_permissionStatus != PermissionStatus.granted) {
      final status = await location.requestPermission();
      setState(() {
        _permissionStatus = status;
      });
    }

    if (_permissionStatus == PermissionStatus.deniedForever) {
      permissions.openAppSettings().then((value) => _checkPermission());
    }
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    PermissionStatus locationPermissionStatus =
        await Location().hasPermission();
    //ask for permission if not granted

    if (locationPermissionStatus == PermissionStatus.granted) {
      try {
        final location = Location();
        final currentLocation = await location.getLocation();
        _user['latitude'] = currentLocation.latitude as double;
        _user['longitude'] = currentLocation.longitude as double;
        if (!mounted) return;
        _user['address'] = await LocationHandler.getAddressFromLatLng(
            context,
            currentLocation.latitude as double,
            currentLocation.longitude as double);
      } catch (error) {
        debugPrint(error.toString());
      }
    }

    try {
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
  }

  @override
  void initState() {
    _checkPermission();
    super.initState();
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
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  _buildListItem('Check places', context),
                  const SizedBox(height: 20),
                  _buildListItem('Find places to visit', context),
                  const SizedBox(height: 20),
                  _buildListItem('Connect with travelers', context),
                  const SizedBox(height: 20),
                  _buildListItem('Share your experiences', context),
                ],
              ),
            ),
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton(
                      onTap: _permissionStatus == PermissionStatus.granted
                          ? _saveForm
                          : _requestPermission,
                      textLabel: _permissionStatus == PermissionStatus.granted
                          ? 'NEXT'
                          : 'ENABLE LOCATION',
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                        onPressed: _permissionStatus == PermissionStatus.granted
                            ? null
                            : _saveForm,
                        child: const Text('SET UP LATER',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.secondary),
        const SizedBox(width: 10),
        Text(title),
      ],
    );
  }
}
