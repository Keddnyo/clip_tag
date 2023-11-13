import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/app.dart';
import 'core/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}
