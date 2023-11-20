import '../../data/model/favorite_model.dart';

class Favorite {
  final String content;
  final DateTime createdAt;

  Favorite({
    required this.content,
    required this.createdAt,
  });

  factory Favorite.fromModel(FavoriteModel model) => Favorite(
        content: model.content,
        createdAt: model.createdAt.toDate(),
      );
}
