import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/model/favorite_model.dart';

class Favorite {
  final String content;
  final DateTime createdAt;
  final DocumentReference<Map<String, dynamic>> reference;

  Favorite({
    required this.content,
    required this.createdAt,
    required this.reference,
  });

  String get date =>
      '${createdAt.day}.${createdAt.month}.${createdAt.year} - ${createdAt.hour}:${createdAt.minute}';

  factory Favorite.fromModel(
    FavoriteModel model, {
    required DocumentReference<Map<String, dynamic>> reference,
  }) =>
      Favorite(
        content: model.content,
        createdAt: model.createdAt.toDate(),
        reference: reference,
      );
}
