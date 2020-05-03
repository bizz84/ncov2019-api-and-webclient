import 'package:flutter/foundation.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';

class UserAccessToken {
  UserAccessToken({
    @required this.accessToken,
    @required this.uid,
    @required this.environment,
  });
  final String accessToken;
  final String uid;
  final Environment environment;

  factory UserAccessToken.fromMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final environmentString = data['environment'];
    final environment = environmentString == 'sandbox'
        ? Environment.sandbox
        : Environment.production;
    return UserAccessToken(
      uid: data['uid'],
      environment: environment,
      accessToken: documentId,
    );
  }

  @override
  String toString() =>
      'accessToken: $accessToken, uid: $uid, environment: $environment';
}
