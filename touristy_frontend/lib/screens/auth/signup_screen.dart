import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../../screens/screens.dart';
import '../../utilities/utilities.dart';

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
    FocusScope.of(context).unfocus();
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
                            FormUtility.buildTextField(
                              label: 'First name',
                              autoFocus: true,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: (value) => FormUtility.validateName(
                                  value!, 'first name'),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_lastNameFocusNode);
                              },
                              onSaved: (value) =>
                                  _user['first_name'] = value as String,
                            ),
                            const SizedBox(height: 10),
                            FormUtility.buildTextField(
                              label: 'Last name',
                              focusNode: _lastNameFocusNode,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: (value) =>
                                  FormUtility.validateName(value!, 'last name'),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode);
                              },
                              onSaved: (value) =>
                                  _user['last_name'] = value as String,
                            ),
                            const SizedBox(height: 10),
                            FormUtility.buildTextField(
                              label: 'Email',
                              prefixIcon: const Icon(Icons.email_outlined),
                              keyboardType: TextInputType.emailAddress,
                              focusNode: _emailFocusNode,
                              validator: (value) =>
                                  FormUtility.validateEmail(value!),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                              onSaved: (((newValue) =>
                                  _user['email'] = newValue as String)),
                            ),
                            const SizedBox(height: 10),
                            FormUtility.buildTextField(
                              label: 'Password',
                              obscureText: _passwordObscureText,
                              focusNode: _passwordFocusNode,
                              prefixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordObscureText =
                                        !_passwordObscureText;
                                  });
                                },
                                icon: Icon(_passwordObscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                _password = value!;

                                return FormUtility.validatePassword(value);
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_confirmPasswordFocusNode);
                              },
                              onSaved: (value) =>
                                  _user['password'] = value as String,
                            ),
                            const SizedBox(height: 10),
                            FormUtility.buildTextField(
                              label: 'Confirm password',
                              obscureText: _confirmPasswordObscureText,
                              focusNode: _confirmPasswordFocusNode,
                              textInputAction: TextInputAction.done,
                              prefixIcon: IconButton(
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
                              validator: (value) =>
                                  FormUtility.validateConfirmPassword(
                                      value!, _password),
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
}
