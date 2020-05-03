import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/key_or_token_preview.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/user_authorization_keys_and_tokens.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/show_exception_alert_dialog.dart';
import 'package:ncov2019_codewithandrea_web_client/services/cloud_functions_service.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_database.dart';
import 'package:provider/provider.dart';

class AccessTokensPage extends StatelessWidget {
  Future<void> _regenerateAccessToken(
      BuildContext context, String authorizationKey) async {
    try {
      final cloudFunctionsService =
          Provider.of<CloudFunctionsService>(context, listen: false);
      cloudFunctionsService.regenerateAccessToken(authorizationKey);
    } catch (e) {
      showExceptionAlertDialog(
        context: context,
        title: 'Could not regenerate the authorization key',
        exception: e,
      );
    }
  }

  // TODO: Show access tokens
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<UserAuthorizationKeysAndTokens>(
        stream: database.userAuthorizationKeysAndTokens(),
        builder: (_, snapshot) {
          final keysAndTokens = snapshot.data;
          final sandboxAccessToken = keysAndTokens?.sandboxAccessToken ?? '';
          final productionAccessToken =
              keysAndTokens?.productionAccessToken ?? '';
          final sandboxKey = keysAndTokens?.sandboxKey ?? '';
          final productionKey = keysAndTokens?.productionKey ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KeyOrTokenPreview(
                  environment: Environment.sandbox,
                  value: sandboxAccessToken,
                  title: 'access token',
                  ctaText: 'Reload',
                  isTextVisible: true,
                  onCtaPressed: (environment) =>
                      _regenerateAccessToken(context, sandboxKey),
                ),
                SizedBox(height: 32),
                KeyOrTokenPreview(
                  environment: Environment.production,
                  value: productionAccessToken,
                  title: 'access token',
                  ctaText: 'Reload',
                  isTextVisible: true,
                  onCtaPressed: (environment) =>
                      _regenerateAccessToken(context, productionKey),
                ),
              ],
            ),
          );
        });
  }
}
