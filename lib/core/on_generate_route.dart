import 'package:flutter/material.dart';

import '../features/auth/ui/auth_screen.dart';
import '../features/auth/ui/controllers/auth_screen_controller.dart';
import '../features/auth/ui/email_verification_screen.dart';
import '../features/rules/ui/rules_screen.dart';
import '../shared/firebase/firebase_controller.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) => MaterialPageRoute(
      builder: (context) {
        final controller = FirebaseController();

        return FirebaseProvider(
          controller: controller,
          child: StreamBuilder(
            stream: controller.userChanges,
            builder: (context, snapshot) => !snapshot.hasData
                ? AuthScreenProvider(
                    controller: AuthScreenController(),
                    child: const AuthScreen(),
                  )
                : snapshot.data?.isAnonymous == false &&
                        snapshot.data?.emailVerified == false
                    ? const EmailVerificationScreen()
                    : RulesScreenProvider(
                        controller: RulesScreenController(),
                        child: const RulesScreen(),
                      ),
          ),
        );
      },
    );
