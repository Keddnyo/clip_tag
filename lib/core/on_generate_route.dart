import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/auth/ui/auth_screen.dart';
import '../features/auth/ui/email_verification_screen.dart';
import '../features/checkout/ui/checkout_screen.dart';
import '../features/forum_sections/model/forum_section.dart';
import '../features/forum_sections/ui/forum_sections_screen.dart';
import '../features/rules/ui/rules_screen.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  final route = settings.name;
  final arguments = settings.arguments;

  return MaterialPageRoute(
    builder: (context) => StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const AuthScreen();
        }

        if (route == CheckoutScreen.route) {
          final rules = arguments as dynamic;
          return CheckoutScreen(choosenRules: rules);
        }

        if (route == RulesScreen.route) {
          final forumSetion = arguments as ForumSection;
          return RulesScreen(forumSection: forumSetion);
        }

        if (!snapshot.data!.emailVerified) {
          return const EmailVerificationScreen();
        }

        return const ForumSectionsScreen();
      },
    ),
  );
}
