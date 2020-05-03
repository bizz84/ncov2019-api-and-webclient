import 'package:flutter/foundation.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';

class UserAccessToken {
  UserAccessToken({
    @required this.accessToken,
    @required this.uid,
    @required this.environment,
    @required this.expirationDate,
  });
  final String accessToken;
  final String uid;
  final Environment environment;
  final DateTime expirationDate;

  factory UserAccessToken.fromUserData(
      Map<String, dynamic> data, String uid, Environment environment) {
    if (data == null) {
      return null;
    }
    return UserAccessToken(
      uid: uid,
      environment: environment,
      accessToken: data['accessToken'],
      expirationDate: DateTime.tryParse(data['expirationDate']),
    );
  }

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
      expirationDate: DateTime.tryParse(data['expiration_date']),
    );
  }

  @override
  String toString() =>
      'accessToken: $accessToken, uid: $uid, environment: $environment';
}
