import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/selectable_text_field_with_actions.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/endpoint.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/user_authorization_keys_and_tokens.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/primary_button.dart';
import 'package:ncov2019_codewithandrea_web_client/common_widgets/segmented_control.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_database.dart';
import 'package:ncov2019_codewithandrea_web_client/services/rest_api/api.dart';
import 'package:ncov2019_codewithandrea_web_client/services/rest_api/api_service.dart';
import 'package:provider/provider.dart';

class EndpointPage extends StatefulWidget {
  const EndpointPage(this.endpoint, {Key key}) : super(key: key);
  final Endpoint endpoint;

  @override
  _EndpointPageState createState() => _EndpointPageState();
}

class _EndpointPageState extends State<EndpointPage> {
  Environment _environment = Environment.sandbox;
  String _responseText = '';

  Future<void> _sendRequest(BuildContext context, {String accessToken}) async {
    try {
      final response =
          await APIService().getEndpointResponse(widget.endpoint, accessToken);
      setState(() => _responseText =
          'Status code: ${response.statusCode}\n${response.body}');
    } catch (e) {
      showExceptionAlertDialog(
        context: context,
        title: 'Some error occurred',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = Uri(scheme: 'https', host: API.host, path: widget.endpoint.name)
        .toString();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.endpoint.name,
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: 24),
          SelectableTextFieldWithActions(
            title: 'Endpoint url',
            value: url,
          ),
          EnvironmentSegmentedControl(
            environment: _environment,
            onValueChanged: (env) => setState(() => _environment = env),
          ),
          SizedBox(height: 24),
          CurlCommandWithAccessToken(
            environment: _environment,
            endpoint: widget.endpoint,
            curlCommandBuilder: (accessToken) =>
                "curl -X GET --header 'Authorization: Bearer $accessToken' '$url'",
            onSend: (accessToken) =>
                _sendRequest(context, accessToken: accessToken),
          ),
          if (_responseText.isNotEmpty) ...[
            SizedBox(height: 24),
            SelectableTextFieldWithActions(
              title: 'Response',
              value: _responseText,
              showCopyAction: false,
            ),
          ]
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
      {Key key,
      @required this.curlCommandBuilder,
      @required this.environment,
      @required this.endpoint,
      @required this.onSend})
      : super(key: key);
  final String Function(String accessToken) curlCommandBuilder;
  final Environment environment;
  final Endpoint endpoint;
  final Future<void> Function(String) onSend;

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
          return CurlCommandWithAccessTokenContents(
            key: Key('$endpoint-curl-command'),
            accessToken: accessToken,
            curlCommandBuilder: curlCommandBuilder,
            onSend: onSend,
          );
        });
  }
}

class CurlCommandWithAccessTokenContents extends HookWidget {
  const CurlCommandWithAccessTokenContents(
      {Key key,
      @required this.accessToken,
      @required this.curlCommandBuilder,
      @required this.onSend})
      : super(key: key);
  final String accessToken;
  final String Function(String accessToken) curlCommandBuilder;
  final Future<void> Function(String) onSend;

  Future<void> _send(ValueNotifier<bool> loading) async {
    try {
      loading.value = true;
      await onSend(accessToken);
    } finally {
      loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);
    return SelectableTextFieldWithActions(
      title: 'curl command',
      value: curlCommandBuilder(accessToken),
      customActionBuilder: (context) => PrimaryButton(
        loading: loading.value,
        text: 'Send',
        onPressed: () => _send(loading),
      ),
    );
  }
}
