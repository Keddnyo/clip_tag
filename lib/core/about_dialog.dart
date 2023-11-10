import 'package:flutter/material.dart' as material show showAboutDialog;

import '../shared/constants.dart';

void showAboutDialog(context) => material.showAboutDialog(
      context: context,
      applicationName: Constants.appName,
      applicationVersion: 'Формирование тегов с правилами для 4PDA',
      applicationLegalese: Constants.applicationLegalese,
    );
