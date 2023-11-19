import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/bbcode_renderer.dart';
import '../../../shared/ui/loading_circle.dart';
import '../data/model/template_model.dart';
import '../domain/entity/template.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  static const String route = '/templates';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заготовки'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('templates')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingCircle();
          }

          final templates = snapshot.data!.docs
              .map(
                (doc) => Template.fromModel(TemplateModel.fromJson(doc.data())),
              )
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          const radius = Radius.circular(16.0);

          return ListView.builder(
            reverse: true,
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.only(
                    topLeft: radius, topRight: radius, bottomLeft: radius),
              ),
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BBCodeRenderer(templates[index].template),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(templates[index].date),
                    ),
                  ),
                ],
              ),
            ),
            itemCount: templates.length,
          );
        },
      ),
    );
  }
}
