import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../shared/firebase/firebase_controller.dart';
import '../../../shared/ui/get_color_scheme.dart';
import '../../../shared/ui/loading_circle.dart';
import '../../../shared/ui/show_snackbar.dart';
import '../../../utils/copy_to_clipboard.dart';
import '../../../utils/open_url.dart';
import '../../checkout/model/forum_tags.dart';
import '../../checkout/ui/widgets/forum_tag.dart';
import '../../forum_sections/ui/forum_sections_screen.dart';
import '../data/model/favorite_model.dart';
import '../domain/entity/favorite.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  static const String route = '/history';

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _currentTagIndex = 0;
  void _setTagIndex(int index) {
    setState(() {
      _currentTagIndex = index;
    });
  }

  ForumTags get currentTag => ForumTags.values[_currentTagIndex];

  void sendChoosenRules(String choosenRules) =>
      copyToClipboard(choosenRules).then(
        (_) => DeviceApps.isAppInstalled(Constants.fourpdaClientPackageName)
            .then((isAppInstalled) => isAppInstalled
                ? DeviceApps.openApp(Constants.fourpdaClientPackageName)
                : openUrl(Constants.fourpdaDefaultUrl)),
      );

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseProvider.of(context);
    final colorScheme = getColorScheme(context);

    return StreamBuilder(
      stream: firebase.favorites,
      builder: (context, snapshot) {
        final favorites = snapshot.data!.docs;

        return Scaffold(
          appBar: AppBar(
            title: const Text('ClipTag'),
            shadowColor: Colors.black,
          ),
          body: !snapshot.hasData
              ? const LoadingCircle()
              : favorites.isEmpty
                  ? const Center(
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
                    )
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 96.0),
                      children: favorites.map(
                        (favoritesQuery) {
                          final favorite = Favorite.fromModel(
                            FavoriteModel.fromMap(favoritesQuery.data()),
                          );

                          const padding = Constants.previewPadding;

                          return Dismissible(
                            key: ValueKey(favorite),
                            background: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: padding),
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
                            child: Padding(
                              padding: const EdgeInsets.all(
                                Constants.previewPadding,
                              ),
                              child: InkWell(
                                onTap: () => sendChoosenRules(favorite.content),
                                child: ForumTag(
                                  content: favorite.content,
                                  tag: currentTag,
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(
              context,
              ForumSectionsScreen.route,
            ),
            icon: const Icon(Icons.add),
            label: const Text('Добавить правила'),
          ),
          drawer: const MainDrawer(),
          bottomNavigationBar: firebase.isUserModerator && favorites.isNotEmpty
              ? NavigationBar(
                  selectedIndex: _currentTagIndex,
                  destinations: [
                    for (final tag in ForumTags.values)
                      NavigationDestination(
                          icon: Icon(tag.icon), label: tag.title),
                  ],
                  onDestinationSelected: (index) => _setTagIndex(index),
                )
              : null,
        );
      },
    );
  }
}
