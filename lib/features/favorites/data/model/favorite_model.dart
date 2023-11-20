import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/favorite.dart';

class FavoriteModel {
  final String content;
  final Timestamp createdAt;

  FavoriteModel({
    required this.content,
    required this.createdAt,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) => FavoriteModel(
        content: map['content'],
        createdAt: map['createdAt'],
      );

  static Map<String, dynamic> toMap({
    required String content,
    required DateTime createdAt,
  }) =>
      {
        'content': content,
        'createdAt': createdAt,
      };

  Favorite toTemplate() =>
      Favorite(content: content, createdAt: createdAt.toDate());
}
