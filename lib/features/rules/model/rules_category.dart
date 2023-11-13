class RulesCategory {
  final String categoryName;
  final Iterable rules;

  RulesCategory({required this.categoryName, required this.rules});

  static RulesCategory decode(Map<String, dynamic> map) => RulesCategory(
        categoryName: map['categoryName'],
        rules: map['rules'].map(
          (rule) => rule.replaceAll('\\n', '\n'),
        ),
      );
}
