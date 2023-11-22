part of '../forum_sections_screen.dart';

class ForumSectionsController with ChangeNotifier {
  ForumSectionsController() {
    FirebaseController().rulesSnaphots.listen(
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

  String mergeChoosenRules({String? rule}) => section!
      .combineChoosenRulesToString(rule != null ? [rule] : _choosenRules);

  Future<void> copyChoosenRules() async =>
      await copyToClipboard(mergeChoosenRules());

  void navigateToCheckout(BuildContext context, {String? rule}) =>
      Navigator.pushNamed(
        context,
        CheckoutScreen.route,
        arguments: mergeChoosenRules(rule: rule),
      );
}
