import 'package:flutter/material.dart';

class SelectableTextField extends StatelessWidget {
  const SelectableTextField(
      {Key key, @required this.text, this.obscured = false})
      : super(key: key);
  final String text;
  final bool obscured;

  String get textToShow =>
      obscured && text.isNotEmpty ? '********************************' : text;

  @override
  Widget build(BuildContext context) {
    // TODO: Use TextField with obscure argument, disabled input, enabled copy
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.indigo,
          width: 2,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: SelectableText(
        textToShow,
        textAlign: TextAlign.start,
        //maxLines: 3,
        toolbarOptions: ToolbarOptions(
          copy: true,
          selectAll: true,
          cut: false,
          paste: false,
        ),
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
