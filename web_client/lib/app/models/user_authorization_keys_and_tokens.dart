import 'package:flutter/foundation.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/user_access_token.dart';

class UserAuthorizationKeysAndTokens {
  UserAuthorizationKeysAndTokens({
    @required this.sandboxKey,
    @required this.productionKey,
    this.sandboxAccessToken,
    this.productionAccessToken,
  });
  final String sandboxKey;
  final String productionKey;
  final UserAccessToken sandboxAccessToken;
  final UserAccessToken productionAccessToken;

  factory UserAuthorizationKeysAndTokens.fromMap(
      Map<String, dynamic> data, String uid) {
    if (data == null) {
      return null;
    }
    return UserAuthorizationKeysAndTokens(
      sandboxKey: data['sandboxKey'],
      productionKey: data['productionKey'],
      sandboxAccessToken: UserAccessToken.fromUserData(
          data['sandboxAccessToken'], uid, Environment.sandbox),
      productionAccessToken: UserAccessToken.fromUserData(
          data['productionAccessToken'], uid, Environment.production),
    );
  }

  @override
  String toString() =>
      'sandboxKey: $sandboxKey, productionKey: $productionKey, sandboxAccessToken: $sandboxAccessToken, productionAccessToken: $productionAccessToken';
}
