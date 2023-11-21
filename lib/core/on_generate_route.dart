import 'package:flutter/material.dart';

import '../features/auth/ui/auth_screen.dart';
import '../features/auth/ui/controllers/auth_screen_controller.dart';
import '../features/auth/ui/email_verification_screen.dart';
import '../features/checkout/ui/checkout_screen.dart';
import '../features/favorites/ui/favorites_screen.dart';
import '../features/forum_sections/ui/forum_sections_screen.dart';
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
                : snapshot.data?.emailVerified == false
                    ? const EmailVerificationScreen()
                    : settings.name == FavoritesScreen.route
                        ? const FavoritesScreen()
                        : settings.name == CheckoutScreen.route
                            ? CheckoutScreen(
                                choosenRules: settings.arguments as String,
                              )
                            : const ForumSectionsScreen(),
          ),
        );
      },
    );
