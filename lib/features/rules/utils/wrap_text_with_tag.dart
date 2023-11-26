import '../features/favorites/domain/entity/forum_tags.dart';

String wrapTextWithTag(String content, {required ForumTags tag}) {
  final buffer = StringBuffer();

  buffer
    ..write('[${tag.closure}]')
    ..write('\n')
    ..write(content)
    ..write('\n')
    ..write('[/${tag.closure}]');

  return buffer.toString();
}
