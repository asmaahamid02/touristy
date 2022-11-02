import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/signup_pesronal_info_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/landing_screen.dart';

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
    return MaterialApp(
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
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
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
        iconTheme: IconThemeData(
          size: 24,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              Colors.black,
            ),
          ),
        ),
      ),
      // home: LandingScreen(),
      routes: {
        LandingScreen.routeName: (ctx) => LandingScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SignupScreen.routeName: (ctx) => SignupScreen(),
        SignupPersonalInfoScreen.routeName: (ctx) => SignupPersonalInfoScreen(),
      },
    );
  }
}
