import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '../../providers/providers.dart';
import '../../exceptions/http_exception.dart';
import '../../utilities/utilities.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  bool _passwordObscureText = true;

  final _user = <String, Object>{};
  var _isLoading = false;

  void _showErrorDialog(String message) {
    AlertDialogCommon.show(
        context: context,
        title: 'An error occurred!',
        content: message,
        actionText: 'Ok',
        includeCancel: false,
        action: null);
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).login(
          _user['email'].toString().trim(),
          _user['password'].toString().trim());

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacementNamed('/');
    } on HttpException catch (error) {
      final errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Incorrect email or password.';
      _showErrorDialog(errorMessage);
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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
                  mainAxisSize: MainAxisSize.min,
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                return FormUtility.validatePassword(value!);
                              },
                              onSaved: (value) =>
                                  _user['password'] = value as String,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Container(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : PrimaryButton(
                      textLabel: 'Login',
                      onTap: _saveForm,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
