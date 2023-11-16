import 'package:clip_tag/features/auth/ui/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/bbcode_renderer.dart';
import 'controllers/sections_controller.dart';
import '../utils/get_forum_section_icon.dart';

class ForumSectionsScreen extends StatelessWidget {
  const ForumSectionsScreen({super.key});

  static const String route = '/forum_sections';

  @override
  Widget build(BuildContext context) {
    final controller = ForumSectionsController(context: context);
    final scrollController = ScrollController();

    bool isSignedIn = FirebaseAuth.instance.currentUser != null;

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
            leading: controller.choosenRules.isNotEmpty
                ? IconButton(
                    onPressed: controller.clearChoosenRules,
                    icon: const Icon(Icons.close),
                  )
                : IconButton(
                    onPressed: () => isSignedIn
                        ? FirebaseAuth.instance.signOut()
                        : Navigator.pushNamed(
                            context,
                            AuthScreen.route,
                          ),
                    icon: Icon(
                      isSignedIn ? Icons.account_circle_outlined : Icons.login,
                    ),
                  ),
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
                              child: Text(category.categoryName),
                            ),
                          ),
                          const Divider(height: 1.0),
                          for (final rule in category.rules)
                            ListTile(
                              title: BBCodeRenderer(content: rule),
                              onTap: () => isSignedIn
                                  ? controller.choosenRules.isEmpty
                                      ? controller.navigateToCheckout(rule)
                                      : controller.choosenRules.contains(rule)
                                          ? controller.removeRule(rule)
                                          : controller.addRule(rule)
                                  : null,
                              onLongPress:
                                  isSignedIn && controller.choosenRules.isEmpty
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
              : const Center(
                  child: CircularProgressIndicator(),
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
          floatingActionButton: FirebaseAuth.instance.currentUser != null
              ? FloatingActionButton.extended(
                  onPressed: controller.choosenRules.isNotEmpty
                      ? controller.navigateToCheckout
                      : null,
                  icon: Icon(
                    controller.choosenRules.isNotEmpty
                        ? Icons.visibility
                        : Icons.bookmark_outline,
                  ),
                  label: Text(
                    controller.choosenRules.isNotEmpty
                        ? 'Предпросмотр'
                        : 'Избранное',
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
