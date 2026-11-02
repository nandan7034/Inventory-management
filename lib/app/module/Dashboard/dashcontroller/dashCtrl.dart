
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashCntrl extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final loading = false.obs;
  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;

  Stream<QuerySnapshot<Map<String, dynamic>>> get itemstream {
    return firestore.collection('recivedItems').snapshots();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void updateSearch(String query) {
    searchQuery.value = query.trim().toLowerCase();
  }
}
