import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../shared/firebase/firebase_controller.dart';
import '../../../shared/ui/bbcode_renderer.dart';
import '../../../shared/ui/get_color_scheme.dart';
import '../../../shared/ui/loading_circle.dart';
import '../../../shared/ui/show_snackbar.dart';
import '../features/favorites/domain/entity/forum_tags.dart';
import '../features/favorites/ui/forum_tag.dart';
import '../features/forum_sections/utils/get_forum_section_icon.dart';
import 'controllers/rules_controller.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScaffoldState? get _scaffoldState => _scaffoldKey.currentState;

  late bool _showForumSections = false;
  void _switchForumSections([bool? condition]) {
    setState(() => _showForumSections = condition ?? !_showForumSections);
  }

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseProvider.of(context);
    final controller = RulesProvider.of(context);

    final favoriteScrollController = ScrollController();
    final sectionsScrollController = ScrollController();

    void addToFavorites([String? rule]) {
      _switchForumSections();
      controller.addRulesToFavorites(rule);
    }

    // Disables access to favorites for guest mode
    if (firebase.isUserAnonymous) {
      _switchForumSections(true);
    }

    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldState?.isDrawerOpen == true) {
          _scaffoldState?.closeDrawer();
          return false;
        }

        if (_showForumSections && sectionsScrollController.offset > 0) {
          sectionsScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          );
          return false;
        }

        if (controller.sectionIndex != 0) {
          controller.setSectionIndex(0);
          return false;
        }

        if (favoriteScrollController.offset > 0) {
          favoriteScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          );
        }

        if (!firebase.isUserAnonymous && _showForumSections) {
          _switchForumSections();
          return false;
        }

        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
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
          actions: firebase.isUserAnonymous
              ? [
                  IconButton(
                    onPressed: firebase.signOut,
                    icon: const Icon(Icons.logout),
                  ),
                ]
              : [
                  if (!_showForumSections && firebase.favorites.isNotEmpty)
                    IconButton(
                      onPressed: firebase.switchTagVisibility,
                      icon: Icon(
                        firebase.isTagVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  if (controller.choosenRules.isEmpty)
                    IconButton(
                      onPressed: _switchForumSections,
                      icon: Icon(_showForumSections ? Icons.close : Icons.add),
                    ),
                ],
          shadowColor: Colors.black,
          centerTitle: false,
        ),
        body: _showForumSections
            ? controller.section == null
                ? const LoadingCircle()
                : ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false,
                    ),
                    child: ListView.builder(
                      controller: sectionsScrollController,
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
                                onTap: !firebase.isUserAnonymous
                                    ? () => controller.choosenRules.isNotEmpty
                                        ? controller.choosenRules.contains(rule)
                                            ? controller.deselectRule(rule)
                                            : controller.selectRule(rule)
                                        : addToFavorites(rule)
                                    : null,
                                onLongPress: !firebase.isUserAnonymous &&
                                        controller.choosenRules.isEmpty
                                    ? () => controller.selectRule(rule)
                                    : null,
                                tileColor: controller.choosenRules
                                        .contains(rule)
                                    ? getColorScheme(context).secondaryContainer
                                    : null,
                              ),
                          ],
                        );
                      },
                      itemCount: controller.section!.categories.length,
                    ),
                  )
            : firebase.favorites.isEmpty
                ? const Center(
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
                : ReorderableListView.builder(
                    itemBuilder: (context, index) {
                      final favorite = firebase.favorites[index];

                      return ReorderableDelayedDragStartListener(
                        key: ValueKey(favorite),
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Dismissible(
                            key: ValueKey(favorite),
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
                            onDismissed: (_) => firebase
                                .removeFromFavorites(index)
                                .then((value) => showSnackbar(
                                      context: context,
                                      message: 'Удаление завершено',
                                    )),
                            direction: DismissDirection.endToStart,
                            child: InkWell(
                              onTap: () => controller.sendToFourpda(favorite),
                              child: ForumTag(
                                content: favorite,
                                tag: controller.tag,
                                isTagVisible: firebase.isTagVisible,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: firebase.favorites.length,
                    onReorder: (oldIndex, newIndex) => firebase.reorderFavorite(
                        oldIndex: oldIndex, newIndex: newIndex),
                    buildDefaultDragHandles: false,
                    scrollController: favoriteScrollController,
                  ),
        floatingActionButton:
            _showForumSections && controller.choosenRules.isNotEmpty
                ? FloatingActionButton.extended(
                    onPressed: addToFavorites,
                    icon: const Icon(Icons.bookmark_add),
                    label: Text('Добавить (${controller.choosenRules.length})'),
                  )
                : null,
        bottomNavigationBar: !_showForumSections &&
                firebase.isUserModerator &&
                firebase.favorites.isNotEmpty &&
                firebase.isTagVisible
            ? NavigationBar(
                selectedIndex: controller.favoritesTagIndex,
                destinations: ForumTags.values
                    .map((tag) => NavigationDestination(
                          icon: Icon(tag.icon),
                          label: tag.title,
                        ))
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
                      sectionsScrollController.jumpTo(0);
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
      ),
    );
  }
}
