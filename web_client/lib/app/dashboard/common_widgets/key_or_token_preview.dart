import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/selectable_text_field.dart';
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

  // TODO: Use TextField with obscure argument, disabled input, enabled copy
  String get keyToShow =>
      isTextVisible ? value : '********************************';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(environmentKeyName[environment],
            style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SelectableTextField(
                text: value,
                obscured: !isTextVisible,
              ),
            ),
            SizedBox(width: 16.0),
            PrimaryButton(
              text: ctaText,
              onPressed: () => onCtaPressed(environment),
            ),
          ],
        )
      ],
    );
  }
}
