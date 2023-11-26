import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/firebase/firebase_controller.dart';
import '../../../../utils/copy_to_clipboard.dart';
import '../../../../utils/open_url.dart';
import '../../features/favorites/data/model/favorite_model.dart';
import '../../features/favorites/domain/entity/favorite.dart';
import '../../features/favorites/domain/entity/forum_tags.dart';
import '../../features/forum_sections/data/model/forum_section_model.dart';
import '../../features/forum_sections/domain/entity/forum_section.dart';

class RulesController with ChangeNotifier {
  final FirebaseController firebase;

  RulesController({required this.firebase}) {
    firebase.ruleSections.listen(
      (sectionQuery) => _setSections(
        sectionQuery.docs.map(
          (sectionSnapshot) => ForumSection.fromModel(
            ForumSectionModel.fromMap(sectionSnapshot.data()),
          ),
        ),
      ),
    );

    firebase.favorites?.listen(
      (favoritesSnapshot) => _setFavorites(
        favoritesSnapshot.docs.map(
          (favoriteSnapshot) => Favorite.fromModel(
            FavoriteModel.fromMap(favoriteSnapshot.data()),
            reference: favoriteSnapshot.reference,
          ),
        ),
      ),
    );
  }

  // // // // // //

  final _sections = <ForumSection>[];
  List<ForumSection> get sections => _sections;
  void _setSections(Iterable<ForumSection> sections) {
    if (_sections.isNotEmpty) {
      _sections.clear();
    }
    _sections.addAll(sections);
    notifyListeners();
  }

  int _sectionIndex = 0;
  int get sectionIndex => _sectionIndex;
  void setSectionIndex(int index) {
    _sectionIndex = index;
    notifyListeners();
  }

  ForumSection? get section =>
      _sections.isNotEmpty ? _sections[_sectionIndex] : null;

  // // // // // //

  final _choosenRules = <String>[];
  List<String> get choosenRules => _choosenRules;

  void selectRule(String rule) {
    _choosenRules.add(rule);
    notifyListeners();
  }

  void deselectRule(String rule) {
    _choosenRules.remove(rule);
    notifyListeners();
  }

  void deselectAllRules() {
    _choosenRules.clear();
    notifyListeners();
  }

  // // // // // //

  final _favorites = <Favorite>[];
  List<Favorite> get favorites => _favorites;
  void _setFavorites(Iterable<Favorite> favorites) {
    if (_favorites.isNotEmpty) {
      _favorites.clear();
    }
    _favorites.addAll(favorites);
    notifyListeners();
  }

  int _favoritesTagIndex = 0;
  int get favoritesTagIndex => _favoritesTagIndex;
  void setFavoritesTagIndex(int index) {
    _favoritesTagIndex = index;
    notifyListeners();
  }

  ForumTags get tag => ForumTags.values[_favoritesTagIndex];

  // // // // // //

  Future<void> addRulesToFavorites({String? singleRule}) async =>
      await firebase.addFavorite(section!
          .mergeChoosenRules(singleRule != null ? [singleRule] : choosenRules));

  void sendToFourpda(int favoriteIndex) {
    const client = Constants.fourpdaClientPackageName;

    var content = _favorites[favoriteIndex].content;
    if (firebase.isTagVisible) {
      content = _favorites[favoriteIndex].wrapWithTag(tag);
    }

    copyToClipboard(content).then(
      (_) => DeviceApps.isAppInstalled(client).then((isInstalled) => isInstalled
          ? DeviceApps.openApp(client)
          : openUrl(Constants.fourpdaDefaultUrl)),
    );
  }
}

class RulesProvider extends InheritedNotifier {
  const RulesProvider({
    super.key,
    required this.controller,
    required super.child,
  }) : super(
          notifier: controller,
        );

  final RulesController controller;

  static RulesController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RulesProvider>()!.controller;
}
