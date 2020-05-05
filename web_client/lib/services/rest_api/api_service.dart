import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ncov2019_codewithandrea_web_client/app/models/endpoint.dart';
import 'package:ncov2019_codewithandrea_web_client/services/rest_api/api.dart';

class APIService {
  Future<String> getAccessToken(String apiKey) async {
    final response = await http.post(
      API.tokenUri().toString(),
      headers: {'Authorization': 'Basic $apiKey'},
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

  Future<http.Response> getEndpointResponse(
      Endpoint endpoint, String accessToken) async {
    return await http.get(
      API.endpointUri(endpoint).toString(),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
  }
}
