import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/constants.dart';
import '../../../../utils/open_url.dart';
import '../../model/forum_tags.dart';

class CheckoutController with ChangeNotifier {
  final dynamic choosenRules;

  CheckoutController(this.choosenRules);

  int _currentTagIndex = 0;
  int get currentTagIndex => _currentTagIndex;
  void setCurrentTagIndex(int index) {
    _currentTagIndex = index;
    notifyListeners();
  }

  ForumTags get currentForumTag => ForumTags.values[_currentTagIndex];

  String get rulesWithTag {
    final buffer = StringBuffer();

    buffer
      ..write('[${currentForumTag.closure}]\n')
      ..write('$choosenRules\n')
      ..write('[/${currentForumTag.closure}]')
      ..toString();

    return buffer.toString();
  }

  void copyChoosenRules({bool withTag = false}) => Clipboard.setData(
        ClipboardData(text: withTag ? rulesWithTag : choosenRules),
      );

  void sendChoosenRules() async {
    copyChoosenRules(withTag: true);

    if (await DeviceApps.isAppInstalled(Constants.fourpdaClientPackageName)) {
      DeviceApps.openApp(Constants.fourpdaClientPackageName);
    } else {
      openUrl(Constants.fourpdaDefaultUrl);
    }
  }
}
