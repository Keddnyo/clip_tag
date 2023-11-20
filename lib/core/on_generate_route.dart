import 'package:flutter/material.dart';

import '../features/auth/ui/auth_screen.dart';
import '../features/auth/ui/controllers/auth_screen_controller.dart';
import '../features/auth/ui/email_verification_screen.dart';
import '../features/checkout/ui/checkout_screen.dart';
import '../features/forum_sections/ui/forum_sections_screen.dart';
import '../features/templates/ui/templates_screen.dart';
import '../shared/firebase/firebase_auth_provider.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) => MaterialPageRoute(
      builder: (context) {
        final controller = FirebaseController();

        return FirebaseProvider(
          controller: controller,
          child: StreamBuilder(
            stream: controller.userChanges,
            builder: (context, snapshot) => !controller.isUserSignedIn
                ? AuthScreenProvider(
                    controller: AuthScreenController(),
                    child: const AuthScreen(),
                  )
                : !controller.isEmailVerified
                    ? const EmailVerificationScreen()
                    : settings.name == TemplatesScreen.route
                        ? const TemplatesScreen()
                        : settings.name == CheckoutScreen.route
                            ? CheckoutScreen(
                                choosenRules: settings.arguments as String,
                              )
                            : const ForumSectionsScreen(),
          ),
        );
      },
    );
