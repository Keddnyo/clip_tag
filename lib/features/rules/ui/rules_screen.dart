import '../../favorites/data/model/favorite_model.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../shared/firebase/firebase_controller.dart';
import '../../../shared/ui/bbcode_renderer.dart';
import '../../checkout/model/forum_tags.dart';
import '../../checkout/ui/widgets/forum_tag.dart';
import '../../favorites/domain/entity/favorite.dart';
import '../../forum_sections/data/model/forum_section_model.dart';
import '../../forum_sections/domain/entity/forum_section.dart';
import '../../forum_sections/utils/get_forum_section_icon.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  bool _showForumSections = false;
  void _switchForumSections() {
    setState(() => _showForumSections = !_showForumSections);
  }

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseProvider.of(context);
    final controller = RulesScreenProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showForumSections && controller.section != null
              ? controller.section!.title
              : Constants.appName,
        ),
        actions: [
          IconButton(
            onPressed: _switchForumSections,
            icon: Icon(
              _showForumSections ? Icons.close : Icons.add,
            ),
          ),
        ],
      ),
      body: _showForumSections
          ? controller.sections.isEmpty
              ? const Text('No Data')
              : ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                  ),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final category = controller.section!.categories[index];

                      return Column(
                        children: [
                          const Divider(height: 1.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(category.title),
                          ),
                          const Divider(height: 1.0),
                          for (final rule in category.rules)
                            ListTile(
                              title: BBCodeRenderer(rule),
                            ),
                        ],
                      );
                    },
                    itemCount: controller.section!.categories.length,
                  ),
                )
          : controller.favorites.isEmpty
              ? const Text('No Data')
              : ListView.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ForumTag(
                      content: controller.favorites[index].content,
                      tag: controller.tag,
                    ),
                  ),
                  itemCount: controller.favorites.length,
                ),
      bottomNavigationBar: !_showForumSections && firebase.isUserModerator
          ? NavigationBar(
              selectedIndex: controller.favoritesTagIndex,
              destinations: ForumTags.values
                  .map((tag) => NavigationDestination(
                      icon: Icon(tag.icon), label: tag.title))
                  .toList(),
              onDestinationSelected: (index) =>
                  controller.setFavoritesTagIndex(index),
            )
          : null,
      drawer: _showForumSections && controller.sections.isNotEmpty
          ? NavigationDrawer(
              onDestinationSelected: (index) => controller.setSectionIndex(
                index,
              ),
              selectedIndex: controller.sectionIndex,
              children: [
                const SizedBox(height: 12.0),
                for (final section in controller.sections)
                  NavigationDrawerDestination(
                    icon: Icon(
                      controller.section!.order == 0
                          ? Icons.home
                          : getForumSectionIcon(section.title),
                    ),
                    label: Flexible(
                      child: Text(section.title),
                    ),
                  ),
                const SizedBox(height: 12.0),
              ],
            )
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: Center(
                      child: Text(Constants.appName),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class RulesScreenController with ChangeNotifier {
  RulesScreenController() {
    FirebaseController().ruleSections.listen(
          (sectionQuery) => _setSections(
            sectionQuery.docs.map(
              (sectionSnapshot) => ForumSection.fromModel(
                ForumSectionModel.fromMap(
                  sectionSnapshot.data(),
                ),
              ),
            ),
          ),
        );

    FirebaseController().favorites?.listen(
          (favoritesSnapshot) => _setFavorites(
            favoritesSnapshot.docs.map(
              (favoriteSnapshot) => Favorite.fromModel(
                FavoriteModel.fromMap(
                  favoriteSnapshot.data(),
                ),
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

  ForumSection? get section => _sections[_sectionIndex];

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
}

class RulesScreenProvider extends InheritedNotifier {
  const RulesScreenProvider({
    super.key,
    required this.controller,
    required super.child,
  }) : super(
          notifier: controller,
        );

  final RulesScreenController controller;

  static RulesScreenController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<RulesScreenProvider>()!
      .controller;
}
