import 'package:flutter/cupertino.dart';

class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    @required this.header,
    @required this.value,
    @required this.children,
    this.onValueChanged,
  });
  final Widget header;
  final T value;
  final Map<T, Widget> children;
  final ValueChanged<T> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        header,
        SizedBox(height: 8.0),
        CupertinoSegmentedControl<T>(
          children: children,
          groupValue: value,
          onValueChanged: onValueChanged,
        ),
      ],
    );
  }
}
