import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/selectable_text_field_with_actions.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/primary_button.dart';

class KeyOrTokenPreview extends HookWidget {
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

  Future<void> _ctaPressed(ValueNotifier<bool> loading) async {
    try {
      loading.value = true;
      await onCtaPressed(environment);
    } finally {
      loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);
    return SelectableTextFieldWithActions(
      title: environmentKeyName[environment],
      value: value,
      isTextVisible: isTextVisible,
      customActionBuilder: (context) => PrimaryButton(
        loading: loading.value,
        text: ctaText,
        onPressed: onCtaPressed == null ? null : () => _ctaPressed(loading),
      ),
    );
  }
}
