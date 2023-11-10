import 'package:flutter/material.dart';
import 'package:flutter_bbcode/flutter_bbcode.dart';

import '../../utils/get_color_scheme.dart';
import '../../utils/open_url.dart';

class BBCodeRenderer extends StatelessWidget {
  const BBCodeRenderer({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return BBCodeText(
      data: content,
      stylesheet: BBStylesheet(
        tags: [
          BoldTag(),
          ItalicTag(),
          UnderlineTag(),
          StrikeThroughTag(),
          ColorTag(),
          UrlTag(onTap: (url) => openUrl(url)),
          ImgTag(),
        ],
        defaultText: TextStyle(
          color: getColorScheme(context).onSurface,
          fontSize: 15.0,
        ),
      ),
    );
  }
}
