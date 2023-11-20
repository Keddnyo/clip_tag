import '../../data/model/template_model.dart';

class Template {
  final String content;
  final DateTime createdAt;

  Template({
    required this.content,
    required this.createdAt,
  });

  factory Template.fromModel(TemplateModel model) => Template(
        content: model.content,
        createdAt: model.createdAt.toDate(),
      );
}
