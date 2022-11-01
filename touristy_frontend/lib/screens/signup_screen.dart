import 'package:flutter/material.dart';

import '../widgets/logo.dart';
import '../screens/signup_pesronal_info.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const routeName = '/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;
  String _password = '';
  String _confirmPassword = '';

  var _user = <String, Object>{};

  @override
  void dispose() {
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    Navigator.of(context)
        .pushNamed(SignupPersonalInfo.routeName, arguments: _user);
  }

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
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'First name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      autofocus: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_lastNameFocusNode);
                      },
                      onSaved: ((newValue) =>
                          _user['first_name'] = newValue as String),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Last name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      focusNode: _lastNameFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      onSaved: ((newValue) =>
                          _user['last_name'] = newValue as String),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _emailFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        const emailPattern =
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
                        final result =
                            RegExp(emailPattern, caseSensitive: false)
                                .hasMatch(value);
                        //check if email is valid
                        if (!result) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      onSaved: (((newValue) =>
                          _user['email'] = newValue as String)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordObscureText = !_passwordObscureText;
                              });
                            },
                            icon: Icon(_passwordObscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined)),
                      ),
                      obscureText: _passwordObscureText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        _password = value;
                        return null;
                      },
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_confirmPasswordFocusNode);
                      },
                      onSaved: ((newValue) =>
                          _user['password'] = newValue as String),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _confirmPasswordObscureText =
                                  !_confirmPasswordObscureText;
                            });
                          },
                          icon: Icon(_confirmPasswordObscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                      ),
                      obscureText: _confirmPasswordObscureText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      focusNode: _confirmPasswordFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                onPressed: _saveForm,
                child: const Text('NEXT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
