import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../utils/show_snackbar.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const String route = '/login';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  bool _isSignUp = false;
  bool _isResetPassword = false;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String get username => usernameController.text;
  String get email => emailController.text;
  String get password => passwordController.text;

  void _switchSignUp() {
    setState(() => _isSignUp = !_isSignUp);
  }

  void _switchResetPassword() {
    setState(() => _isResetPassword = !_isResetPassword);
  }

  void _signIn() =>
      auth.signInWithEmailAndPassword(email: email, password: password).then(
        (_) {
          showSnackbar(
              context: context,
              message: 'Welcome back, ${auth.currentUser!.displayName}');
        },
      ).catchError((error) {
        showSnackbar(context: context, message: error);
      });

  void _signUp() => auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (_) {
          showSnackbar(
              context: context, message: 'Please confirm your email address!');
        },
      ).catchError((error) {
        showSnackbar(context: context, message: error);
      });

  void _resetPassword() => auth.sendPasswordResetEmail(email: email).then(
        (_) {
          _switchResetPassword();
        },
      ).catchError((error) {
        showSnackbar(context: context, message: error);
      });

  void _submit() {
    if (formKey.currentState?.validate() == false) return;

    if (_isResetPassword) {
      _resetPassword();
      return;
    }
    if (_isSignUp) {
      _signUp();
      return;
    }
    _signIn();
  }

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const margin = 12.0;
    const contentPadding =
        EdgeInsets.only(left: margin, right: margin, bottom: margin);

    final submitButtonTitle = _isResetPassword
        ? 'Reset password'
        : _isSignUp
            ? 'Sign Up'
            : 'Sign In';

    final resetPasswordButtonTitle =
        _isResetPassword ? 'Sign In' : 'Reset password';

    final signUpButtonTitle = _isSignUp ? 'Sign In' : 'Sign Up';

    return Scaffold(
      appBar: AppBar(
        title: const Text('${Constants.appName} ID'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_isSignUp)
                Padding(
                  padding: contentPadding,
                  child: TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      label: Text('Username'),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (username) {
                      if (username?.isEmpty == true) {
                        return 'You need a username';
                      }
                      return null;
                    },
                  ),
                ),
              Padding(
                padding: contentPadding,
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email?.isEmpty == true) {
                      return 'You need a email address';
                    }
                    return null;
                  },
                ),
              ),
              if (!_isResetPassword)
                Padding(
                  padding: contentPadding,
                  child: TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    // TODO: obscureText: true,
                    validator: (password) {
                      if (password?.isEmpty == true) {
                        return 'You need a password';
                      }
                      return null;
                    },
                  ),
                ),
              if (_isSignUp)
                Padding(
                  padding: contentPadding,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Confirm password'),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    // TODO: obscureText: true,
                    validator: (confirmPassword) {
                      if (confirmPassword?.isEmpty == true) {
                        return 'You need to confirm your password';
                      }
                      if (confirmPassword != password) {
                        return 'Password mismatch';
                      }
                      return null;
                    },
                  ),
                ),
              Padding(
                padding: contentPadding,
                child: FilledButton(
                  onPressed: _submit,
                  child: Text(submitButtonTitle),
                ),
              ),
              if (!_isSignUp)
                Padding(
                  padding: contentPadding,
                  child: OutlinedButton(
                    onPressed: _switchResetPassword,
                    child: Text(resetPasswordButtonTitle),
                  ),
                ),
              if (!_isResetPassword)
                Padding(
                  padding: contentPadding,
                  child: OutlinedButton(
                    onPressed: _switchSignUp,
                    child: Text(signUpButtonTitle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
