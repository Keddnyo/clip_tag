import 'package:flutter/material.dart';

class RulesController with ChangeNotifier {
  final _choosenRules = [];
  List get choosenRules => _choosenRules;

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
}
