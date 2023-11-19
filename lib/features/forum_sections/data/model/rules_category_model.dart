class RulesCategoryModel {
  final String categoryName;
  final Iterable rules;

  RulesCategoryModel({required this.categoryName, required this.rules});

  factory RulesCategoryModel.fromMap(Map<String, dynamic> json) =>
      RulesCategoryModel(
        categoryName: json['categoryName'],
        rules: json['rules'],
      );
}
