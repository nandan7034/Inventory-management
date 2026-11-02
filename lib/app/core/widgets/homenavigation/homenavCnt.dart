
import 'package:get/get.dart';


class Homenavcnt extends GetxController {
  var selectindex = 0.obs;

  void navchnage(int index) {
    selectindex.value = index;
  }
}
