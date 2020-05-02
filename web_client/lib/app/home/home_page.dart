import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/show_alert_dialog.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/show_exception_alert_dialog.dart';
import 'package:ncov2019_codewithandrea_web_client/constants/keys.dart';
import 'package:ncov2019_codewithandrea_web_client/constants/strings.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      await showExceptionAlertDialog(
        context: context,
        title: Strings.logoutFailed,
        exception: e,
      );
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: Strings.logout,
          content: Strings.logoutAreYouSure,
          cancelActionText: Strings.cancel,
          defaultActionText: Strings.logout,
        ) ??
        false;
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.homePage),
        actions: <Widget>[
          FlatButton(
            key: Key(Keys.logout),
            child: Text(
              Strings.logout,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
