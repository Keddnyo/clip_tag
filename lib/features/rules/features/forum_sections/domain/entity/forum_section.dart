import '../../data/model/forum_section_model.dart';
import 'rules_category.dart';

class ForumSection {
  final String title;
  final String rulesUrl;
  final num order;
  final List<RulesCategory> categories;

  ForumSection({
    required this.title,
    required this.rulesUrl,
    required this.order,
    required this.categories,
  });

  factory ForumSection.fromModel(ForumSectionModel model) => ForumSection(
        title: model.title,
        rulesUrl: model.rulesUrl,
        order: model.order,
        categories: List.from(
          model.categories.map(
            (categoryModel) => RulesCategory.fromModel(categoryModel),
          ),
        ),
      );

  String combineChoosenRulesToString(List<String> choosenRules) {
    final buffer = StringBuffer();

    buffer.write('[b]Ознакомьтесь с [url="$rulesUrl"]');
    if (order == 0) {
      buffer.write('Правилами ресурса');
    } else {
      buffer.write('Правилами раздела $title');
    }
    buffer.write('[/url]![/b]\n');

    for (final category in categories) {
      for (final rule in category.rules) {
        if (choosenRules.contains(rule)) {
          buffer.write('$rule\n');
        }
      }
    }

    return buffer.toString().trim();
  }
}
