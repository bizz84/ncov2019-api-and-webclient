import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/key_or_token_preview.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/user_authorization_keys_and_tokens.dart';
import 'package:ncov2019_codewithandrea_web_client/services/cloud_functions_service.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_database.dart';
import 'package:provider/provider.dart';

class AuthorizationKeysPage extends HookWidget {
  Future<void> _regenerateAuthorizationKey(
      BuildContext context, Environment environment) async {
    try {
      final cloudFunctionsService =
          Provider.of<CloudFunctionsService>(context, listen: false);
      cloudFunctionsService.regenerateAuthorizationKey(environment);
    } catch (e) {
      showExceptionAlertDialog(
        context: context,
        title: 'Could not regenerate the authorization key',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keysVisible = useState(false);
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<UserAuthorizationKeysAndTokens>(
      stream: database.userAuthorizationKeysAndTokens(),
      builder: (_, snapshot) {
        final keysAndTokens = snapshot.data;
        final sandboxKey = keysAndTokens?.sandboxKey ?? '';
        final productionKey = keysAndTokens?.productionKey ?? '';
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ShowHideKeysSelector(
                keysVisible: keysVisible.value,
                onVisibleChanged: (visible) => keysVisible.value = visible,
              ),
              SizedBox(height: 16),
              KeyOrTokenPreview(
                key: Key('authorization-key-sandbox'),
                environment: Environment.sandbox,
                isTextVisible: keysVisible.value,
                value: sandboxKey,
                title: 'key',
                ctaText: 'Regenerate',
                onCtaPressed: (environment) =>
                    _regenerateAuthorizationKey(context, environment),
              ),
              SizedBox(height: 32),
              KeyOrTokenPreview(
                key: Key('authorization-key-production'),
                environment: Environment.production,
                isTextVisible: keysVisible.value,
                value: productionKey,
                title: 'key',
                ctaText: 'Regenerate',
                onCtaPressed: (environment) =>
                    _regenerateAuthorizationKey(context, environment),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ShowHideKeysSelector extends StatelessWidget {
  const ShowHideKeysSelector(
      {Key key, @required this.keysVisible, this.onVisibleChanged})
      : super(key: key);
  final bool keysVisible;
  final ValueChanged<bool> onVisibleChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Show keys',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(width: 8),
        Switch.adaptive(value: keysVisible, onChanged: onVisibleChanged)
      ],
    );
  }
}
