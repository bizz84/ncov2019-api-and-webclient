import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_path.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;
}
