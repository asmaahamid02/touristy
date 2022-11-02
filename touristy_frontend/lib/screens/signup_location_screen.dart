import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as Permissions;
import 'package:touristy_frontend/widgets/logo.dart';

class SignupLocationScreen extends StatefulWidget {
  static const routeName = '/signup-location';

  @override
  State<SignupLocationScreen> createState() => _SignupLocationScreenState();
}

class _SignupLocationScreenState extends State<SignupLocationScreen> {
  final Location location = Location();

  PermissionStatus? _permissionStatus;

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
      Permissions.openAppSettings().then((value) => _checkPermission());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const LogoHorizontal('assets/images/logo_horizontal.png', 100),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            margin: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _permissionStatus == PermissionStatus.granted
                      ? () {
                          print('grant');
                        }
                      : _requestPermission,
                  child: Text(_permissionStatus == PermissionStatus.granted
                      ? 'NEXT'
                      : 'ENABLE LOCATION'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: _permissionStatus == PermissionStatus.granted
                      ? null
                      : () {
                          // Navigator.of(context).pushNamed(HomeScreen.routeName, arguments: _user);
                        },
                  child: const Text('SET UP LATER'),
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
        Icon(Icons.check_circle_outline, color: Theme.of(context).primaryColor),
        const SizedBox(width: 10),
        Text(title),
      ],
    );
  }
}
