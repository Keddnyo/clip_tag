import 'package:flutter/material.dart';

import '../../../shared/bbcode_renderer.dart';
import '../controllers/sections_controller.dart';
import '../utils/get_forum_section_icon.dart';

class ForumSectionsScreen extends StatelessWidget {
  const ForumSectionsScreen({super.key});

  static const String route = '/forum_sections';

  @override
  Widget build(BuildContext context) {
    final sectionsController = ForumSectionsController(context: context);
    final scrollController = ScrollController();

    return ListenableBuilder(
      listenable: sectionsController,
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            sectionsController.sections.isNotEmpty
                ? sectionsController.section!.title
                : 'ClipTag',
          ),
        ),
        body: sectionsController.sections.isNotEmpty
            ? ListView(
                controller: scrollController,
                children: [
                  for (final category in sectionsController.section!.categories)
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
                            onTap: () => sectionsController.navigateToCheckout(
                              rule: rule,
                            ),
                          ),
                      ],
                    ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
        endDrawer: sectionsController.sections.isNotEmpty
            ? NavigationDrawer(
                onDestinationSelected: (index) {
                  sectionsController.setSectionIndex(index);
                  sectionsController.clearChoosenRules();
                  Navigator.pop(context);
                  scrollController.jumpTo(0);
                },
                selectedIndex: sectionsController.sectionIndex,
                children: sectionsController.sections
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
      ),
    );
  }
}
