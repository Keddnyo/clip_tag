import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/auth/model/clip_tag_user.dart';

class FirebaseFirestoreController with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  FirebaseFirestoreController() {
    _firestore.collection('users').get().then(
      (query) {
        for (final doc in query.docs) {
          final user = ClipTagUser.fromJson(doc.data());

          if (user.email == FirebaseAuth.instance.currentUser?.email) {
            setClipTagUser(user);
            return;
          }
        }
      },
    );
  }

  ClipTagUser? _currentClipTagUser;
  setClipTagUser(ClipTagUser? user) {
    _currentClipTagUser = user;
    notifyListeners();
  }

  bool get isClipTagUserModerator => _currentClipTagUser?.isModerator == true;
}

class FirebaseFirestoreProvider extends InheritedNotifier {
  const FirebaseFirestoreProvider({
    super.key,
    required this.controller,
    required super.child,
  }) : super(
          notifier: controller,
        );

  final FirebaseFirestoreController controller;

  static FirebaseFirestoreController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<FirebaseFirestoreProvider>()!
      .controller;
}
