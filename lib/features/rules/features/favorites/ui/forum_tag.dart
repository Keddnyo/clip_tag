import 'package:flutter/material.dart';

import '../../../../../shared/ui/bbcode_renderer.dart';
import '../domain/entity/forum_tags.dart';

class ForumTag extends StatelessWidget {
  const ForumTag({
    super.key,
    required this.content,
    required this.tag,
    this.isTagVisible = true,
  });

  final String content;
  final ForumTags tag;
  final bool isTagVisible;

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).brightness == Brightness.dark
        ? tag.darkColor
        : tag.lightColor;

    const margin = EdgeInsets.all(4.0);

    final bbcodeContent = Padding(
      padding: margin,
      child: BBCodeRenderer(content),
    );

    return isTagVisible
        ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: background,
                  width: 48.0,
                  constraints: const BoxConstraints(minHeight: 48.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        tag.leadingSymbol,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isTagVisible ? background : Colors.black12,
                      ),
                    ),
                    child: bbcodeContent,
                  ),
                ),
              ],
            ),
          )
        : bbcodeContent;
  }
}
