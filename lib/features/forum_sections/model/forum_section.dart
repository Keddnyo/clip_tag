import '../../rules/model/rules_category.dart';

class ForumSection {
  final String title;
  final String rulesUrl;
  final num order;
  final Iterable categories;
  final DateTime? edition;

  ForumSection({
    required this.title,
    required this.rulesUrl,
    required this.order,
    required this.categories,
    this.edition,
  });

  String? get editionDateAsString => edition != null
      ? '${edition!.day}.${edition!.month}.${edition!.year}'
      : null;

  static ForumSection decode(Map<String, dynamic> map) {
    final categories = map['categories'].map(
      (category) => RulesCategory.decode(category),
    );

    return ForumSection(
      title: map['title'],
      rulesUrl: map['rulesUrl'],
      order: map['order'],
      categories: categories,
      edition: map['edition']?.toDate(), // TODO: Potentially wrong
    );
  }
}
