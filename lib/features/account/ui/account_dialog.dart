import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/show_snackbar.dart';

void showAccountDialog(BuildContext context) {
  final auth = FirebaseAuth.instance;
  final firebaseUser = auth.currentUser!;

  void deleteAccount() => auth.currentUser
      ?.delete()
      .whenComplete(Navigator.of(context).pop)
      .catchError(
        (error) => showSnackbar(
            context: context, message: 'Please sign in again and retry'),
      );

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: ListTile(
        title: Text(firebaseUser.displayName!),
        subtitle: Text(firebaseUser.email!),
      ),
      actions: [
        OutlinedButton(
          onPressed: deleteAccount,
          child: const Text('Delete account'),
        ),
        FilledButton.icon(
          onPressed: auth.signOut,
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
        ),
      ],
    ),
  );
}
