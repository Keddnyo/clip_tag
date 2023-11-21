import 'package:flutter/material.dart';

import '../../../shared/bbcode_renderer.dart';
import '../../../shared/constants.dart';
import '../../../shared/firebase/firebase_controller.dart';
import '../../../shared/ui/loading_circle.dart';
import '../../../utils/get_color_scheme.dart';
import '../../../utils/show_snackbar.dart';
import '../../checkout/ui/checkout_screen.dart';
import '../data/model/favorite_model.dart';
import '../domain/entity/favorite.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static const String route = '/favorites';

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseProvider.of(context);
    final colorScheme = getColorScheme(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        shadowColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: firebase.favoritesSnaphots,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingCircle();
          }

          final favorites = snapshot.data!.docs;

          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_add, size: 64.0),
                  SizedBox(height: 8.0),
                  Text(
                    'Добавьте правила в избранное',
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView(
            children: favorites.map(
              (favoritesQuery) {
                final favorite = Favorite.fromModel(
                  FavoriteModel.fromMap(favoritesQuery.data()),
                );

                const padding = Constants.previewPadding;

                return Dismissible(
                  key: ValueKey(favorite),
                  background: Padding(
                    padding: const EdgeInsets.symmetric(vertical: padding),
                    child: Container(
                      alignment: Alignment.centerRight,
                      color: colorScheme.error,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: colorScheme.onError,
                        ),
                      ),
                    ),
                  ),
                  onDismissed: (_) {
                    favoritesQuery.reference.delete();
                    showSnackbar(
                      context: context,
                      message: 'Удалено из избранных',
                    );
                  },
                  direction: DismissDirection.endToStart,
                  child: Container(
                    margin: const EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.onBackground,
                        width: 0.5,
                      ),
                    ),
                    child: ListTile(
                      title: BBCodeRenderer(favorite.content),
                      onTap: () => Navigator.pushNamed(
                        context,
                        CheckoutScreen.route,
                        arguments: favorite.content,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
