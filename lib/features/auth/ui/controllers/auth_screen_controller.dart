import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/auth_state.dart';

class AuthScreenController with ChangeNotifier {
  AuthState _authState = AuthState.signIn;

  bool get isSignIn => _authState == AuthState.signIn;
  void setSignIn() {
    _authState = AuthState.signIn;
    notifyListeners();
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async =>
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

  bool get isSignUp => _authState == AuthState.signUp;
  void setSignUp() {
    _authState = AuthState.signUp;
    notifyListeners();
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async =>
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) =>
              userCredential.user?.updateDisplayName(username));

  bool get isResetPassword => _authState == AuthState.resetPassword;
  void setResetPassword() {
    _authState = AuthState.resetPassword;
    notifyListeners();
  }

  Future<void> resetPassword({required String email}) async =>
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
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
