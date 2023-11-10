import 'package:url_launcher/url_launcher.dart';

import '../shared/constants.dart';

void openUrl(String url) =>
    launchUrl(Uri.parse(url), mode: Constants.urlLaunchMode);
