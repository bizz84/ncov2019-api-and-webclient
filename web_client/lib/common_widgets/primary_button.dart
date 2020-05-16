import 'package:custom_buttons/custom_buttons.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends CustomRaisedButton {
  PrimaryButton({
    Key key,
    String text,
    bool loading = false,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: Colors.indigo,
          textColor: Colors.black87,
          loading: loading,
          onPressed: onPressed,
        );
}
