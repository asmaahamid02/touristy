import 'package:flutter/material.dart';
import 'package:touristy_frontend/widgets/logo.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const routeName = '/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar();
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LogoHorizontal('assets/images/logo_horizontal.png', 100),
            Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'First name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    autofocus: true,
                    onSubmitted: ((value) => {}),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Last name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onSubmitted: ((value) => {}),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    onSubmitted: ((value) => {}),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.remove_red_eye_outlined)),
                    ),
                    onSubmitted: ((value) => {}),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).pushReplacementNamed(
                  //   HomeScreen.routeName,
                  // );
                },
                child: const Text('NEXT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
