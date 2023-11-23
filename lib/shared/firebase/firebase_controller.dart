import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../features/favorites/data/model/favorite_model.dart';

class FirebaseController with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  FirebaseController() {
    _auth.setLanguageCode('ru');

    _userData?.snapshots().listen(
        (user) => setUserModerator(user.data()?['isModerator'] ?? false));
  }

  User? get _user => _auth.currentUser;
  // bool get isUserAnonymous => _user?.isAnonymous == true;
  String? get _userID => _user?.uid;
  String? get username => _user?.displayName;
  Stream<User?> get userChanges => _auth.userChanges();
  Future<void> userReload() async => await _user?.reload();

  String? get userEmail => _user?.email;
  bool get isEmailVerified => _user?.emailVerified == true;

  // void signInAnonymously() => _auth.signInAnonymously();

  Future<void> signIn({
    required String email,
    required String password,
  }) async =>
      await _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async =>
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) => userCredential.user
              ?.updateDisplayName(username)
              .then((_) => _userData?.set({
                    'username': username,
                    'email': email,
                    'isModerator': false,
                  })));

  void sendEmailVerification() => _user?.sendEmailVerification();

  // void signOut() => isUserAnonymous ? _user?.delete() : _auth.signOut();
  void signOut() => _auth.signOut();

  Future<void> resetPassword({required String email}) async =>
      await _auth.sendPasswordResetEmail(email: email);

  Stream<QuerySnapshot<Map<String, dynamic>>> get rules =>
      _db.collection('rules').orderBy('order').snapshots();

  DocumentReference<Map<String, dynamic>>? get _userData =>
      _db.collection('users').doc(_userID);

  CollectionReference<Map<String, dynamic>>? get _favorites =>
      _userData?.collection('favorites');

  Stream<QuerySnapshot<Map<String, dynamic>>>? get favorites =>
      _favorites?.orderBy('createdAt').snapshots();

  Future<void> addFavorite(String favorite) async => await _favorites?.add(
        FavoriteModel.toMap(content: favorite, createdAt: DateTime.now()),
      );

  bool _isUserModerator = false;
  bool get isUserModerator => _isUserModerator;
  void setUserModerator(bool isModerator) {
    _isUserModerator = isModerator;
    notifyListeners();
  }
}

class FirebaseProvider extends InheritedNotifier {
  const FirebaseProvider({
    super.key,
    required this.controller,
    required super.child,
  }) : super(
          notifier: controller,
        );

  final FirebaseController controller;

  static FirebaseController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<FirebaseProvider>()!
      .controller;
}
