import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/template.dart';

class TemplateModel {
  final String content;
  final Timestamp createdAt;

  TemplateModel({
    required this.content,
    required this.createdAt,
  });

  factory TemplateModel.fromMap(Map<String, dynamic> map) => TemplateModel(
        content: map['content'],
        createdAt: map['createdAt'],
      );

  static Map<String, dynamic> toMap({
    required String content,
    required DateTime createdAt,
  }) =>
      {'content': content, 'createdAt': createdAt};

  Template toTemplate() => Template(
        content: content,
        createdAt: createdAt.toDate(),
      );
}
