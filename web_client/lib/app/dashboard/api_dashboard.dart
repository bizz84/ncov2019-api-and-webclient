import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:firebase_auth_service/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/dashboard_contents.dart';
import 'package:ncov2019_codewithandrea_web_client/constants/keys.dart';
import 'package:ncov2019_codewithandrea_web_client/constants/strings.dart';
import 'package:provider/provider.dart';

class APIDashboard extends StatelessWidget {
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
        title: Text(Strings.apiDashboardHome),
        elevation: 0,
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
      body: DashboardContents(),
    );
  }
}
