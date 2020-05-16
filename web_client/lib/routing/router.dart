import 'package:email_password_sign_in_ui/email_password_sign_in_ui.dart';
import 'package:flutter/material.dart';

class Routes {
  static const emailPasswordSignInPage = '/email-password-sign-in-page';
}

class Router {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.emailPasswordSignInPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmailPasswordSignInPage(onSignedIn: args),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}
