import 'dart:math';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:firebase_auth_service/firebase_auth_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_sign_in_service/google_sign_in_service.dart';
import 'package:ncov2019_codewithandrea_web_client/app/sign_in/sign_in_view_model.dart';
import 'package:ncov2019_codewithandrea_web_client/app/sign_in/sign_in_button.dart';
import 'package:ncov2019_codewithandrea_web_client/app/sign_in/social_sign_in_button.dart';
import 'package:ncov2019_codewithandrea_web_client/constants/keys.dart';
import 'package:ncov2019_codewithandrea_web_client/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/routing/router.dart';
import 'package:provider/provider.dart';

class SignInPageBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    final googleSignInService =
        Provider.of<GoogleSignInService>(context, listen: false);
    return ChangeNotifierProvider<SignInViewModel>(
      create: (_) => SignInViewModel(
          authService: authService, googleSignInService: googleSignInService),
      child: Consumer<SignInViewModel>(
        builder: (_, SignInViewModel viewModel, __) => SignInPage._(
          viewModel: viewModel,
          title: Strings.apiDashboardHome,
        ),
      ),
    );
  }
}

class SignInPage extends HookWidget {
  const SignInPage._({Key key, this.viewModel, this.title}) : super(key: key);
  final SignInViewModel viewModel;
  final String title;

  static const Key emailPasswordButtonKey = Key(Keys.emailPassword);
  static const Key anonymousButtonKey = Key(Keys.anonymous);

  Future<void> _showSignInError(BuildContext context, dynamic exception) async {
    await showExceptionAlertDialog(
      context: context,
      title: Strings.signInFailed,
      exception: exception,
    );
  }

  Future<void> _signInWithGoogle(
      BuildContext context, ValueNotifier<bool> isLoading) async {
    try {
      isLoading.value = true;
      await viewModel.signInWithGoogle();
    } catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _showEmailPasswordSignInPage(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.pushNamed(
      Routes.emailPasswordSignInPage,
      arguments: () => navigator.pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(title),
      ),
      backgroundColor: Colors.grey[200],
      body: _buildSignIn(context),
    );
  }

  Widget _buildHeader() {
    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      Strings.signIn,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    final isLoading = useState(false);
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: min(constraints.maxWidth, 600),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 32.0),
              SizedBox(
                height: 50.0,
                child: _buildHeader(),
              ),
              SizedBox(height: 32.0),
              SocialSignInButton(
                assetName: 'assets/go-logo.png',
                text: Strings.signInWithGoogle,
                onPressed: isLoading.value
                    ? null
                    : () => _signInWithGoogle(context, isLoading),
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Text(
                Strings.or,
                style: TextStyle(fontSize: 14.0, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              SignInButton(
                key: emailPasswordButtonKey,
                text: Strings.signInWithEmailPassword,
                onPressed: viewModel.isLoading
                    ? null
                    : () => _showEmailPasswordSignInPage(context),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
              ),
              // SizedBox(height: 8),
              // SignInButton(
              //   key: anonymousButtonKey,
              //   text: Strings.goAnonymous,
              //   color: Theme.of(context).primaryColor,
              //   textColor: Colors.white,
              //   onPressed: viewModel.isLoading
              //       ? null
              //       : () => _signInAnonymously(context),
              // ),
            ],
          ),
        );
      }),
    );
  }
}
