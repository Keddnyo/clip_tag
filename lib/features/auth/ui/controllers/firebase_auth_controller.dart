import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/clip_tag_user.dart';

class FirebaseAuthController with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? get _currentAuthUser => _auth.currentUser;
  bool get isSignedIn => _currentAuthUser != null;
  String? get authEmail => _currentAuthUser?.email;
  bool get isEmailVerified => _currentAuthUser?.emailVerified == true;
  String? get username => _currentAuthUser?.displayName;

  FirebaseAuthController() {
    _auth.setLanguageCode('ru');

    while (isSignedIn && !isEmailVerified) {
      Timer.periodic(
        const Duration(seconds: 5),
        (timer) {
          _currentAuthUser?.reload().then(
            (_) {
              if (isEmailVerified) {
                timer.cancel();
              }
            },
          );
        },
      );
    }

    _firestore.collection('users').get().then(
      (query) {
        for (final doc in query.docs) {
          final user = ClipTagUser.fromJson(doc.data());

          if (user.email == authEmail) {
            setClipTagUser(user);
            return;
          }
        }
      },
    );
  }

  Stream<User?> get userChanges => _auth.userChanges();

  ClipTagUser? _currentClipTagUser;
  setClipTagUser(ClipTagUser? user) {
    _currentClipTagUser = user;
    notifyListeners();
  }

  bool get isClipTagUserModerator => _currentClipTagUser?.isModerator == true;

  Future<UserCredential> signIn(
          {required String email, required String password}) async =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signUp(
          {required String email, required String password}) async =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<void> resetPassword(String email) async =>
      _auth.sendPasswordResetEmail(email: email);

  void signOut() => _auth.signOut();
}

class FirebaseProvider extends InheritedNotifier {
  const FirebaseProvider({
    super.key,
    required this.controller,
    required super.child,
  }) : super(
          notifier: controller,
        );

  final FirebaseAuthController controller;

  static FirebaseAuthController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<FirebaseProvider>()!
      .controller;
}
