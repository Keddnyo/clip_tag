import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/bbcode_renderer.dart';
import '../../../shared/constants.dart';
import '../../../shared/ui/loading_circle.dart';
import '../../../utils/show_snackbar.dart';
import '../../templates/data/model/template_model.dart';
import '../../templates/ui/templates_screen.dart';
import '../utils/get_forum_section_icon.dart';
import 'controllers/sections_controller.dart';

class ForumSectionsScreen extends StatelessWidget {
  const ForumSectionsScreen({super.key});

  static const String route = '/forum_sections';

  @override
  Widget build(BuildContext context) {
    final controller = ForumSectionsController(context: context);
    final scrollController = ScrollController();

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return WillPopScope(
      onWillPop: () async {
        if (scaffoldKey.currentState?.isDrawerOpen == true) {
          scaffoldKey.currentState?.closeDrawer();
          return false;
        }

        if (scaffoldKey.currentState?.isEndDrawerOpen == true) {
          scaffoldKey.currentState?.closeEndDrawer();
          return false;
        }

        if (controller.choosenRules.isNotEmpty) {
          controller.clearChoosenRules();
          return false;
        }

        if (controller.sectionIndex != 0) {
          controller.setSectionIndex(0);
          scrollController.jumpTo(0);
          return false;
        }

        return true;
      },
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, child) => Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: controller.choosenRules.isNotEmpty
                ? IconButton(
                    onPressed: controller.clearChoosenRules,
                    icon: const Icon(Icons.close),
                  )
                : null,
            title: Text(
              controller.sections.isNotEmpty
                  ? controller.choosenRules.isNotEmpty
                      ? controller.choosenRules.length.toString()
                      : controller.section!.title
                  : 'ClipTag',
            ),
            actions: controller.choosenRules.isNotEmpty
                ? [
                    TextButton.icon(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection('templates')
                            .add(
                              TemplateModel.toMap(
                                content: controller.choosenRulesCombined,
                                createdAt: DateTime.now(),
                              ),
                            )
                            .then(
                          (_) {
                            controller.clearChoosenRules();
                            showSnackbar(
                              context: context,
                              message: 'Заготовка сохранена',
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.cut),
                      label: const Text('В заготовки'),
                    ),
                  ]
                : null,
            shadowColor: Colors.black,
            centerTitle: controller.choosenRules.isEmpty,
          ),
          body: controller.sections.isNotEmpty
              ? ListView(
                  controller: scrollController,
                  padding: controller.choosenRules.isNotEmpty
                      ? const EdgeInsets.only(bottom: 96.0)
                      : null,
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Constants.appName,
                          style: TextStyle(fontSize: 48.0),
                        ),
                        Text('Агрегатор правил 4PDA'),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: Text(FirebaseAuth.instance.currentUser!.displayName!),
                  subtitle: Text(FirebaseAuth.instance.currentUser!.email!),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        FirebaseAuth.instance.currentUser!.displayName!,
                      ),
                      content: Text(FirebaseAuth.instance.currentUser!.email!),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);

                            final firestoreUser = FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser?.uid);

                            firestoreUser
                                .collection('templates')
                                .get()
                                .then(
                                  (query) {
                                    for (var doc in query.docs) {
                                      doc.reference.delete();
                                    }
                                  },
                                )
                                .then(
                                  (_) => firestoreUser.delete(),
                                )
                                .then(
                                  (_) => FirebaseAuth.instance.currentUser
                                      ?.delete(),
                                );
                          },
                          child: const Text('Удалить аккаунт'),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                            FirebaseAuth.instance.signOut();
                          },
                          child: const Text('Выход'),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.cut),
                  title: const Text('Заготовки'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, TemplatesScreen.route);
                  },
                ),
                const Divider(),
                const AboutListTile(
                  icon: Icon(Icons.info_outline),
                  applicationLegalese: Constants.applicationLegalese,
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
          floatingActionButton: controller.choosenRules.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: controller.navigateToCheckout,
                  icon: const Icon(Icons.visibility),
                  label: const Text('Предпросмотр'),
                )
              : null,
        ),
      ),
    );
  }
}
