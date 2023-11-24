import 'package:flutter/material.dart';

import '../features/auth/ui/auth_screen.dart';
import '../features/auth/ui/controllers/auth_screen_controller.dart';
import '../features/auth/ui/email_verification_screen.dart';
import '../features/rules/ui/controllers/rules_controller.dart';
import '../features/rules/ui/rules_screen.dart';
import '../shared/firebase/firebase_controller.dart';

Route<dynamic>? onGenerateRoute(_) => MaterialPageRoute(
      builder: (_) {
        final firebase = FirebaseController();

        return FirebaseProvider(
          controller: firebase,
          child: StreamBuilder(
            stream: firebase.userChanges,
            builder: (_, snapshot) => !snapshot.hasData
                ? AuthScreenProvider(
                    controller: AuthScreenController(),
                    child: const AuthScreen(),
                  )
                : snapshot.data?.isAnonymous == false &&
                        snapshot.data?.emailVerified == false
                    ? const EmailVerificationScreen()
                    : RulesProvider(
                        controller: RulesController(firebase: firebase),
                        child: const RulesScreen(),
                      ),
          ),
        );
      },
    );
