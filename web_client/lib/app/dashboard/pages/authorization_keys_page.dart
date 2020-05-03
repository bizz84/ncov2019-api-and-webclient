import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/selectable_text_field.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/user_authorization_keys.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/primary_button.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/show_exception_alert_dialog.dart';
import 'package:ncov2019_codewithandrea_web_client/services/cloud_functions_service.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_database.dart';
import 'package:provider/provider.dart';

class AuthorizationKeysPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final keysVisible = useState(false);
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<UserAuthorizationKeys>(
      stream: database.userAuthorizationKeys(),
      builder: (_, snapshot) {
        final authKeys = snapshot.data;
        final sandboxKey = authKeys?.sandboxKey ?? '';
        final productionKey = authKeys?.productionKey ?? '';
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AuthorizationKeyPreview(
                environment: Environment.sandbox,
                isKeyVisible: keysVisible.value,
                authorizationKey: sandboxKey,
              ),
              SizedBox(height: 32),
              AuthorizationKeyPreview(
                environment: Environment.production,
                isKeyVisible: keysVisible.value,
                authorizationKey: productionKey,
              ),
              SizedBox(height: 16),
              ShowHideKeysSelector(
                keysVisible: keysVisible.value,
                onVisibleChanged: (visible) => keysVisible.value = visible,
              ),
            ],
          ),
        );
      },
    );
  }
}

class AuthorizationKeyPreview extends StatelessWidget {
  const AuthorizationKeyPreview({
    Key key,
    @required this.environment,
    @required this.authorizationKey,
    @required this.isKeyVisible,
  }) : super(key: key);
  final Environment environment;
  final String authorizationKey;
  final bool isKeyVisible;

  Future<void> _regenerateKey(BuildContext context) async {
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

  static Map<Environment, String> environmentKeyName = {
    Environment.sandbox: 'Sandbox key',
    Environment.production: 'Production key',
  };

  // TODO: Use TextField with obscure argument, disabled input, enabled copy
  String get keyToShow =>
      isKeyVisible ? authorizationKey : '********************************';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(environmentKeyName[environment],
            style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SelectableTextField(
                text: authorizationKey,
                obscured: !isKeyVisible,
              ),
            ),
            SizedBox(width: 16.0),
            PrimaryButton(
              text: 'Regenerate',
              onPressed: () => _regenerateKey(context),
            ),
          ],
        )
      ],
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
