import 'package:flutter/material.dart';

import '../shared/constants.dart';
import 'on_generate_route.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings) => onGenerateRoute(settings),
      title: Constants.appName,
      theme: ThemeData(
        useMaterial3: Constants.useMaterial3,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      darkTheme: ThemeData(
        useMaterial3: Constants.useMaterial3,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}
