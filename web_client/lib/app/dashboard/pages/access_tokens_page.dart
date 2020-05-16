import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/key_or_token_preview.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/user_authorization_keys_and_tokens.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_database.dart';
import 'package:ncov2019_codewithandrea_web_client/services/rest_api/api_service.dart';
import 'package:provider/provider.dart';

class AccessTokensPage extends StatelessWidget {
  Future<void> _regenerateAccessToken(
      BuildContext context, String authorizationKey) async {
    try {
      assert(authorizationKey != null);
      final accessToken = await APIService().getAccessToken(authorizationKey);
      print('access token: $accessToken');
    } catch (e) {
      showExceptionAlertDialog(
        context: context,
        title: 'Could not generate the access token',
        exception: e,
      );
    }
  }

  String accessTokenTitle(DateTime expirationDate) {
    if (expirationDate == null) {
      return 'access token';
    }
    final formatter = DateFormat.yMd().add_Hms();
    final formatted = formatter.format(expirationDate);
    return 'access token (expires $formatted)';
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<UserAuthorizationKeysAndTokens>(
        stream: database.userAuthorizationKeysAndTokens(),
        builder: (_, snapshot) {
          final keysAndTokens = snapshot.data;
          final sandboxAccessToken = keysAndTokens?.sandboxAccessToken;
          final productionAccessToken = keysAndTokens?.productionAccessToken;
          final sandboxKey = keysAndTokens?.sandboxKey;
          final productionKey = keysAndTokens?.productionKey;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KeyOrTokenPreview(
                  key: Key('access-token-sandbox'),
                  environment: Environment.sandbox,
                  value: sandboxAccessToken?.accessToken ?? '',
                  title: accessTokenTitle(sandboxAccessToken?.expirationDate),
                  ctaText: 'Reload',
                  isTextVisible: true,
                  onCtaPressed: sandboxKey == null
                      ? null
                      : (environment) =>
                          _regenerateAccessToken(context, sandboxKey),
                ),
                SizedBox(height: 32),
                KeyOrTokenPreview(
                  key: Key('access-token-production'),
                  environment: Environment.production,
                  value: productionAccessToken?.accessToken ?? '',
                  title:
                      accessTokenTitle(productionAccessToken?.expirationDate),
                  ctaText: 'Reload',
                  isTextVisible: true,
                  onCtaPressed: productionKey == null
                      ? null
                      : (environment) =>
                          _regenerateAccessToken(context, productionKey),
                ),
              ],
            ),
          );
        });
  }
}
