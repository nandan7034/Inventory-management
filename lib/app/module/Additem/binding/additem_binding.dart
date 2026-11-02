import 'package:flutter_application_1/app/module/Additem/controller/additem_controller.dart';
import 'package:get/get.dart';

class AddItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddItemController>(() => AddItemController());
  }
}
