import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../shared/firebase/firebase_controller.dart';
import '../model/forum_tags.dart';
import 'controllers/checkout_controller.dart';
import 'widgets/forum_tag.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key, required this.choosenRules});

  static const String route = '/checkout';
  final String choosenRules;

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseProvider.of(context);
    final checkoutController = CheckoutController(choosenRules);

    return ListenableBuilder(
      listenable: checkoutController,
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Подготовка тега'),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () =>
                      checkoutController.copyChoosenRules(withTag: true),
                  child: const Text('С тегом'),
                ),
                PopupMenuItem(
                  onTap: checkoutController.copyChoosenRules,
                  child: const Text('Без тега'),
                ),
              ],
              icon: const Icon(Icons.copy),
              position: PopupMenuPosition.under,
            ),
            IconButton(
              onPressed: checkoutController.sendChoosenRules,
              icon: const Icon(Icons.send),
            ),
          ],
          shadowColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Constants.previewPadding),
            child: ForumTag(
              content: choosenRules,
              tag: checkoutController.currentForumTag,
            ),
          ),
        ),
        bottomNavigationBar: firebase.isUserModerator
            ? NavigationBar(
                selectedIndex: checkoutController.currentTagIndex,
                destinations: [
                  for (final tag in ForumTags.values)
                    NavigationDestination(
                        icon: Icon(tag.icon), label: tag.title),
                ],
                onDestinationSelected: (index) =>
                    checkoutController.setCurrentTagIndex(index),
              )
            : null,
      ),
    );
  }
}
