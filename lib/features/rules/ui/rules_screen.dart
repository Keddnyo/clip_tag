import 'package:flutter/material.dart';

import '../../../shared/ui/bbcode_renderer.dart';
import '../../../utils/get_color_scheme.dart';
import '../../checkout/ui/checkout_screen.dart';
import '../../forum_sections/model/forum_section.dart';
import '../controllers/choosen_rules_controller.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key, required this.forumSection});

  static const String route = '/rules';
  final ForumSection forumSection;

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  @override
  Widget build(BuildContext context) {
    final choosenRulesController = ChoosenRulesProvider.of(context);

    final isChoosenRulesEmpty = choosenRulesController.choosenRules.isEmpty;
    bool isChoosenRulesContainsRule(rule) =>
        choosenRulesController.choosenRules.contains(rule);

    void navigateToCheckout(rules) => Navigator.pushNamed(
          context,
          CheckoutScreen.route,
          arguments: rules,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.forumSection.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final category = widget.forumSection.categories.elementAt(index);

          return Column(
            children: [
              const Divider(height: 1.0),
              Text(category.categoryName),
              const Divider(height: 1.0),
              for (final rule in category.rules)
                ListTile(
                  title: BBCodeRenderer(content: rule),
                  trailing: Checkbox(
                    value: isChoosenRulesContainsRule(rule),
                    onChanged: (isChecked) =>
                        isChecked == true // TODO: Maybe ?? false
                            ? choosenRulesController.removeRule(rule)
                            : choosenRulesController.addRule(rule),
                  ),
                  onTap: () => isChoosenRulesEmpty
                      ? navigateToCheckout(rule)
                      : isChoosenRulesContainsRule(rule)
                          ? choosenRulesController.removeRule(rule)
                          : choosenRulesController.addRule(rule),
                  onLongPress: isChoosenRulesEmpty
                      ? () => choosenRulesController.addRule(rule)
                      : null,
                  tileColor: isChoosenRulesContainsRule(rule)
                      ? getColorScheme(context).secondaryContainer
                      : null,
                ),
            ],
          );
        },
        itemCount: widget.forumSection.categories.length,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          // TODO: Maybe add padding
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: choosenRulesController.clearChoosenRules,
              icon: const Icon(Icons.settings_backup_restore),
              label: const Text('Deselect all'),
            ),
            FilledButton.icon(
              onPressed: () => navigateToCheckout(
                choosenRulesController.choosenRules,
              ),
              icon: const Icon(Icons.visibility),
              label: const Text('Preview'),
            ),
          ],
        ),
      ),
    );
  }
}
