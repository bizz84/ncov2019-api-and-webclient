import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/user_authorization_keys.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_path.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Stream<UserAuthorizationKeys> userAuthorizationKeys() =>
      _service.documentStream(
          path: FirestorePath.user(uid),
          builder: (data, _) => UserAuthorizationKeys.fromMap(data));
}
