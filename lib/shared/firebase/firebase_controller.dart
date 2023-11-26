import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class FirebaseController with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firebase = FirebaseFirestore.instance;

  FirebaseController() {
    _auth.setLanguageCode('ru');

    userChanges.listen(
      (user) {
        if (user != null) {
          _userData?.snapshots().listen((user) {
            final userData = user.data();
            _setTagVisibility(userData?[Constants.isTagVisibleKey]);
            _setUserModerator(userData?[Constants.isUserModeratorKey]);
            _setFavorites(userData?['favorites']);
          });
        }
      },
    );
  }

  User? get _user => _auth.currentUser;
  bool get isUserAnonymous => _user?.isAnonymous == true;
  String? get _userID => _user?.uid;
  String? get username => _user?.displayName;
  Stream<User?> get userChanges => _auth.userChanges();
  Future<void> userReload() async => await _user?.reload();

  String? get userEmail => _user?.email;
  bool get isEmailVerified => _user?.emailVerified == true;

  Future<void> signInAnonymously() async => await _auth.signInAnonymously();

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
                    Constants.isUserModeratorKey: false,
                    'email': email,
                    'username': username,
                    'createdAt': DateTime.now(),
                  })));

  void sendEmailVerification() => _user?.sendEmailVerification();

  void signOut() => isUserAnonymous
      ? _user?.delete()
      : _auth.signOut().then((_) {
          if (_isUserModerator == true) {
            _setTagVisibility(); // Reset to default value (true)
            _setUserModerator(); // Reset to default value (false)
          }
        });

  Future<void> resetPassword({required String email}) async =>
      await _auth.sendPasswordResetEmail(email: email);

  Stream<QuerySnapshot<Map<String, dynamic>>> get ruleSections =>
      _firebase.collection('rules').orderBy('order').snapshots();

  DocumentReference<Map<String, dynamic>>? get _userData =>
      _firebase.collection('users').doc(_userID);

  final List<String> _favorites = [];
  List<String> get favorites => _favorites;
  void _setFavorites([List<dynamic>? favorites]) {
    if (_favorites.isNotEmpty) {
      _favorites.clear();
    }
    _favorites.addAll(List.from(favorites ?? []));
  }

  Future<void> _updateFavorites(List<String> favorites) async =>
      await _userData?.update({'favorites': favorites});

  Future<void> addToFavorites(String favorite) async {
    final newFavorites = favorites;
    newFavorites.add(favorite);
    await _updateFavorites(newFavorites);
  }

  Future<void> removeFromFavorites(int index) async {
    final newFavorites = favorites;
    newFavorites.removeAt(index);
    await _updateFavorites(newFavorites);
  }

  Future<void> reorderFavorite({
    required int oldIndex,
    required int newIndex,
  }) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final newFavorites = favorites;
    final favorite = newFavorites.removeAt(oldIndex);
    newFavorites.insert(newIndex, favorite);
    await _updateFavorites(newFavorites);
  }

  bool _isTagVisible = true;
  bool get isTagVisible => _isTagVisible;
  void _setTagVisibility([bool? isTagVisible]) {
    _isTagVisible = isTagVisible ?? true;
    notifyListeners();
  }

  void switchTagVisibility() async {
    _setTagVisibility(!_isTagVisible);
    // Set cloud value after setting local value for stable offline working
    await _userData?.update({Constants.isTagVisibleKey: _isTagVisible});
  }

  bool _isUserModerator = false;
  bool get isUserModerator => _isUserModerator;
  void _setUserModerator([bool? isModerator]) {
    _isUserModerator = isModerator ?? false;
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
