import 'package:flutter/material.dart';

import '../../../shared/ui/bbcode_renderer.dart';
import '../../../utils/get_color_scheme.dart';
import '../../../utils/open_url.dart';
import '../../checkout/ui/checkout_screen.dart';
import '../../forum_sections/model/forum_section.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key, required this.forumSection});

  static const String route = '/rules';
  final ForumSection forumSection;

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final List _choosenRules = [];

  void addRule(rule) {
    setState(() => _choosenRules.add(rule));
  }

  void removeRule(rule) {
    setState(() => _choosenRules.remove(rule));
  }

  void clearChoosenRules() {
    setState(() => _choosenRules.clear());
  }

  void navigateToCheckout({dynamic rule}) => Navigator.pushNamed(
        context,
        CheckoutScreen.route,
        arguments: widget.forumSection.combineChoosenRulesToString(
          rule != null ? [rule] : _choosenRules,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_choosenRules.isNotEmpty) {
          clearChoosenRules();
          return false;
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.forumSection.title),
          actions: [
            IconButton(
              onPressed: () => openUrl(widget.forumSection.rulesUrl),
              icon: const Icon(Icons.open_in_new),
            )
          ],
          shadowColor: Colors.black,
          centerTitle: true,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            final category = widget.forumSection.categories.elementAt(index);

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
                    trailing: _choosenRules.isNotEmpty
                        ? Checkbox(
                            value: _choosenRules.contains(rule),
                            onChanged: (isChecked) =>
                                _choosenRules.contains(rule)
                                    ? removeRule(rule)
                                    : addRule(rule),
                          )
                        : null,
                    onTap: () => _choosenRules.isEmpty
                        ? navigateToCheckout(rule: rule)
                        : _choosenRules.contains(rule)
                            ? removeRule(rule)
                            : addRule(rule),
                    onLongPress:
                        _choosenRules.isEmpty ? () => addRule(rule) : null,
                    tileColor: _choosenRules.contains(rule)
                        ? getColorScheme(context).secondaryContainer
                        : null,
                  ),
              ],
            );
          },
          itemCount: widget.forumSection.categories.length,
        ),
        bottomNavigationBar: _choosenRules.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 1.0),
                  BottomAppBar(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: clearChoosenRules,
                          icon: const Icon(
                              Icons.indeterminate_check_box_outlined),
                          label: const Text('Сброс'),
                        ),
                        FilledButton.icon(
                          onPressed: () => navigateToCheckout(),
                          icon: const Icon(Icons.visibility),
                          label: Text('Предпросмотр (${_choosenRules.length})'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
