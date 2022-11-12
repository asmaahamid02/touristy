import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '../../providers/providers.dart';
import '../../exceptions/http_exception.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String _token = 'token';

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  bool _passwordObscureText = true;

  final _user = <String, Object>{};
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred!',
            style: Theme.of(context).textTheme.headline5),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            style: Theme.of(context).textButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).errorColor,
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                ),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
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
    final appBar = AppBar();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LogoHorizontal('assets/images/logo_horizontal.png', 100),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
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
              _isLoading
                  ? const CircularProgressIndicator()
                  : PrimaryButton(
                      textLabel: 'Login',
                      onTap: _saveForm,
                    ),
            ]),
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
