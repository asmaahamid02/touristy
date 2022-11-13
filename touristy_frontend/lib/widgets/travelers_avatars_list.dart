import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../exceptions/http_exception.dart';

import '../providers/providers.dart';
import '../models/models.dart';
import './widgets.dart';

class TravelersAvatarsList extends StatefulWidget {
  const TravelersAvatarsList({
    Key? key,
  }) : super(key: key);

  @override
  State<TravelersAvatarsList> createState() => _TravelersAvatarsListState();
}

class _TravelersAvatarsListState extends State<TravelersAvatarsList> {
  var isInit = true;
  var _isLoading = false;

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      _isLoading = true;

      try {
        await Provider.of<TravelersUsers>(context, listen: false)
            .fetchTravelersUsers();
      } on HttpException catch (error) {
        _showToastMessage(error.toString());
      } catch (error) {
        _showToastMessage('Could not fetch Users, try again.');
      }
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final travelersUsersData = Provider.of<TravelersUsers>(context);
    final travelersUsers = travelersUsersData.travelersUsers;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Text(
              'Travelers around the world',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          _isLoading
              ? const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Stories(
                  storiesData: travelersUsers
                      .map((user) => StoryData(
                          id: user.id,
                          name: user.fullName,
                          url: user.profilePictureUrl,
                          countryCode: user.countryCode))
                      .toList(),
                ),
        ],
      ),
    );
  }
}
