import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../shared/firebase/firebase_controller.dart';
import '../../../shared/ui/bbcode_renderer.dart';
import '../../../shared/ui/get_color_scheme.dart';
import '../../../shared/ui/show_snackbar.dart';
import '../../../utils/copy_to_clipboard.dart';
import '../../../utils/open_url.dart';
import '../../checkout/model/forum_tags.dart';
import '../../checkout/ui/widgets/forum_tag.dart';
import '../../favorites/data/model/favorite_model.dart';
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
  late bool _showForumSections = false;
  void _switchForumSections() {
    setState(() => _showForumSections = !_showForumSections);
  }

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseProvider.of(context);
    final controller = RulesScreenProvider.of(context);

    final sectionsScroller = ScrollController();

    void addRulesToFavorites(List<String> rules) => firebase
            .addFavorite(controller.section!.combineChoosenRulesToString(rules))
            .then(
          (_) {
            _switchForumSections();
            if (controller.choosenRules.isNotEmpty) {
              controller.deselectAllRules();
            }
            showSnackbar(
              context: context,
              message: 'Тег добавлен',
            );
          },
        ).catchError((error) {
          showSnackbar(
            context: context,
            message: 'Не удалось добавить тег',
          );
        });

    return Scaffold(
      appBar: AppBar(
        leading: _showForumSections && controller.choosenRules.isNotEmpty
            ? IconButton(
                onPressed: controller.deselectAllRules,
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(
          _showForumSections && controller.section != null
              ? controller.choosenRules.isNotEmpty
                  ? 'Множественный выбор'
                  : controller.section!.title
              : Constants.appName,
        ),
        actions: [
          if (controller.choosenRules.isEmpty)
            IconButton(
              onPressed: _switchForumSections,
              icon: Icon(
                _showForumSections ? Icons.close : Icons.add,
              ),
            ),
        ],
        shadowColor: Colors.black,
      ),
      body: _showForumSections
          ? controller.section == null
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, size: 64.0),
                      Text(
                        'Список правил недоступен',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                )
              : ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                  ),
                  child: ListView.builder(
                    controller: sectionsScroller,
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
                              onTap: () => controller.choosenRules.isNotEmpty
                                  ? controller.choosenRules.contains(rule)
                                      ? controller.deselectRule(rule)
                                      : controller.selectRule(rule)
                                  : addRulesToFavorites([rule]),
                              onLongPress: () => controller.choosenRules.isEmpty
                                  ? controller.selectRule(rule)
                                  : null,
                              tileColor: controller.choosenRules.contains(rule)
                                  ? getColorScheme(context).secondaryContainer
                                  : null,
                            ),
                        ],
                      );
                    },
                    itemCount: controller.section!.categories.length,
                  ),
                )
          : controller.favorites.isEmpty
              ? const Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Правила добавляются здесь'),
                            SizedBox(width: 12.0),
                            Icon(Icons.arrow_upward),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bookmark_add, size: 64.0),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Добавьте правила в список',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final favorite = controller.favorites[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Dismissible(
                        key: ValueKey(favorite.reference),
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: getColorScheme(context).error,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.delete,
                              color: getColorScheme(context).onError,
                            ),
                          ),
                        ),
                        onDismissed: (_) => favorite.reference.delete().then(
                              (value) => showSnackbar(
                                context: context,
                                message: 'Тег удалён',
                              ),
                            ),
                        direction: DismissDirection.endToStart,
                        child: InkWell(
                          onTap: () => controller.sendToFourpda(index),
                          child: ForumTag(
                            content: favorite.content,
                            tag: controller.tag,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: controller.favorites.length,
                ),
      floatingActionButton:
          _showForumSections && controller.choosenRules.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: () => addRulesToFavorites(controller.choosenRules),
                  icon: const Icon(Icons.bookmark_add),
                  label: Text('Добавить (${controller.choosenRules.length})'),
                )
              : null,
      bottomNavigationBar: !_showForumSections && firebase.isUserModerator
          ? NavigationBar(
              selectedIndex: controller.favoritesTagIndex,
              destinations: ForumTags.values
                  .map(
                    (tag) => NavigationDestination(
                      icon: Icon(tag.icon),
                      label: tag.title,
                    ),
                  )
                  .toList(),
              onDestinationSelected: (index) =>
                  controller.setFavoritesTagIndex(index),
            )
          : null,
      drawer: _showForumSections
          ? controller.sections.isNotEmpty
              ? NavigationDrawer(
                  onDestinationSelected: (index) {
                    Navigator.pop(context);
                    controller.setSectionIndex(index);
                    sectionsScroller.jumpTo(0);
                  },
                  selectedIndex: controller.sectionIndex,
                  children: [
                    const SizedBox(height: 12.0),
                    for (final section in controller.sections)
                      NavigationDrawerDestination(
                        icon: Icon(
                          section.order == 0
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
              : null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Constants.appName,
                            style: TextStyle(
                              fontSize: 42.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Created by Keddnyo',
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(firebase.username!),
                    subtitle: Text(firebase.userEmail!),
                    trailing: IconButton(
                      onPressed: firebase.signOut,
                      icon: const Icon(Icons.logout),
                    ),
                  ),
                  const Divider(),
                  AboutListTile(
                    icon: const Icon(Icons.info_outline),
                    applicationVersion: 'Агрегатор правил 4PDA',
                    applicationIcon: Image.asset(
                      'lib/core/assets/app_icon.png',
                      width: 72.0,
                      height: 72.0,
                    ),
                    applicationLegalese: Constants.applicationLegalese,
                    child: const Text('О приложении'),
                  ),
                ],
              ),
            ),
    );
  }
}

class RulesScreenController with ChangeNotifier {
  RulesScreenController() {
    FirebaseController.ruleSections.listen(
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
            favoritesSnapshot.docs.reversed.map(
              (favoriteSnapshot) => Favorite.fromModel(
                FavoriteModel.fromMap(
                  favoriteSnapshot.data(),
                ),
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

  void sendToFourpda(int favoriteIndex) {
    const client = Constants.fourpdaClientPackageName;
    final rulesWithTag = _favorites[favoriteIndex].wrapWithTag(tag);

    copyToClipboard(rulesWithTag).then(
      (_) => DeviceApps.isAppInstalled(client).then(
        (isInstalled) => isInstalled
            ? DeviceApps.openApp(client)
            : openUrl(Constants.fourpdaDefaultUrl),
      ),
    );
  }
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
