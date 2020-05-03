import 'package:flutter/foundation.dart';

class UserAuthorizationKeysAndTokens {
  UserAuthorizationKeysAndTokens({
    @required this.sandboxKey,
    @required this.productionKey,
    @required this.sandboxAccessToken,
    @required this.productionAccessToken,
  });
  final String sandboxKey;
  final String productionKey;
  final String sandboxAccessToken;
  final String productionAccessToken;

  factory UserAuthorizationKeysAndTokens.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    return UserAuthorizationKeysAndTokens(
      sandboxKey: data['sandboxKey'],
      productionKey: data['productionKey'],
      sandboxAccessToken: data['sandboxAccessToken'],
      productionAccessToken: data['productionAccessToken'],
    );
  }

  @override
  String toString() =>
      'sandboxKey: $sandboxKey, productionKey: $productionKey, sandboxAccessToken: $sandboxAccessToken, productionAccessToken: $productionAccessToken';
}
