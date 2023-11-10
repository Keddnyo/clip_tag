import 'package:flutter/material.dart' as material show showAboutDialog;
import 'package:flutter/material.dart';

import '../shared/constants.dart';

void showAboutDialog(context) => material.showAboutDialog(
      context: context,
      applicationName: Constants.appName,
      applicationVersion: 'Формирование тегов с правилами для 4PDA',
      applicationIcon: Image.asset('lib/core/assets/app_icon.png',
          width: 72.0, height: 72.0),
      applicationLegalese: Constants.applicationLegalese,
    );
