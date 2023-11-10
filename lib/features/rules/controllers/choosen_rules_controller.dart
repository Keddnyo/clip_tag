import 'package:flutter/material.dart';

class ChoosenRulesController with ChangeNotifier {
  final List _choosenRules = [];

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

class ChoosenRulesProvider extends InheritedNotifier {
  const ChoosenRulesProvider(
      {super.key, required this.controller, required super.child});

  final ChoosenRulesController controller;

  static ChoosenRulesController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ChoosenRulesProvider>()!
      .controller;
}
