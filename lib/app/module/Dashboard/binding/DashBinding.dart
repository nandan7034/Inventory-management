import 'package:flutter_application_1/app/core/widgets/homenavigation/homenavCnt.dart';
import 'package:flutter_application_1/app/module/Dashboard/dashcontroller/dashCtrl.dart';
import 'package:flutter_application_1/app/module/chartandanalyse/chartController/chartCnt.dart';
import 'package:flutter_application_1/app/module/reports/reportcontroller/reportCnt.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/utils.dart';

class Dashbinding extends Bindings {
  void dependencies() {
    Get.lazyPut<DashCntrl>(() => DashCntrl());
    Get.lazyPut<ReportController>(() => ReportController());
        Get.lazyPut<AnalyticsController>(
      () => AnalyticsController(),
    );
    Get.lazyPut<Homenavcnt>(() => Homenavcnt());
  }
}
