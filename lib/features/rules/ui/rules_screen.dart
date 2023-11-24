import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../shared/firebase/firebase_controller.dart';
import '../../../shared/ui/bbcode_renderer.dart';
import '../../../shared/ui/get_color_scheme.dart';
import '../../../shared/ui/loading_circle.dart';
import '../../../shared/ui/show_snackbar.dart';
import '../../../utils/copy_to_clipboard.dart';
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
  late bool _showForumSections = false;
  void _switchForumSections() {
    setState(() => _showForumSections = !_showForumSections);
  }

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseProvider.of(context);
    final controller = RulesProvider.of(context);

    final sectionsScroller = ScrollController();

    void addRulesToFavorites([String? rule]) =>
        controller.addRulesToFavorites(singleRule: rule).then((_) {
          if (controller.choosenRules.isNotEmpty) {
            controller.deselectAllRules();
          }
          _switchForumSections();
          showSnackbar(context: context, message: 'Тег добавлен');
        }).catchError((error) {
          showSnackbar(context: context, message: 'Не удалось добавить тег');
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
        actions: firebase.isUserAnonymous
            ? [
                IconButton(
                  onPressed: firebase.signOut,
                  icon: const Icon(Icons.logout),
                ),
              ]
            : [
                if (controller.choosenRules.isEmpty)
                  IconButton(
                    onPressed: _switchForumSections,
                    icon: Icon(_showForumSections ? Icons.close : Icons.add),
                  ),
              ],
        shadowColor: Colors.black,
        centerTitle: false,
      ),
      body: firebase.isUserAnonymous || _showForumSections
          ? controller.section == null
              ? const LoadingCircle()
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
                              onTap: () => firebase.isUserAnonymous
                                  ? copyToClipboard(rule).then(
                                      (_) => showSnackbar(
                                        context: context,
                                        message: 'Скопировано в буфер обмена',
                                      ),
                                    )
                                  : controller.choosenRules.isNotEmpty
                                      ? controller.choosenRules.contains(rule)
                                          ? controller.deselectRule(rule)
                                          : controller.selectRule(rule)
                                      : addRulesToFavorites(rule),
                              onLongPress: () => !firebase.isUserAnonymous &&
                                      controller.choosenRules.isEmpty
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
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_add, size: 64.0),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Добавьте теги в список',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
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
                  onPressed: addRulesToFavorites,
                  icon: const Icon(Icons.bookmark_add),
                  label: Text('Добавить (${controller.choosenRules.length})'),
                )
              : null,
      bottomNavigationBar: !_showForumSections &&
              firebase.isUserModerator &&
              controller.favorites.isNotEmpty
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
          : !firebase.isUserAnonymous
              ? Drawer(
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
                )
              : null,
    );
  }
}
