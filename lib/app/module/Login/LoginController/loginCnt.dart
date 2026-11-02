import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/core/model/authmodel.dart';
import 'package:flutter_application_1/app/module/Login/Storage/loginstorage.dart';

import 'package:flutter_application_1/app/module/Login/repository/login_repo.dart';
import 'package:flutter_application_1/app/routes/appPage/appPage.dart';
import 'package:flutter_application_1/app/routes/appRoute/appRoute.dart';
import 'package:get/get.dart';

class Logincnt extends GetxController {
  var loading = false.obs;
  final obscuretext = true.obs;

  final emailCnt = TextEditingController();
  final passwordCnt = TextEditingController();

  final LoginRepo _loginrepo;
  final Loginstorage _loginstorage;
  Logincnt(this._loginrepo, this._loginstorage);

  void toggle() {
    obscuretext.value = !obscuretext.value;
  }

  Future<void> loginUser() async {
    try {
      loading.value = true;
      final response = SignModel(
        email: emailCnt.text.trim(),
        password: passwordCnt.text.trim(),
      );
      final result = await _loginrepo.login(response);
      if (result != null) {
        Get.snackbar("Success", "Login successful");
        final token = await result.user!.getIdToken();
        if (token != null) {
          await _loginstorage.saveToker(token);
        }
        print(token);
        Get.offAllNamed(AppRoutes.homenavbar);
      } else {
        Get.snackbar("Error", "Login failed");
      }
      loading.value = false;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      loading.value = false;
    }
  }
}
