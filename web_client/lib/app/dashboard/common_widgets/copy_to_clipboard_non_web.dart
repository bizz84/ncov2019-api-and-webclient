import 'package:flutter/services.dart';

bool copyToClipboardImpl(String text) {
  Clipboard.setData(ClipboardData(text: text));
  return true;
}
