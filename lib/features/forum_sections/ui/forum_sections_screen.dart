import 'package:clip_tag/features/templates/ui/templates_screen.dart';
import 'package:clip_tag/shared/constants.dart';
import 'package:flutter/material.dart';

import '../../../shared/bbcode_renderer.dart';
import '../../../shared/ui/loading_circle.dart';
import 'controllers/sections_controller.dart';
import '../utils/get_forum_section_icon.dart';

class ForumSectionsScreen extends StatelessWidget {
  const ForumSectionsScreen({super.key});

  static const String route = '/forum_sections';

  @override
  Widget build(BuildContext context) {
    final controller = ForumSectionsController(context: context);
    final scrollController = ScrollController();

    return WillPopScope(
      onWillPop: () async {
        if (controller.choosenRules.isNotEmpty) {
          controller.clearChoosenRules();
          return false;
        }

        return true;
      },
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, child) => Scaffold(
          appBar: AppBar(
            // leading: controller.choosenRules.isNotEmpty
            //     ? IconButton(
            //         onPressed: controller.clearChoosenRules,
            //         icon: const Icon(Icons.close),
            //       )
            //     : IconButton(
            //         onPressed: FirebaseAuth.instance.signOut,
            //         icon: const Icon(Icons.logout),
            //       ),
            title: Text(
              controller.sections.isNotEmpty
                  ? controller.choosenRules.isNotEmpty
                      ? controller.choosenRules.length.toString()
                      : controller.section!.title
                  : 'ClipTag',
            ),
            actions: controller.choosenRules.isNotEmpty
                ? [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_add_outlined),
                    ),
                  ]
                : null,
            centerTitle: controller.choosenRules.isEmpty,
          ),
          body: controller.sections.isNotEmpty
              ? ListView(
                  controller: scrollController,
                  children: [
                    for (final category in controller.section!.categories)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(height: 1.0),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(category.title),
                            ),
                          ),
                          const Divider(height: 1.0),
                          for (final rule in category.rules)
                            ListTile(
                              title: BBCodeRenderer(rule),
                              onTap: () => controller.choosenRules.isEmpty
                                  ? controller.navigateToCheckout(rule)
                                  : controller.choosenRules.contains(rule)
                                      ? controller.removeRule(rule)
                                      : controller.addRule(rule),
                              onLongPress: controller.choosenRules.isEmpty
                                  ? () => controller.addRule(rule)
                                  : null,
                              tileColor: controller.choosenRules.contains(rule)
                                  ? Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                  : null,
                            ),
                        ],
                      ),
                  ],
                )
              : const LoadingCircle(),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  child: Text(Constants.appName),
                ),
                ListTile(
                  leading: const Icon(Icons.cut),
                  title: const Text('Заготовки'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, TemplatesScreen.route);
                  },
                ),
              ],
            ),
          ),
          endDrawer: controller.sections.isNotEmpty
              ? NavigationDrawer(
                  onDestinationSelected: (index) {
                    controller.setSectionIndex(index);
                    controller.clearChoosenRules();
                    Navigator.pop(context);
                    scrollController.jumpTo(0);
                  },
                  selectedIndex: controller.sectionIndex,
                  children: controller.sections
                      .map(
                        (section) => NavigationDrawerDestination(
                          icon: Icon(
                            section.order == 0
                                ? Icons.home
                                : getForumSectionIcon(section.title),
                          ),
                          label: Flexible(
                            child: Text(section.title),
                          ),
                        ),
                      )
                      .toList(),
                )
              : null,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: controller.choosenRules.isNotEmpty
                ? controller.navigateToCheckout
                : null,
            icon: Icon(
              controller.choosenRules.isNotEmpty
                  ? Icons.visibility
                  : Icons.bookmark_outline,
            ),
            label: Text(
              controller.choosenRules.isNotEmpty ? 'Предпросмотр' : 'Избранное',
            ),
          ),
        ),
      ),
    );
  }
}
