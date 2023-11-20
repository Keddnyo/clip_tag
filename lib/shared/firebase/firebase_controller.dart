import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../features/favorites/data/model/favorite_model.dart';

class FirebaseController with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  FirebaseController() {
    _auth
      ..setLanguageCode('ru')
      ..userChanges().listen(
        (user) {
          if (!isUserSignedIn) {
            _setUserModerator(false);
            _setUserFavorites([]);
            _setFavoritesReference(null);
          }

          if (isEmailVerified) {
            _setUserData(_firestore.collection('users').doc(_userID));
            _userData!.snapshots().listen(
                  (map) => _setUserModerator(map['isModerator']),
                );

            _setFavoritesReference(
              _userData!.collection('favorites'),
            );
            _userFavoritesReference!
                .orderBy('createdAt', descending: true)
                .snapshots()
                .listen(
                  (query) => _setUserFavorites(query.docs),
                );
          } else {
            Timer.periodic(
              const Duration(seconds: 5),
              (timer) => user?.reload(),
            );
          }
        },
      );
  }

  User? get _user => _auth.currentUser;
  Stream<User?> get userChanges => _auth.userChanges();
  bool get isUserSignedIn => _user != null;
  String? get _userID => _user?.uid;
  String? get username => _user?.displayName;
  String? get userEmail => _user?.email;

  bool get isEmailVerified => _user?.emailVerified == true;

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
          .then(
            (userCredential) =>
                userCredential.user?.updateDisplayName(username).then(
                      (_) => _firestore.collection('users').doc(_userID).set(
                        {
                          'username': username,
                          'email': email,
                          'isModerator': false,
                        },
                      ),
                    ),
          );

  void sendEmailVerification() => _user?.sendEmailVerification();

  void signOut() => _auth.signOut();

  Future<void> resetPassword({required String email}) async =>
      await _auth.sendPasswordResetEmail(email: email);

  void deleteAccount() => _userFavoritesReference!
      .get()
      .then(
        (query) {
          for (var doc in query.docs) {
            doc.reference.delete();
          }
        },
      )
      .then(
        (_) => _userData?.delete(),
      )
      .then(
        (_) => _user?.delete(),
      );

  DocumentReference<Map<String, dynamic>>? _userData; // Firestore user data
  DocumentReference<Map<String, dynamic>> get userData => _userData!;
  void _setUserData(DocumentReference<Map<String, dynamic>> userData) {
    _userData = userData;
    notifyListeners();
  }

  bool _isUserModerator = false;
  bool get isUserModerator => _isUserModerator;
  void _setUserModerator(bool isModerator) {
    _isUserModerator = isModerator;
    notifyListeners();
  }

  CollectionReference<Map<String, dynamic>>? _userFavoritesReference;
  void _setFavoritesReference(
    CollectionReference<Map<String, dynamic>>? reference,
  ) {
    _userFavoritesReference = reference;
    notifyListeners();
  }

  final _userFavorites = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get userFavorites =>
      _userFavorites;

  void _setUserFavorites(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> templates,
  ) {
    if (_userFavorites.isNotEmpty) {
      _userFavorites.clear();
    }
    _userFavorites.addAll(templates);
    notifyListeners();
  }

  Future<void> addToFavorites(String favorite) async =>
      await _userFavoritesReference?.add(FavoriteModel.toMap(
        content: favorite,
        createdAt: DateTime.now(),
      ));

  Stream<QuerySnapshot<Map<String, dynamic>>> get forumRules =>
      _firestore.collection('rules').orderBy('order').snapshots();
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
