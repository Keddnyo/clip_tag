import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/template.dart';

class TemplateModel {
  final String template;
  final Timestamp createdAt;

  TemplateModel({required this.template, required this.createdAt});

  factory TemplateModel.fromJson(Map<String, dynamic> json) => TemplateModel(
        template: json['template'],
        createdAt: json['createdAt'],
      );

  Template toTemplate() =>
      Template(template: template, createdAt: createdAt.toDate());
}
