import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/ui/bbcode_renderer.dart';
import '../../../../utils/is_dark_theme.dart';
import '../../model/forum_tags.dart';

class ForumTag extends StatelessWidget {
  const ForumTag({super.key, required this.content, required this.tag});

  final String content;
  final ForumTags tag;

  @override
  Widget build(BuildContext context) {
    final background = isDarkTheme(context) ? tag.darkColor : tag.lightColor;

    const margin = EdgeInsets.all(4.0);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: background,
            width: Constants.tagLeadingSymbolContainerWidth,
            constraints: const BoxConstraints(
              minHeight: Constants.tagLeadingSymbolContainerMinHeight,
            ),
            margin: margin,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                tag.leadingSymbol,
                style: const TextStyle(color: Colors.white, fontSize: 26.0),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border.all(color: background),
            ),
            margin: margin,
            constraints: const BoxConstraints
                .tightFor(), // TODO: Maybe replace with Flexible FlexFit.tight
            child: BBCodeRenderer(content: content),
          ),
        ],
      ),
    );
  }
}
