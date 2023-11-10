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
        title: const Text('Email Verification'),
      ),
      body: Stack(
        children: [
          const LinearProgressIndicator(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'The confirmation link sent to ${_firebaseUser!.email}',
                // TODO: textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
