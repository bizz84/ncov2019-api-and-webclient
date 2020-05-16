import 'dart:async';

import 'package:firebase_auth_service/firebase_auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in_service/google_sign_in_service.dart';
import 'package:meta/meta.dart';

class SignInViewModel with ChangeNotifier {
  SignInViewModel(
      {@required this.authService, @required this.googleSignInService});
  final FirebaseAuthService authService;
  final GoogleSignInService googleSignInService;
  bool isLoading = false;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading = true;
      notifyListeners();
      return await signInMethod();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<User> signInAnonymously() async {
    return await _signIn(authService.signInAnonymously);
  }

  Future<User> signInWithGoogle() async {
    return await _signIn(googleSignInService.signInWithGoogle);
  }
}
