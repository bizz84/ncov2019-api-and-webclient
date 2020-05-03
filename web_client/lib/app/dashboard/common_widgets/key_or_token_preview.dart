import 'dart:html';

import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/selectable_text_field.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/primary_button.dart';
import 'package:ncov2019_codewithandrea_web_client/platform_web.dart';

class KeyOrTokenPreview extends StatelessWidget {
  const KeyOrTokenPreview({
    Key key,
    @required this.environment,
    @required this.value,
    @required this.title,
    @required this.ctaText,
    @required this.isTextVisible,
    this.onCtaPressed,
  }) : super(key: key);
  final Environment environment;
  final String value;
  final String title;
  final String ctaText;
  final bool isTextVisible;
  final Future<void> Function(Environment) onCtaPressed;

  Map<Environment, String> get environmentKeyName => {
        Environment.sandbox: 'Sandbox $title',
        Environment.production: 'Production $title',
      };

  String get keyToShow =>
      isTextVisible ? value : '********************************';

  void _copyToClipboard(BuildContext context, String text) {
    if (_copyToClipboardHack(text)) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Copied: $text')));
    }
  }

  // https://github.com/flutter/flutter/issues/33470#issuecomment-537802636
  bool _copyToClipboardHack(String text) {
    final textarea = TextAreaElement();
    document.body.append(textarea);
    textarea.style.border = '0';
    textarea.style.margin = '0';
    textarea.style.padding = '0';
    textarea.style.opacity = '0';
    textarea.style.position = 'absolute';
    textarea.readOnly = true;
    textarea.value = text;
    textarea.select();
    final result = document.execCommand('copy');
    textarea.remove();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(environmentKeyName[environment],
            style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 8),
        SelectableTextField(
          text: value,
          obscured: !isTextVisible,
        ),
        SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(),
            if (PlatformWeb.isWeb) ...[
              PrimaryButton(
                text: 'Copy',
                onPressed: () => _copyToClipboard(context, value),
              ),
              SizedBox(width: 16.0),
            ],
            PrimaryButton(
              text: ctaText,
              onPressed:
                  onCtaPressed == null ? null : () => onCtaPressed(environment),
            ),
          ],
        )
      ],
    );
  }
}
