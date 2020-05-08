import 'copy_to_clipboard_stub.dart'
    if (dart.library.html) 'copy_to_clipboard_web.dart'
    if (dart.library.io) 'copy_to_clipboard_non_web.dart';

bool copyToClipboard(String text) => copyToClipboardImpl(text);
