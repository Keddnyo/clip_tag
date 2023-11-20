import 'package:flutter/material.dart';

import '../../model/auth_state.dart';

class AuthScreenController with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String get username => usernameController.text.trim();
  String get email => emailController.text.trim();
  String get password => passwordController.text;

  AuthState _authState = AuthState.signIn;

  bool get isSignIn => _authState == AuthState.signIn;
  void setSignIn() {
    _authState = AuthState.signIn;
    notifyListeners();
  }

  bool get isSignUp => _authState == AuthState.signUp;
  void setSignUp() {
    _authState = AuthState.signUp;
    notifyListeners();
  }

  bool get isResetPassword => _authState == AuthState.resetPassword;
  void setResetPassword() {
    _authState = AuthState.resetPassword;
    notifyListeners();
  }
}

class AuthScreenProvider extends InheritedNotifier {
  const AuthScreenProvider({
    super.key,
    required this.controller,
    required super.child,
  }) : super(
          notifier: controller,
        );

  final AuthScreenController controller;

  static AuthScreenController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AuthScreenProvider>()!
      .controller;
}
