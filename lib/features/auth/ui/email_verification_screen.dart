import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser?.sendEmailVerification();

    Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        FirebaseAuth.instance.currentUser?.reload().then(
          (_) {
            if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
              timer.cancel();
            }
          },
        );
      },
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
                    'Ссылка для потверждения отправлена по адресу "${FirebaseAuth.instance.currentUser?.email}".\n\nПосле перехода по ссылке, данная страница закроется автоматически.',
                    style: const TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  FilledButton(
                    onPressed: FirebaseAuth.instance.signOut,
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
