import 'package:flutter/material.dart';

bool isDarkTheme(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;
