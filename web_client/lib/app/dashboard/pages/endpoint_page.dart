import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/common_widgets/selectable_text_field_with_actions.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/endpoint.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/user_authorization_keys_and_tokens.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_database.dart';
import 'package:ncov2019_codewithandrea_web_client/services/rest_api/api.dart';
import 'package:provider/provider.dart';

class EndpointPage extends StatelessWidget {
  const EndpointPage(this.endpoint, {Key key}) : super(key: key);
  final Endpoint endpoint;

  @override
  Widget build(BuildContext context) {
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
          // TODO: Access token selector
          SizedBox(height: 24),
          CurlCommandWithAccessToken(
            curlCommandBuilder: (accessToken) =>
                "curl -X GET --header 'Authorization: Bearer $accessToken' '$url'",
          ),
        ],
      ),
    );
  }
}

class CurlCommandWithAccessToken extends StatelessWidget {
  const CurlCommandWithAccessToken({Key key, this.curlCommandBuilder})
      : super(key: key);
  final String Function(String accessToken) curlCommandBuilder;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<UserAuthorizationKeysAndTokens>(
        stream: database.userAuthorizationKeysAndTokens(),
        builder: (_, snapshot) {
          final keysAndTokens = snapshot.data;
          // TODO Switch sandbox/production
          final sandboxAccessToken = keysAndTokens?.sandboxAccessToken;
          final accessToken = sandboxAccessToken?.accessToken ?? '';
          return SelectableTextFieldWithActions(
            title: 'curl command',
            value: curlCommandBuilder(accessToken),
          );
        });
  }
}
