import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late User? _firebaseUser;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _firebaseUser = FirebaseAuth.instance.currentUser;

    _firebaseUser?.sendEmailVerification();

    _timer = Timer.periodic(
      Constants.emailVerificationTimerRefreshRate,
      (timer) {
        _firebaseUser?.reload();
        if (_firebaseUser?.emailVerified == true) {
          timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание аккаунта'),
      ),
      body: Stack(
        children: [
          const LinearProgressIndicator(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Ссылка отправлена по адресу: "${_firebaseUser!.email}"',
                style: const TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: FirebaseAuth.instance.currentUser?.delete,
        icon: const Icon(Icons.cancel_outlined),
        label: const Text('Отмена'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
