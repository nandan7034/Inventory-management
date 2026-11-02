import 'package:flutter_application_1/app/core/widgets/homenavigation/homenavCnt.dart';
import 'package:get/get.dart';

class Homenavbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Homenavcnt>(() => Homenavcnt());
  }
}
