import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/user_authorization_keys_and_tokens.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_path.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_service.dart';

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Stream<UserAuthorizationKeysAndTokens> userAuthorizationKeysAndTokens() =>
      _service.documentStream(
        path: FirestorePath.user(uid),
        builder: (data, uid) =>
            UserAuthorizationKeysAndTokens.fromMap(data, uid),
      );
}
