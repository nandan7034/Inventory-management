import 'package:flutter_application_1/app/module/StockMovment/stockController/stockController.dart';
import 'package:get/get.dart';

class Stockoutbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Stockcnt>(() => Stockcnt());
  }
}
