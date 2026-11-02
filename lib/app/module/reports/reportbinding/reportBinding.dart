
import 'package:flutter_application_1/app/module/reports/reportcontroller/reportCnt.dart';
import 'package:get/get.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(
      () => ReportController(),
    );
  }
}