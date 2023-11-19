import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseFirestoreController with ChangeNotifier {
  FirebaseFirestoreController() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) => snapshot.data()?['isModerator'] == true);
  }

  bool _isModerator = false;
  bool get isModerator => _isModerator;
  setModerator(bool isModerator) {
    _isModerator = isModerator;
    notifyListeners();
  }
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
