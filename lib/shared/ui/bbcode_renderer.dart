import 'package:flutter/material.dart';
import 'package:flutter_bbcode/flutter_bbcode.dart';

import '../../utils/open_url.dart';
import 'get_color_scheme.dart';

class BBCodeRenderer extends StatelessWidget {
  const BBCodeRenderer(this.content, {super.key});

  final String content;

  @override
  Widget build(BuildContext context) => BBCodeText(
        data: content.replaceAll('\\n', '\n'),
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
