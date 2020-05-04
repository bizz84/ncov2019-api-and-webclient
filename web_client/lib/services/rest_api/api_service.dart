import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ncov2019_codewithandrea_web_client/services/rest_api/api.dart';

class APIService {
  APIService(this.apiKey);
  final String apiKey;

  Future<String> getAccessToken() async {
    final response = await http.post(
      API.tokenUri().toString(),
      headers: {'Authorization': 'Bearer $apiKey'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    print(
        'Request ${API.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }
}
