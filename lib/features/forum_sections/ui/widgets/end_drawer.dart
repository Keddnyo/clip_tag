part of '../forum_sections_screen.dart';

class MainEndDrawer extends StatelessWidget {
  const MainEndDrawer({
    super.key,
    required this.sections,
    required this.sectionIndex,
    required this.onDestinationSelected,
  });

  final List<ForumSection> sections;
  final int sectionIndex;
  final Function(int index) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (index) => onDestinationSelected(index),
      selectedIndex: sectionIndex,
      tilePadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      children: sections
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
    );
  }
}
