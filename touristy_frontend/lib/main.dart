import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './screens/new_post_screen.dart';
import './screens/splash_screen.dart';
import './screens/tabs.dart';
import './screens/home_screen.dart';
import './screens/auth/signup_location_screen.dart';
import './screens/auth/signup_profile_screen.dart';
import './screens/auth/signup_pesronal_info_screen.dart';
import './screens/auth/login_screen.dart';
import './screens/auth/signup_screen.dart';
import './screens/landing_screen.dart';

import './providers/users.dart';
import './providers/auth.dart';
import './providers/posts.dart';

void main() {
  //portrait mode only
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Users>(
          create: (_) => Users(),
          update: (_, auth, previousUsers) => previousUsers!..update(auth),
        ),
        ChangeNotifierProxyProvider<Auth, Posts>(
          create: (_) => Posts(),
          update: (_, auth, previousPosts) => previousPosts!..update(auth),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Touristy',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.lightBlue,
            fontFamily: 'Raleway',
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 40,
                  ),
                ),
                //secondary background color
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.lightBlue,
                ),

                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 36),
                ),
              ),
            ),
            textTheme: const TextTheme(
              button: TextStyle(
                // fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              headline5: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              headline6: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(
              size: 24,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.black,
                ),
              ),
            ),
            scaffoldBackgroundColor: Colors.grey[100],
          ),
          home: auth.isAuth
              ? const Tabs()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : const LandingScreen(),
                ),
          routes: {
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            SignupScreen.routeName: (ctx) => const SignupScreen(),
            SignupPersonalInfoScreen.routeName: (ctx) =>
                const SignupPersonalInfoScreen(),
            SignupProfileScreen.routeName: (ctx) => const SignupProfileScreen(),
            SignupLocationScreen.routeName: (ctx) =>
                const SignupLocationScreen(),
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            Tabs.routeName: (ctx) => const Tabs(),
            NewPostScreen.routeName: (ctx) => const NewPostScreen(),
          },
        ),
      ),
    );
  }
}
