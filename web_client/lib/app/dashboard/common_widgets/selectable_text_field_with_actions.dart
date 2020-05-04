import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/copy_to_clipboard.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/selectable_text_field.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/primary_button.dart';

class SelectableTextFieldWithActions extends StatelessWidget {
  const SelectableTextFieldWithActions({
    Key key,
    @required this.title,
    @required this.value,
    this.isTextVisible = true,
    this.showCopyAction = true,
    this.customActionBuilder,
  }) : super(key: key);
  final String title;
  final String value;
  final bool isTextVisible;
  final bool showCopyAction;
  final WidgetBuilder customActionBuilder;

  String get keyToShow =>
      isTextVisible ? value : '********************************';

  void _copyToClipboard(BuildContext context, String text) {
    if (copyToClipboard(text)) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Copied: $text')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headline6),
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
            if (showCopyAction)
              PrimaryButton(
                text: 'Copy',
                onPressed: () => _copyToClipboard(context, value),
              ),
            if (customActionBuilder != null) ...[
              SizedBox(width: 16.0),
              customActionBuilder(context),
            ]
          ],
        )
      ],
    );
  }
}
