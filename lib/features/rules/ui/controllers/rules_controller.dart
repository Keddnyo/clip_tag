import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/firebase/firebase_controller.dart';
import '../../../../utils/copy_to_clipboard.dart';
import '../../../../utils/open_url.dart';
import '../../features/favorites/domain/entity/forum_tags.dart';
import '../../features/forum_sections/data/model/forum_section_model.dart';
import '../../features/forum_sections/domain/entity/forum_section.dart';
import '../../utils/wrap_text_with_tag.dart';

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

  int _favoritesTagIndex = 0;
  int get favoritesTagIndex => _favoritesTagIndex;
  void setFavoritesTagIndex(int index) {
    _favoritesTagIndex = index;
    notifyListeners();
  }

  ForumTags get tag => ForumTags.values[_favoritesTagIndex];

  // // // // // //

  void addRulesToFavorites([String? rule]) {
    final newFavorite =
        section!.mergeChoosenRules(rule != null ? [rule] : choosenRules);

    if (!firebase.favorites.contains(newFavorite)) {
      firebase.addToFavorites(newFavorite).then((_) {
        if (choosenRules.isNotEmpty) {
          deselectAllRules();
        }
      });
    }
  }

  void sendToFourpda(String favorite) => copyToClipboard(
        firebase.isTagVisible ? wrapTextWithTag(favorite, tag: tag) : favorite,
      ).then(
        (_) => DeviceApps.isAppInstalled(Constants.fourpdaClientPackageName)
            .then((isInstalled) => isInstalled
                ? DeviceApps.openApp(Constants.fourpdaClientPackageName)
                : openUrl(Constants.fourpdaDefaultUrl)),
      );
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
