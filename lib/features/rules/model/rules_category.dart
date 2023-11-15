class RulesCategory {
  final String categoryName;
  final Iterable rules;

  RulesCategory({required this.categoryName, required this.rules});

  factory RulesCategory.fromJson(Map<String, dynamic> json) => RulesCategory(
        categoryName: json['categoryName'],
        rules: json['rules'].map(
          (rule) => rule.replaceAll('\\n', '\n'),
        ),
      );
}
