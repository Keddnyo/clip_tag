import 'package:clip_tag/features/templates/data/model/template_model.dart';

class Template {
  final String template;
  final DateTime createdAt;

  Template({required this.template, required this.createdAt});

  factory Template.fromModel(TemplateModel model) => Template(
        template: model.template,
        createdAt: model.createdAt.toDate(),
      );

  String get date =>
      '${createdAt.day.toString().padLeft(2, '0')}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.year} - ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
}
