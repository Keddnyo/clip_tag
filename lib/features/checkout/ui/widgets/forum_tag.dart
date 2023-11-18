import 'package:flutter/material.dart';

import '../../../../shared/bbcode_renderer.dart';
import '../../../../shared/constants.dart';
import '../../model/forum_tags.dart';

class ForumTag extends StatelessWidget {
  const ForumTag({super.key, required this.content, required this.tag});

  final String content;
  final ForumTags tag;

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).brightness == Brightness.dark
        ? tag.darkColor
        : tag.lightColor;

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
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  tag.leadingSymbol,
                  style: const TextStyle(color: Colors.white, fontSize: 26.0),
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border.all(color: background),
              ),
              child: Padding(
                padding: margin,
                child: BBCodeRenderer(content),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
