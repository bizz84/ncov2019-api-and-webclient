import 'dart:html';

// https://github.com/flutter/flutter/issues/33470#issuecomment-537802636
bool copyToClipboardImpl(String text) {
  // add a text area
  final textarea = TextAreaElement();
  document.body.append(textarea);
  textarea.style.border = '0';
  textarea.style.margin = '0';
  textarea.style.padding = '0';
  textarea.style.opacity = '0';
  textarea.style.position = 'absolute';
  textarea.readOnly = true;
  textarea.value = text;
  // select and copy
  textarea.select();
  final result = document.execCommand('copy');
  // remove
  textarea.remove();
  return result;
}
