import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../utils/show_snackbar.dart';

void showAccountDialog(BuildContext context) {
  final auth = FirebaseAuth.instance;
  final firebaseUser = auth.currentUser!;

  void deleteAccount() {
    auth.currentUser?.delete().then((_) {
      showSnackbar(
        context: context,
        message: 'Аккаунт удалён.',
      );
    }).catchError((error) {
      showSnackbar(
        context: context,
        message: 'Авторизуйтесь заново и повторите попытку.',
      );
    });
    Navigator.of(context).pop();
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('${Constants.appName} ID'),
      content: ListTile(
        leading: const Icon(Icons.account_circle_outlined),
        title: Text(firebaseUser.displayName!),
        subtitle: Text(firebaseUser.email!),
      ),
      actions: [
        OutlinedButton(
          onPressed: deleteAccount,
          child: const Text('Удалить аккаунт'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            auth.signOut();
          },
          child: const Text('Выход'),
        ),
      ],
    ),
  );
}
