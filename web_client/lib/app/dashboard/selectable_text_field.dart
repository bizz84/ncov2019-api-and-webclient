import 'package:flutter/material.dart';

class SelectableTextField extends StatelessWidget {
  const SelectableTextField({Key key, this.text, this.obscured})
      : super(key: key);
  final String text;
  final bool obscured;

  String get textToShow => obscured ? '********************************' : text;

  @override
  Widget build(BuildContext context) {
    // TODO: Use TextField with obscure argument, disabled input, enabled copy
    return Container(
      //width: double.infinity,
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
      alignment: Alignment.center,
      child: SelectableText(
        textToShow,
        textAlign: TextAlign.start,
        maxLines: 3,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
