import 'package:flutter/material.dart';

import '../../../shared/bbcode_renderer.dart';
import '../../../utils/get_color_scheme.dart';
import '../../../utils/open_url.dart';
import '../../checkout/ui/checkout_screen.dart';
import '../../forum_sections/model/forum_section.dart';
import 'controllers/rules_controller.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key, required this.forumSection});

  static const String route = '/rules';
  final ForumSection forumSection;

  @override
  Widget build(BuildContext context) {
    final rulesController = RulesController();

    void navigateToCheckout({dynamic rule}) => Navigator.pushNamed(
          context,
          CheckoutScreen.route,
          arguments: forumSection.combineChoosenRulesToString(
            rule != null ? [rule] : rulesController.choosenRules,
          ),
        );

    return ListenableBuilder(
      listenable: rulesController,
      builder: (context, child) => WillPopScope(
        onWillPop: () async {
          if (rulesController.choosenRules.isNotEmpty) {
            rulesController.clearChoosenRules();
            return false;
          }

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(forumSection.title),
            actions: [
              IconButton(
                onPressed: () => openUrl(forumSection.rulesUrl),
                icon: const Icon(Icons.open_in_new),
              )
            ],
            shadowColor: Colors.black,
          ),
          body: ListView.builder(
            padding: rulesController.choosenRules.isNotEmpty
                ? const EdgeInsets.only(bottom: 96.0)
                : null,
            itemBuilder: (context, index) {
              final category = forumSection.categories.elementAt(index);

              return Column(
                children: [
                  const Divider(height: 1.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      category.categoryName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 1.0),
                  for (final rule in category.rules)
                    ListTile(
                      title: BBCodeRenderer(content: rule),
                      onTap: () => rulesController.choosenRules.isEmpty
                          ? navigateToCheckout(rule: rule)
                          : rulesController.choosenRules.contains(rule)
                              ? rulesController.removeRule(rule)
                              : rulesController.addRule(rule),
                      onLongPress: rulesController.choosenRules.isEmpty
                          ? () => rulesController.addRule(rule)
                          : null,
                      tileColor: rulesController.choosenRules.contains(rule)
                          ? getColorScheme(context).secondaryContainer
                          : null,
                    ),
                ],
              );
            },
            itemCount: forumSection.categories.length,
          ),
          floatingActionButton: rulesController.choosenRules.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: navigateToCheckout,
                  icon: const Icon(Icons.visibility),
                  label:
                      Text('Просмотр (${rulesController.choosenRules.length})'),
                )
              : null,
        ),
      ),
    );
  }
}
