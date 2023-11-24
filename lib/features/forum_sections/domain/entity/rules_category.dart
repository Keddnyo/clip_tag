import '../../data/model/rules_category_model.dart';

class RulesCategory {
  final String title;
  final List<String> rules;

  RulesCategory({required this.title, required this.rules});

  factory RulesCategory.fromModel(RulesCategoryModel model) => RulesCategory(
        title: model.categoryName,
        rules: List.from(
          model.rules.map((rule) => rule.replaceAll('\\n', '\n')),
        ),
      );
}
