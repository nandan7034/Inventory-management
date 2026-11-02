import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/app/core/Apiservice/FirebaseAuth.dart';
import 'package:flutter_application_1/app/core/model/authmodel.dart';

class LoginRepo {
  final Firebaseauth _firebaseauth;

  LoginRepo(this._firebaseauth);

  Future<UserCredential?> login(SignModel model) async {
    return await _firebaseauth.logUser(model);
  }
}
