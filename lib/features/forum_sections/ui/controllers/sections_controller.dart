import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../checkout/ui/checkout_screen.dart';
import '../../data/model/forum_section_model.dart';
import '../../domain/entity/forum_section.dart';

class ForumSectionsController with ChangeNotifier {
  final BuildContext context;

  ForumSectionsController({required this.context}) {
    FirebaseFirestore.instance
        .collection('rules')
        .orderBy('order')
        .snapshots()
        .listen(
          (query) => _setSections(
            query.docs.map(
              (query) => ForumSection.fromModel(
                ForumSectionModel.fromMap(query.data()),
              ),
            ),
          ),
        );
  }

  final _sections = <ForumSection>[];
  void _setSections(Iterable<ForumSection> sections) {
    if (_sections.isNotEmpty) {
      _sections.clear();
    }
    _sections.addAll(sections);
    notifyListeners();
  }

  List<ForumSection> get sections => _sections;
  ForumSection? get section => _sections[_sectionIndex];

  int _sectionIndex = 0;
  int get sectionIndex => _sectionIndex;
  void setSectionIndex(int index) {
    _sectionIndex = index;
    notifyListeners();
  }

  final _choosenRules = <String>[];
  List<String> get choosenRules => _choosenRules;

  void addRule(rule) {
    _choosenRules.add(rule);
    notifyListeners();
  }

  void removeRule(rule) {
    _choosenRules.remove(rule);
    notifyListeners();
  }

  void clearChoosenRules() {
    _choosenRules.clear();
    notifyListeners();
  }

  String get choosenRulesCombined =>
      section!.combineChoosenRulesToString(_choosenRules);

  void navigateToCheckout([String? rule]) => Navigator.pushNamed(
        context,
        CheckoutScreen.route,
        arguments: rule ?? choosenRulesCombined,
      );
}
