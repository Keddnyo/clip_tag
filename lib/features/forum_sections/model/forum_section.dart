import '../../rules/model/rules_category.dart';

class ForumSection {
  final String title;
  final String rulesUrl;
  final num order;
  final Iterable categories;

  ForumSection({
    required this.title,
    required this.rulesUrl,
    required this.order,
    required this.categories,
  });

  String combineChoosenRulesToString(List choosenRules) {
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

  static ForumSection decode(Map<String, dynamic> map) => ForumSection(
        title: map['title'],
        rulesUrl: map['rulesUrl'],
        order: map['order'],
        categories: map['categories'].map(
          (category) => RulesCategory.decode(category),
        ),
      );
}
