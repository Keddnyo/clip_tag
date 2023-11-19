import 'package:flutter/material.dart';

import '../shared/constants.dart';
import 'on_generate_route.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        onGenerateRoute: (RouteSettings settings) => onGenerateRoute(settings),
        title: Constants.appName,
        theme: ThemeData(useMaterial3: Constants.useMaterial3),
        darkTheme: ThemeData(
          useMaterial3: Constants.useMaterial3,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(color: Colors.black),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Colors.black,
          ),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Colors.black,
          ),
        ),
      );
}
