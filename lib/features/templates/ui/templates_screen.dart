import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/bbcode_renderer.dart';
import '../../../shared/ui/loading_circle.dart';
import '../../../utils/get_color_scheme.dart';
import '../../../utils/show_snackbar.dart';
import '../../checkout/ui/checkout_screen.dart';
import '../data/model/template_model.dart';
import '../domain/entity/template.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  static const String route = '/templates';

  @override
  Widget build(BuildContext context) {
    final colorScheme = getColorScheme(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заготовки'),
        shadowColor: Colors.black,
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
                  TemplateModel.fromMap(doc.data()),
                );

                return Dismissible(
                  key: ValueKey(template),
                  background: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      alignment: Alignment.centerRight,
                      color: colorScheme.error,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.delete, color: colorScheme.onError),
                      ),
                    ),
                  ),
                  onDismissed: (_) {
                    doc.reference.delete();
                    showSnackbar(
                      context: context,
                      message: 'Заготовка удалена',
                    );
                  },
                  direction: DismissDirection.endToStart,
                  child: Container(
                    margin: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.onBackground,
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
