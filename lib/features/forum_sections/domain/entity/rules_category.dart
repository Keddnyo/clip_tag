import 'package:clip_tag/features/forum_sections/data/model/rules_category_model.dart';

class RulesCategory {
  final String title;
  final List<String> rules;

  RulesCategory({required this.title, required this.rules});

  factory RulesCategory.fromModel(RulesCategoryModel model) =>
      RulesCategory(title: model.categoryName, rules: List.from(model.rules));
}
