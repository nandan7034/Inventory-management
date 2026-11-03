import 'package:flutter_application_1/app/module/Dashboard/dashcontroller/dashCtrl.dart';
import 'package:flutter_application_1/app/module/StockMovment/stockController/stockController.dart';
import 'package:get/get.dart';

class DashListBind extends Bindings {
  void dependencies() {
    Get.lazyPut<DashCntrl>(() => DashCntrl());
    Get.lazyPut<Stockcnt>(() => Stockcnt());
  }
}
