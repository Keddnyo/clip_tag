import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide showAboutDialog;

import '../../../core/about_dialog.dart';
import '../../../shared/constants.dart';
import '../../account/ui/account_dialog.dart';
import '../../rules/ui/rules_screen.dart';
import '../model/forum_section.dart';

class ForumSectionsScreen extends StatelessWidget {
  const ForumSectionsScreen({super.key});

  static const String route = '/forum_sections';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        actions: [
          IconButton(
            onPressed: () => showAccountDialog(context),
            icon: const Icon(Icons.account_circle_outlined),
          ),
          IconButton(
            onPressed: () => showAboutDialog(context),
            icon: const Icon(Icons.info_outlined),
          ),
        ],
        shadowColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('rules').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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

          return ListView.separated(
            itemBuilder: (context, index) {
              final section = forumSectionList.elementAt(index);

              return ListTile(
                leading: const Icon(Icons.arrow_forward),
                title: Text(
                  section.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: section.edition != null
                    ? Text('Edition of ${section.editionDateAsString!}')
                    : null,
                onTap: () => Navigator.pushNamed(
                  context,
                  RulesScreen.route,
                  arguments: section,
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: forumSectionList.length,
          );
        },
      ),
    );
  }
}
