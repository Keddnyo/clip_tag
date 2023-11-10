import 'package:flutter/material.dart' as material show showAboutDialog;

import '../shared/constants.dart';

void showAboutDialog(context) => material.showAboutDialog(
      context: context,
      applicationName: Constants.appName,
      applicationVersion: '4PDA forum rules tag builder utility',
      applicationLegalese: Constants.applicationLegalese,
    );
