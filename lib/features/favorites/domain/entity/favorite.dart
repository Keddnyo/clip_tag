import 'package:clip_tag/features/checkout/model/forum_tags.dart';
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

  factory Favorite.fromModel(
    FavoriteModel model, {
    required DocumentReference<Map<String, dynamic>> reference,
  }) =>
      Favorite(
        content: model.content,
        createdAt: model.createdAt.toDate(),
        reference: reference,
      );

  String get date =>
      '${createdAt.day}.${createdAt.month}.${createdAt.year} - ${createdAt.hour}:${createdAt.minute}';

  String wrapWithTag(ForumTags tag) {
    final buffer = StringBuffer();

    buffer
      ..write('[${tag.closure}]')
      ..write('\n')
      ..write(content)
      ..write('\n')
      ..write('[/${tag.closure}]');

    return buffer.toString();
  }
}
