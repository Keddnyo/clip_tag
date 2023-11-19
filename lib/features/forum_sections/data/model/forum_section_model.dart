import 'rules_category_model.dart';

class ForumSectionModel {
  final String title;
  final String rulesUrl;
  final num order;
  final Iterable categories;

  ForumSectionModel({
    required this.title,
    required this.rulesUrl,
    required this.order,
    required this.categories,
  });

  factory ForumSectionModel.fromMap(Map<String, dynamic> json) =>
      ForumSectionModel(
        title: json['title'],
        rulesUrl: json['rulesUrl'],
        order: json['order'],
        categories: json['categories'].map(
          (categoryMap) => RulesCategoryModel.fromMap(categoryMap),
        ),
      );
}
