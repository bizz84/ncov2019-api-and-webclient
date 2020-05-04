import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/selectable_text_field_with_actions.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/endpoint.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/user_authorization_keys_and_tokens.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/segmented_control.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_database.dart';
import 'package:ncov2019_codewithandrea_web_client/services/rest_api/api.dart';
import 'package:provider/provider.dart';

class EndpointPage extends HookWidget {
  const EndpointPage(this.endpoint, {Key key}) : super(key: key);
  final Endpoint endpoint;

  @override
  Widget build(BuildContext context) {
    final environment = useState(Environment.sandbox);
    final url =
        Uri(scheme: 'https', host: API.host, path: endpoint.name).toString();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            endpoint.name,
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: 24),
          SelectableTextFieldWithActions(
            title: 'Endpoint url',
            value: url,
          ),
          EnvironmentSegmentedControl(
            environment: environment.value,
            onValueChanged: (env) => environment.value = env,
          ),
          SizedBox(height: 24),
          CurlCommandWithAccessToken(
            environment: environment.value,
            curlCommandBuilder: (accessToken) =>
                "curl -X GET --header 'Authorization: Bearer $accessToken' '$url'",
          ),
        ],
      ),
    );
  }
}

class EnvironmentSegmentedControl extends StatelessWidget {
  const EnvironmentSegmentedControl(
      {Key key, this.environment, this.onValueChanged})
      : super(key: key);
  final Environment environment;
  final ValueChanged<Environment> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedControl<Environment>(
      header: Text('Key to use', style: Theme.of(context).textTheme.headline6),
      value: environment,
      children: {
        Environment.sandbox: EnvironmentSegmentedControlText('sandbox'),
        Environment.production: EnvironmentSegmentedControlText('production'),
      },
      onValueChanged: onValueChanged,
    );
  }
}

class EnvironmentSegmentedControlText extends StatelessWidget {
  const EnvironmentSegmentedControlText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style:
            TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize),
      ),
    );
  }
}

class CurlCommandWithAccessToken extends StatelessWidget {
  const CurlCommandWithAccessToken(
      {Key key, this.curlCommandBuilder, this.environment})
      : super(key: key);
  final String Function(String accessToken) curlCommandBuilder;
  final Environment environment;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<UserAuthorizationKeysAndTokens>(
        stream: database.userAuthorizationKeysAndTokens(),
        builder: (_, snapshot) {
          final keysAndTokens = snapshot.data;
          final sandboxAccessToken = environment == Environment.sandbox
              ? keysAndTokens?.sandboxAccessToken
              : keysAndTokens?.productionAccessToken;
          final accessToken = sandboxAccessToken?.accessToken ?? '';
          return SelectableTextFieldWithActions(
            title: 'curl command',
            value: curlCommandBuilder(accessToken),
          );
        });
  }
}
