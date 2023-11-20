import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TemplatesController with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Map<String, dynamic>> _templatesCollection;

  TemplatesController() {
    _templatesCollection = _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('templates');

    _templatesCollection.orderBy('createdAt').snapshots().listen(
      (query) {
        _setTemplates(query.docs);
      },
    );
  }

  final _templates = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get templates => _templates;
  void _setTemplates(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> templates,
  ) {
    if (_templates.isNotEmpty) {
      _templates.clear();
    }
    _templates.addAll(templates);
    notifyListeners();
  }
}
