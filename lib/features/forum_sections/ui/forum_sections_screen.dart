import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../rules/ui/rules_screen.dart';
import '../model/forum_section.dart';

class ForumSectionsScreen extends StatelessWidget {
  const ForumSectionsScreen({super.key});

  static const String route = '/forum_sections';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(Constants.appName),
          actions: [
            IconButton(
              onPressed: () => showAboutDialog(
                context: context,
                applicationName: Constants.appName,
                applicationVersion: 'Агрегатор правил 4PDA',
                applicationIcon: Image.asset('lib/core/assets/app_icon.png',
                    width: 72.0, height: 72.0),
                applicationLegalese: Constants.applicationLegalese,
              ),
              icon: const Icon(Icons.info_outlined),
            ),
          ],
          shadowColor: Colors.black,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('rules').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(snapshot.error.toString()),
                ),
              );
            }

            final forumSectionList = snapshot.data!.docs
                .map((section) => ForumSection.decode(section.data()))
                .toList()
              ..sort((a, b) => a.order.compareTo(b.order));

            return ListView(
              children: forumSectionList
                  .map(
                    (section) => ListTile(
                      leading: Icon(
                        section.order == 0
                            ? Icons.menu_book
                            : section.title.contains('Android')
                                ? Icons.android
                                : section.title.contains('Apple') ||
                                        section.title.contains('iOS')
                                    ? Icons.apple
                                    : Icons.double_arrow,
                      ),
                      title: Text(section.title),
                      onTap: () => Navigator.pushNamed(
                          context, RulesScreen.route,
                          arguments: section),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      );
}
