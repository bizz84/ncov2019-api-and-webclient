import 'package:flutter/foundation.dart';

class UserAuthorizationKeys {
  UserAuthorizationKeys(
      {@required this.sandboxKey, @required this.productionKey});
  final String sandboxKey;
  final String productionKey;

  factory UserAuthorizationKeys.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    return UserAuthorizationKeys(
      sandboxKey: data['sandboxKey'],
      productionKey: data['productionKey'],
    );
  }

  @override
  String toString() => 'sandboxKey: $sandboxKey, productionKey: $productionKey';
}
