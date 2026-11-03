import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockhistoryController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Filter
  final selectedFilter = 'All'.obs;

  // Search
  final TextEditingController searchText = TextEditingController();

  // Stock movement list
  final allMovements = <Map<String, dynamic>>[].obs;

  // Loading
  final loading = false.obs;

  // Total Stock In
  int get totalIn {
    return allMovements.where((item) => item['type'] == 'Stock In').fold(0, (
      sum,
      item,
    ) {
      return sum + ((item['quantity'] as num?)?.toInt() ?? 0).abs();
    });
  }

  // Total Stock Out
  int get totalOut {
    return allMovements.where((item) => item['type'] == 'Stock Out').fold(0, (
      sum,
      item,
    ) {
      return sum + ((item['quantity'] as num?)?.toInt() ?? 0).abs();
    });
  }

  // Net Stock Movement
  int get netMovement => totalIn - totalOut;

  // Search and Filter
  List<Map<String, dynamic>> get filteredMovements {
    final search = searchText.text.trim().toLowerCase();

    return allMovements.where((item) {
      final matchesFilter =
          selectedFilter.value == 'All' || item['type'] == selectedFilter.value;

      final itemName = (item['item'] ?? '').toString().toLowerCase();

      final sku = (item['sku'] ?? '').toString().toLowerCase();

      final matchesSearch = itemName.contains(search) || sku.contains(search);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  // Search method
  void search(String value) {
    searchText.text = value;
    allMovements.refresh();
  }

  // Change filter
  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Convert Firestore date
  DateTime? getDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  // Format date
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';

    return '${date.day}/${date.month}/${date.year}';
  }

  // Format time
  String formatTime(DateTime? date) {
    if (date == null) return '';

    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  // Get Stock History
  Future<void> getStockHistory() async {
    try {
      loading.value = true;

      final List<Map<String, dynamic>> movements = [];

      // -------------------------------
      // STOCK IN
      // -------------------------------
      final receivingResult = await firestore.collection('recivedItems').get();

      for (final doc in receivingResult.docs) {
        final data = doc.data();

        final quantity = (data['quantity'] as num?)?.toInt() ?? 0;

        final date = getDate(data['receivedDate'] ?? data['date']);

        movements.add({
          'id': doc.id,
          'item': data['itemName'] ?? 'Unknown Item',
          'sku': data['barcode'] ?? data['id'] ?? 'N/A',
          'description': 'Stock received',
          'type': 'Stock In',
          'quantity': quantity.abs(),
          'date': formatDate(date),
          'time': formatTime(date),
          'sortDate': date ?? DateTime(2000),
        });
      }

      // -------------------------------
      // STOCK OUT
      // -------------------------------
      final stockOutResult = await firestore.collection('stockMovements').get();

      for (final doc in stockOutResult.docs) {
        final data = doc.data();

        final quantity = ((data['quantity'] as num?)?.toInt() ?? 0).abs();

        final date = getDate(
          data['date'] ?? data['createdAt'] ?? data['timestamp'],
        );

        movements.add({
          'id': doc.id,
          'item': data['itemName'] ?? data['item'] ?? 'Unknown Item',
          'sku': data['barcode'] ?? data['sku'] ?? 'N/A',
          'description': data['description'] ?? 'Stock issued',
          'type': 'Stock Out',
          'quantity': -quantity,
          'date': formatDate(date),
          'time': formatTime(date),
          'sortDate': date ?? DateTime(2000),
        });
      }

      // Latest movement first
      movements.sort((a, b) {
        return (b['sortDate'] as DateTime).compareTo(a['sortDate'] as DateTime);
      });

      allMovements.assignAll(movements);
    } catch (e) {
      debugPrint('Stock History Error: $e');

      Get.snackbar(
        'Error',
        'Unable to load stock history: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getStockHistory();
  }

  @override
  void onClose() {
    searchText.dispose();
    super.onClose();
  }
}
