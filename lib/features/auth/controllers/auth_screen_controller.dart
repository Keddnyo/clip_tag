import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/firebase_controller.dart';
import '../../../utils/show_snackbar.dart';

class AuthScreenController with ChangeNotifier {
  final FirebaseController firebaseController;

  AuthScreenController(this.firebaseController);

  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  String get username => usernameController.text.trim();

  final emailController = TextEditingController();
  String get email => emailController.text.trim();

  final passwordController = TextEditingController();
  String get password => passwordController.text;

  final confirmPasswordController = TextEditingController();

  bool _isSignUp = false;
  bool get isSignUp => _isSignUp;
  void switchSignUp() {
    _isSignUp = !_isSignUp;
    notifyListeners();
  }

  bool _isPasswordReset = false;
  bool get isPasswordReset => _isPasswordReset;
  void switchPasswordReset() {
    _isPasswordReset = !_isPasswordReset;
    notifyListeners();
  }

  bool get isSignIn => !_isSignUp || !_isPasswordReset;
  void switchToSignIn() {
    if (_isSignUp) {
      switchSignUp();
    }
    if (_isPasswordReset) {
      switchPasswordReset();
    }
  }

  IconData get submitButtonIcon => _isSignUp
      ? Icons.person_add
      : _isPasswordReset
          ? Icons.password
          : Icons.login;

  String get submitButtonTitle => _isSignUp
      ? 'Создать аккаунт'
      : _isPasswordReset
          ? 'Сбросить пароль'
          : 'Войти';

  IconData get resetPasswordButtonIcon =>
      _isPasswordReset ? Icons.login : Icons.password;

  String get resetPasswordButtonTitle =>
      _isPasswordReset ? 'Вход' : 'Забыли пароль?';

  IconData get signUpButtonIcon => _isSignUp ? Icons.login : Icons.person_add;

  String get signUpButtonTitle => _isSignUp ? 'Вход' : 'Создать аккаунт';

  void submitAuth({required BuildContext context}) {
    if (formKey.currentState?.validate() == false) return;
    if (firebaseController.isSignedIn) return;

    if (_isSignUp) {
      firebaseController.signUp(email: email, password: password).then(
        (userCredential) {
          userCredential.user?.updateDisplayName(username).then(
                (_) => showSnackbar(
                  context: context,
                  message:
                      '${FirebaseAuth.instance.currentUser?.displayName}, всё почти готово',
                ),
              );
        },
      ).catchError(
        (error) {
          showSnackbar(
            context: context,
            message: error.toString(),
          );
        },
      );
      return;
    }

    if (_isPasswordReset) {
      firebaseController.resetPassword(email).then(
        (_) {
          showSnackbar(
            context: context,
            message: 'Ссылка для сброса отправлена на почту',
          );
        },
      ).catchError(
        (error) {
          showSnackbar(
            context: context,
            message: error.toString(),
          );
        },
      );
      return;
    }

    firebaseController.signIn(email: email, password: password).then(
      (userCredential) {
        showSnackbar(
          context: context,
          message: 'Добро пожаловать, ${userCredential.user?.displayName}',
        );
      },
    ).catchError(
      (error) {
        showSnackbar(
          context: context,
          message: error.toString(),
        );
      },
    );
  }
}
