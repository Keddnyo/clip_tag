import 'dart:async';

import 'package:flutter/material.dart';

import '../../../shared/firebase/firebase_controller.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseProvider.of(context);

    firebase.sendEmailVerification();

    Timer.periodic(
      const Duration(seconds: 2),
      (timer) => firebase.userReload().then(
        (_) {
          if (firebase.isEmailVerified) {
            timer.cancel();
          }
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Подтвердите почту'),
      ),
      body: Stack(
        children: [
          const LinearProgressIndicator(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ссылка отправлена по адресу "${firebase.userEmail}".',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  FilledButton(
                    onPressed: firebase.signOut,
                    child: const Text('Отмена'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
