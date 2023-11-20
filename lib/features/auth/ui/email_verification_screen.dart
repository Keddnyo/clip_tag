import 'package:flutter/material.dart';

import '../../../shared/firebase/firebase_controller.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseProvider.of(context);

    firebase.sendEmailVerification();

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
                    'Ссылка для потверждения отправлена по адресу "${firebase.userEmail}".\n\nПосле перехода по ссылке, данная страница закроется автоматически.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  FilledButton(
                    onPressed: firebase.deleteAccount,
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
