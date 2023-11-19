import '../../data/model/template_model.dart';

class Template {
  final String content;
  final DateTime createdAt;

  Template({
    required this.content,
    required this.createdAt,
  });

  factory Template.fromModel(TemplateModel model) => Template(
        content: model.template,
        createdAt: model.createdAt.toDate(),
      );

  String get date =>
      '${createdAt.day.toString().padLeft(2, '0')}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.year} - ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
}
