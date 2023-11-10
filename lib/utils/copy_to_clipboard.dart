import 'package:flutter/services.dart';

void copyToClipboard(String content) => Clipboard.setData(
      ClipboardData(text: content),
    );
