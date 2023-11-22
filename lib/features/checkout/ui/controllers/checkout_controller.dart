import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';
import '../../../../utils/copy_to_clipboard.dart';
import '../../../../utils/open_url.dart';
import '../../model/forum_tags.dart';

class CheckoutController with ChangeNotifier {
  final String choosenRules;

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
      ..write('[/${currentForumTag.closure}]');

    return buffer.toString();
  }

  void sendChoosenRules() {
    copyToClipboard(rulesWithTag).then(
      (_) => DeviceApps.isAppInstalled(Constants.fourpdaClientPackageName).then(
          (isAppInstalled) => isAppInstalled
              ? DeviceApps.openApp(Constants.fourpdaClientPackageName)
              : openUrl(Constants.fourpdaDefaultUrl)),
    );
  }
}
