
import 'package:flutter_application_1/app/module/chartandanalyse/chartController/chartCnt.dart';
import 'package:get/get.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalyticsController>(
      () => AnalyticsController(),
    );
  }
}