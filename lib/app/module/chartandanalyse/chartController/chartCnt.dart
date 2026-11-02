import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Loading
  final loading = true.obs;

  // Inventory overview
  final totalItems = 0.obs;
  final totalQuantity = 0.obs;
  final totalInventoryValue = 0.0.obs;
  final lowStock = 0.obs;

  // Stock status
  final inStock = 0.obs;
  final lowStockCount = 0.obs;
  final outOfStock = 0.obs;

  // Category data
  final categoryQuantity = <String, int>{}.obs;
  final categoryValue = <String, double>{}.obs;

  // Stock movement
  final totalStockIn = 0.obs;
  final totalStockOut = 0.obs;

  // Fast / slow moving
  final fastMovingItems = <Map<String, dynamic>>[].obs;
  final slowMovingItems = <Map<String, dynamic>>[].obs;

  // Reorder
  final reorderItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    try {
      loading.value = true;

      await loadInventory();
      await loadStockMovements();
      await loadFastAndSlowMoving();
      await loadReorderSuggestions();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unable to load analytics: $e",
      );
    } finally {
      loading.value = false;
    }
  }

  // =========================================================
  // INVENTORY
  // =========================================================

  Future<void> loadInventory() async {
    final result = await _firestore
        .collection("recivedItems")
        .get();

    int items = 0;
    int quantity = 0;
    double value = 0;

    int inStockItems = 0;
    int lowStockItems = 0;
    int outStockItems = 0;

    final Map<String, int> categoryQty = {};
    final Map<String, double> categoryVal = {};

    for (final doc in result.docs) {
      final data = doc.data();

      items++;

      final int itemQuantity =
          _getInt(data["quantity"]);

      final double price =
          _getDouble(data["price"]);

      final String category =
          data["category"]?.toString() ?? "Other";

      quantity += itemQuantity;

      final double itemValue =
          itemQuantity * price;

      value += itemValue;

      // -----------------------------------------
      // Stock status
      // -----------------------------------------

      if (itemQuantity <= 0) {
        outStockItems++;
      } else if (itemQuantity <= 5) {
        lowStockItems++;
      } else {
        inStockItems++;
      }

      // -----------------------------------------
      // Category quantity
      // -----------------------------------------

      categoryQty[category] =
          (categoryQty[category] ?? 0) +
              itemQuantity;

      // -----------------------------------------
      // Category value
      // -----------------------------------------

      categoryVal[category] =
          (categoryVal[category] ?? 0) +
              itemValue;
    }

    totalItems.value = items;

    totalQuantity.value = quantity;

    totalInventoryValue.value = value;

    lowStock.value = lowStockItems;

    inStock.value = inStockItems;

    lowStockCount.value = lowStockItems;

    outOfStock.value = outStockItems;

    categoryQuantity.value = categoryQty;

    categoryValue.value = categoryVal;
  }

  // =========================================================
  // STOCK MOVEMENT
  // =========================================================

  Future<void> loadStockMovements() async {
    final result = await _firestore
        .collection("stockMovements")
        .get();

    int stockIn = 0;
    int stockOut = 0;

    for (final doc in result.docs) {
      final data = doc.data();

      final String type =
          data["type"]?.toString().toLowerCase() ?? "";

      final int quantity =
          _getInt(data["quantity"]);

      if (type == "stock in" ||
          type == "in") {
        stockIn += quantity;
      }

      if (type == "stock out" ||
          type == "out") {
        stockOut += quantity;
      }
    }

    totalStockIn.value = stockIn;

    totalStockOut.value = stockOut;
  }

  // =========================================================
  // FAST / SLOW MOVING ITEMS
  // =========================================================

  Future<void> loadFastAndSlowMoving() async {
    final result = await _firestore
        .collection("stockMovements")
        .get();

    final Map<String, int> movementCount = {};

    final Map<String, String> itemNames = {};

    final Map<String, String> itemIds = {};

    for (final doc in result.docs) {
      final data = doc.data();

      final String itemId =
          data["itemId"]?.toString() ??
              data["barcode"]?.toString() ??
              "";

      final String itemName =
          data["itemName"]?.toString() ??
              "Unknown Item";

      final int quantity =
          _getInt(data["quantity"]);

      if (itemId.isEmpty) {
        continue;
      }

      itemNames[itemId] = itemName;

      itemIds[itemId] = itemId;

      movementCount[itemId] =
          (movementCount[itemId] ?? 0) +
              quantity;
    }

    final List<Map<String, dynamic>> allItems =
        [];

    movementCount.forEach((id, quantity) {
      allItems.add({
        "itemId": itemIds[id],
        "itemName": itemNames[id],
        "quantity": quantity,
      });
    });

    allItems.sort(
      (a, b) =>
          (b["quantity"] as int)
              .compareTo(a["quantity"] as int),
    );

    fastMovingItems.value =
        allItems.take(5).toList();

    final slowItems = List<Map<String, dynamic>>.from(
      allItems.reversed,
    );

    slowMovingItems.value =
        slowItems.take(5).toList();
  }

  // =========================================================
  // REORDER SUGGESTIONS
  // =========================================================

  Future<void> loadReorderSuggestions() async {
    final result = await _firestore
        .collection("recivedItems")
        .get();

    final List<Map<String, dynamic>> reorder =
        [];

    for (final doc in result.docs) {
      final data = doc.data();

      final int quantity =
          _getInt(data["quantity"]);

      if (quantity <= 5) {
        reorder.add({
          "id": doc.id,
          "itemName":
              data["itemName"] ?? "Unknown",
          "quantity": quantity,
          "category":
              data["category"] ?? "Other",
          "barcode":
              data["barcode"] ?? "",
        });
      }
    }

    reorderItems.value = reorder;
  }

  // =========================================================
  // HELPERS
  // =========================================================

  int _getInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(
          value.toString(),
        ) ??
        0;
  }

  double _getDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0;
  }

  // =========================================================
  // REFRESH
  // =========================================================

  Future<void> refreshAnalytics() async {
    await loadAnalytics();
  }
}