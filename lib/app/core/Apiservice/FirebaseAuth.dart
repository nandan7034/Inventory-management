import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/app/core/model/authmodel.dart';

class Firebaseauth {
  Future<UserCredential?> logUser(SignModel model) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );

      log("Login successful");
      log("UID: ${result.user?.uid}");

      return result;
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Error: ${e.code}");
      log("Message: ${e.message}");
      return null;
    } catch (e) {
      log("Unknown Error: $e");
      return null;
    }
  }
}
