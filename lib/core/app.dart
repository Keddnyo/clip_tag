import 'package:flutter/material.dart';

import '../features/rules/controllers/choosen_rules_controller.dart';
import '../shared/constants.dart';
import 'on_generate_route.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChoosenRulesProvider(
      controller: ChoosenRulesController(),
      child: MaterialApp(
        onGenerateRoute: (RouteSettings settings) => onGenerateRoute(settings),
        title: Constants.appName,
        theme: ThemeData(
          useMaterial3: Constants.useMaterial3,
        ),
        darkTheme: ThemeData(
          useMaterial3: Constants.useMaterial3,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}
