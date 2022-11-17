import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './utilities/utilities.dart';
import './screens/screens.dart';
import './providers/providers.dart';

void main() async {
  //portrait mode only
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp(
      appTheme: AppTheme(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appTheme});

  final AppTheme appTheme;
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
        ),
        ChangeNotifierProxyProvider<Auth, Comments>(
          create: (_) => Comments(),
          update: (_, auth, previousComments) =>
              previousComments!..update(auth),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Touristy',
          theme: appTheme.light,
          darkTheme: appTheme.dark,
          themeMode: ThemeMode.dark,
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
            MessagingScreen.routeName: (ctx) => const MessagingScreen(),
            ChatScreen.routeName: (ctx) => const ChatScreen(),
            MapPage.routeName: (ctx) => const MapPage(),
            CommentsScreen.routeName: (ctx) => const CommentsScreen(),
          },
        ),
      ),
    );
  }
}
