import 'package:url_launcher/url_launcher.dart';

class Constants {
  static const String appLanguageCode = 'ru';

  static const String appName = 'ClipTag';
  static const bool useMaterial3 = true;

  static const Duration emailVerificationTimerRefreshRate =
      Duration(seconds: 2);

  static const double tagLeadingSymbolContainerMinHeight = 48.0;
  static const double tagLeadingSymbolContainerWidth = 48.0;

  static const LaunchMode urlLaunchMode = LaunchMode.externalApplication;
  static const String fourpdaDefaultUrl =
      'https://4pda.to/forum/index.php?act=idx';

  static const String applicationLegalese =
      'Copyright (c) 2023 Timur Zhdikhanov';
}
