import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../shared/firebase/firebase_auth_decode_error_code.dart';
import '../../../shared/firebase/firebase_auth_error_codes.dart';
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

  String get username => usernameController.text.trim();
  String get email => emailController.text.trim();
  String get password => passwordController.text;

  void _switchSignUp() {
    setState(() => _isSignUp = !_isSignUp);
  }

  void _switchResetPassword() {
    setState(() => _isResetPassword = !_isResetPassword);
  }

  void _signIn() => auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((_) => showSnackbar(
              context: context,
              message: 'Добро пожаловать, ${auth.currentUser!.displayName}'))
          .catchError(
        (error) {
          if (error.code == FirebaseAuthErrorCodes.invalidCredentials) {
            passwordController.clear();
          }
          showSnackbar(
            context: context,
            message: decodeFirebaseAuthErrorCode(error.code),
          );
        },
      );

  void _signUp() => auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (_) {
          auth.currentUser?.updateDisplayName(username);
          showSnackbar(
            context: context,
            message: 'Пожалуйста подтвердите свою почту',
          );
        },
      ).catchError((error) {
        if (error.code == FirebaseAuthErrorCodes.emailAlreadyInUse) {
          _switchSignUp();
        }

        showSnackbar(
          context: context,
          message: decodeFirebaseAuthErrorCode(error.code),
        );
      });

  void _resetPassword() => auth
      .sendPasswordResetEmail(email: email)
      .then((_) => _switchResetPassword())
      .catchError((error) => showSnackbar(
          context: context, message: decodeFirebaseAuthErrorCode(error.code)));

  void _submit() {
    if (formKey.currentState?.validate() == false) return;
    if (FirebaseAuth.instance.currentUser != null) return;

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
    const contentPadding = EdgeInsets.all(margin);

    final submitButtonTitle = _isResetPassword
        ? 'Сбросить пароль'
        : _isSignUp
            ? 'Создать аккаунт'
            : 'Войти';

    final resetPasswordButtonTitle =
        _isResetPassword ? 'Вход' : 'Забыли пароль?';

    final signUpButtonTitle = _isSignUp ? 'Вход' : 'Регистрация';

    return Scaffold(
      appBar: AppBar(
        title: const Text('${Constants.appName} ID'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isSignUp)
                Padding(
                  padding: contentPadding,
                  child: TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Имя пользователя',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (username) {
                      if (username?.isEmpty == true) {
                        return 'Введите имя пользователя';
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
                    labelText: 'Почта',
                    hintText: 'example@domain.com',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email?.isEmpty == true) {
                      return 'Введите актуальную почту';
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
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      hintText: _isSignUp ? 'Минимум 6 символов' : null,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (password) {
                      if (password?.isEmpty == true) {
                        return 'Пароль не должен быть пустым';
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
                      labelText: 'Подтвердите пароль',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (confirmPassword) {
                      if (confirmPassword?.isEmpty == true) {
                        return 'Вы должны подтвердить пароль';
                      }
                      if (confirmPassword != password) {
                        return 'Пароли не совпали';
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
