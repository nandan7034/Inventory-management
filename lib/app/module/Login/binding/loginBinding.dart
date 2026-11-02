import 'package:flutter_application_1/app/module/Login/LoginController/loginCnt.dart';
import 'package:flutter_application_1/app/module/Login/Storage/loginstorage.dart';
import 'package:flutter_application_1/app/module/Login/repository/login_repo.dart';
import 'package:flutter_application_1/app/core/Apiservice/FirebaseAuth.dart';
import 'package:get/get.dart';

class Loginbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Firebaseauth>(() => Firebaseauth());

    Get.lazyPut<LoginRepo>(() => LoginRepo(Get.find<Firebaseauth>()));

    Get.lazyPut<Logincnt>(
      () => Logincnt(Get.find<LoginRepo>(), Get.find<Loginstorage>()),
    );
    Get.lazyPut<Loginstorage>(() => Loginstorage());
  }
}
