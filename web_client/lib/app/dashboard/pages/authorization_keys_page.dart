import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/user_authorization_keys.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/primary_button.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/segmented_control.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_database.dart';
import 'package:provider/provider.dart';

class AuthorizationKeysPage extends StatelessWidget {
  // TODO: Hook up keys visible with hooks
  @override
  Widget build(BuildContext context) {
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
                authorizationKey: sandboxKey,
              ),
              SizedBox(height: 16),
              AuthorizationKeyPreview(
                environment: Environment.production,
                authorizationKey: productionKey,
              ),
              SizedBox(height: 16),
              ShowHideKeysSelector(
                keysVisible: true,
                onVisibleChanged: (keysVisible) {},
              ),
            ],
          ),
        );
      },
    );
  }
}

class AuthorizationKeyPreview extends StatelessWidget {
  const AuthorizationKeyPreview(
      {Key key,
      @required this.environment,
      @required this.authorizationKey,
      this.onRegenerateKey})
      : super(key: key);
  final Environment environment;
  final String authorizationKey;
  final ValueChanged<Environment> onRegenerateKey;

  static Map<Environment, String> environmentKeyName = {
    Environment.sandbox: 'Sandbox key',
    Environment.production: 'Production key',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(environmentKeyName[environment]),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.indigo,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: SelectableText(
                    authorizationKey,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            PrimaryButton(
              text: 'Regenerate',
              onPressed: () => onRegenerateKey(environment),
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
    return SegmentedControl<bool>(
      header: Text('Keys'),
      value: keysVisible,
      children: {
        false: Text('Hidden'),
        true: Text('Visible'),
      },
      onValueChanged: onVisibleChanged,
    );
  }
}
