import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/selectable_text_field_with_actions.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/primary_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return SelectableTextFieldWithActions(
      title: environmentKeyName[environment],
      value: value,
      isTextVisible: isTextVisible,
      customActionBuilder: (context) => PrimaryButton(
        text: ctaText,
        onPressed:
            onCtaPressed == null ? null : () => onCtaPressed(environment),
      ),
    );
  }
}
