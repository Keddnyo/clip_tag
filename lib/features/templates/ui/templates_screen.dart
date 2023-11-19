import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/bbcode_renderer.dart';
import '../../../shared/ui/loading_circle.dart';
import '../../../utils/show_snackbar.dart';
import '../../checkout/ui/checkout_screen.dart';
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
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingCircle();
          }

          if (snapshot.data?.docs.isEmpty == true) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cut, size: 64.0),
                  SizedBox(height: 8.0),
                  Text('Добавьте заготовки', style: TextStyle(fontSize: 20.0)),
                ],
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map(
              (doc) {
                final template = Template.fromModel(
                  TemplateModel.fromJson(doc.data()),
                );

                return Dismissible(
                  key: ValueKey(template),
                  onDismissed: (_) {
                    doc.reference.delete();
                    showSnackbar(
                      context: context,
                      message: 'Заготовка удалена',
                    );
                  },
                  direction: DismissDirection.endToStart,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 0.5,
                      ),
                    ),
                    child: ListTile(
                      title: BBCodeRenderer(template.content),
                      onTap: () => Navigator.pushNamed(
                        context,
                        CheckoutScreen.route,
                        arguments: template.content,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
