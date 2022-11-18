import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../screens.dart';
import '../../widgets/widgets.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  static const routeName = '/';
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/landing.mp4')
          ..initialize().then((_) {
            _videoPlayerController.play();
            _videoPlayerController.setLooping(true);
            setState(() {});
          });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // _videoView(),
          const Logo('assets/images/logo_vertical.png'),
          Padding(
            padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrimaryButton(
                    textLabel: 'signup',
                    onTap: () {
                      Navigator.of(context).pushNamed(SignupScreen.routeName);
                    }),
                PrimaryButton(
                    textLabel: 'signin',
                    onTap: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _videoView() {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoPlayerController.value.size.width,
          height: _videoPlayerController.value.size.height,
          child: VideoPlayer(_videoPlayerController),
        ),
      ),
    );
  }
}
