import 'package:flutter_application_1/app/module/StockMovment/stockController/stockController.dart';
import 'package:flutter_application_1/app/module/Stockhistory/stockCntl/stockController.dart';
import 'package:get/get.dart';

class stockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockhistoryController>(() => StockhistoryController());
  }
}
