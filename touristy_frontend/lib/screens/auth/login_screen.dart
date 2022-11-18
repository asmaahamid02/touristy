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
        action: () {
          Navigator.of(context).pop();
        });
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
      const errorMessage = 'Authentication failed';
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
                            _buildEmailTextField(),
                            const SizedBox(height: 10),
                            _buildPasswordTextField(),
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

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      autofocus: true,
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

  Widget _buildPasswordTextField() {
    return TextFormField(
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
        return null;
      },
      focusNode: _passwordFocusNode,
      onFieldSubmitted: (_) {
        _saveForm();
      },
      onSaved: ((newValue) => _user['password'] = newValue as String),
    );
  }
}
