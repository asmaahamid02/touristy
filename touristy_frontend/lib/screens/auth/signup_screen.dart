import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../../screens/screens.dart';

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

  final _user = <String, Object>{};

  @override
  void dispose() {
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    FocusScope.of(context).unfocus();

    if (!mounted) return;
    Navigator.of(context)
        .pushNamed(SignupPersonalInfoScreen.routeName, arguments: _user);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final appBar = AppBar();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor:
            brightness == Brightness.light ? Theme.of(context).cardColor : null,
        appBar: appBar,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LogoHorizontal(
                        brightness == Brightness.light
                            ? 'assets/images/logo_horizontal.png'
                            : 'assets/images/login_dark.png',
                        100),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 50, left: 20, right: 20),
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            _buildNameTextField(
                              autoFocus: true,
                              context: context,
                              label: 'First name',
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_lastNameFocusNode);
                              },
                              icon: Icons.person_outline,
                              onSaved: (value) =>
                                  _user['first_name'] = value as String,
                            ),
                            const SizedBox(height: 10),
                            _buildNameTextField(
                              context: context,
                              label: 'Last name',
                              focusNode: _lastNameFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode);
                              },
                              icon: Icons.person_outline,
                              onSaved: (value) =>
                                  _user['last_name'] = value as String,
                            ),
                            const SizedBox(height: 10),
                            _buildEmailField(context),
                            const SizedBox(height: 10),
                            _buildPasswordField(
                              context: context,
                              isPassword: true,
                              label: 'Password',
                              obscureText: _passwordObscureText,
                              focusNode: _passwordFocusNode,
                              onSaved: (value) =>
                                  _user['password'] = value as String,
                            ),
                            const SizedBox(height: 10),
                            _buildPasswordField(
                              context: context,
                              isPassword: false,
                              label: 'Confirm password',
                              obscureText: _confirmPasswordObscureText,
                              focusNode: _confirmPasswordFocusNode,
                              onSaved: (value) =>
                                  _user['confirm_password'] = value as String,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PrimaryButton(
              onTap: _saveForm,
              textLabel: 'NEXT',
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildPasswordField({
    required BuildContext context,
    required String label,
    required bool obscureText,
    required bool isPassword,
    FocusNode? focusNode,
    Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isPassword
                    ? _passwordObscureText = !_passwordObscureText
                    : _confirmPasswordObscureText =
                        !_confirmPasswordObscureText;
              });
            },
            icon: Icon(obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined)),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }

        if (isPassword) {
          _password = value;
        }

        if (!isPassword && value != _password) {
          return 'Passwords do not match';
        }

        return null;
      },
      focusNode: focusNode,
      textInputAction:
          !isPassword ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: isPassword
          ? (_) {
              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
            }
          : (_) {
              _saveForm();
            },
      onSaved: onSaved,
    );
  }

  TextFormField _buildEmailField(BuildContext context) {
    return TextFormField(
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
            RegExp(emailPattern, caseSensitive: false).hasMatch(value);
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
      onSaved: (((newValue) => _user['email'] = newValue as String)),
    );
  }

  TextFormField _buildNameTextField({
    required BuildContext context,
    required String label,
    required IconData icon,
    FocusNode? focusNode,
    required Function(String?) onFieldSubmitted,
    required Function(String?) onSaved,
    bool autoFocus = false,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      autofocus: autoFocus,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your ${label.toLowerCase()}';
        }
        return null;
      },
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
    );
  }
}
