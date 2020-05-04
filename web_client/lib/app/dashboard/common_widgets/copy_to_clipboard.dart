import 'copy_to_clipboard_stub.dart'
    if (dart.library.html) 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/copy_to_clipboard_web.dart'
    if (dart.library.io) 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/copy_to_clipboard_non_web.dart';

bool copyToClipboard(String text) => copyToClipboardImpl(text);
