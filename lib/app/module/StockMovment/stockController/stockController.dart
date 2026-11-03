import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/core/model/receivingModel.dart';
import 'package:flutter_application_1/app/module/StockMovment/scanner/outScanner.dart';
import 'package:flutter_application_1/app/routes/appPage/appPage.dart';
import 'package:get/get.dart';

class Stockcnt extends GetxController {
  final loading = false.obs;

  final barcodeSn = TextEditingController();

  // Found item
  final scannedItem = Rxn<ReceivingItemModel>();

  // Total value
  final totalValue = 0.0.obs;

  final itemDocId = RxnString();
  final count = TextEditingController();
  // --------------------------------
  // OPEN BARCODE SCANNER
  // --------------------------------
  Future<void> scannedcode() async {
    final result = await Get.to(() => const OutBarcodeScanner());

    if (result != null) {
      barcodeSn.text = result.toString().trim();

      print("Scanned barcode: ${barcodeSn.text}");

      // Search automatically
      await Stockmove();
    }
  }

  ////////////////////////////////////////

  Future<void> stockupdate() async {
    if (loading.value) return;

    try {
      loading.value = true;

      final docId = itemDocId.value;
      final outQuantity = int.tryParse(count.text.trim());

      // Check whether an item was scanned
      if (docId == null || docId.isEmpty) {
        Get.snackbar("Error", "Please scan an item first");
        return;
      }

      // Validate stock-out quantity
      if (outQuantity == null || outQuantity <= 0) {
        Get.snackbar("Error", "Enter a valid quantity");
        return;
      }

      final db = FirebaseFirestore.instance;
      final itemRef = db.collection("recivedItems").doc(docId);
      final movementRef = db.collection("stockMovements").doc();

      print("Updating document ID: $docId");
      print("Stock out quantity: $outQuantity");

      await db.runTransaction((transaction) async {
        final snapshot = await transaction.get(itemRef);

        if (!snapshot.exists) {
          throw Exception("Item does not exist in Firestore");
        }

        final data = snapshot.data()!;
        final currentQuantity = (data["quantity"] as num?)?.toInt() ?? 0;

        print("Current quantity: $currentQuantity");

        if (outQuantity > currentQuantity) {
          throw Exception("Insufficient stock. Available: $currentQuantity");
        }

        final remaining = currentQuantity - outQuantity;

        // Update inventory quantity
        transaction.update(itemRef, {
          "quantity": remaining,
          "status": remaining == 0
              ? "Out of Stock"
              : remaining < 5
              ? "Low Stock"
              : "In Stock",
        });

        // Save stock movement history
        transaction.set(movementRef, {
          "itemId": docId,
          "itemName": data["itemName"] ?? "",
          "barcode": data["barcode"] ?? "",
          "type": "Stock Out",
          "quantity": outQuantity,
          "previousQuantity": currentQuantity,
          "remainingQuantity": remaining,
          "date": FieldValue.serverTimestamp(),
        });
      });

      count.clear();

      // Refresh item details
      await Stockmove();

      Get.snackbar(
        "Success",
        "$outQuantity units stocked out successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseException catch (e) {
      print("FIREBASE ERROR: ${e.code} - ${e.message}");

      Get.snackbar("Firebase Error", "${e.code}: ${e.message}");
    } catch (e) {
      print("STOCK OUT ERROR: $e");

      Get.snackbar(
        "Stock Out Failed",
        e.toString().replaceFirst("Exception: ", ""),
      );
    } finally {
      loading.value = false;
    }
  }

  // --------------------------------
  // FIND ITEM
  // --------------------------------
  Future<void> Stockmove() async {
    try {
      loading.value = true;

      final barcode = barcodeSn.text.trim();

      if (barcode.isEmpty) {
        Get.snackbar("Error", "Please scan a barcode");
        return;
      }

      print("Searching barcode: $barcode");

      final result = await FirebaseFirestore.instance
          .collection("recivedItems")
          .where("barcode", isEqualTo: barcode)
          .limit(1)
          .get();
      print("Documents found: ${result.docs.length}");

      // --------------------------------
      // ITEM NOT FOUND
      // --------------------------------
      if (result.docs.isEmpty) {
        scannedItem.value = null;

        Get.snackbar(
          "Not Found",
          "No item found with barcode $barcode",
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      /////////////////////////////////////////
      ///

      // --------------------------------
      // ITEM FOUND
      // --------------------------------
      final document = result.docs.first;
      final data = document.data();

      itemDocId.value = document.id;

      scannedItem.value = ReceivingItemModel.fromJson(data);

      calculateTotal();
      // Calculate value
      calculateTotal();

      print("Item found: ${scannedItem.value?.itemName}");

      print("Quantity: ${scannedItem.value?.quantity}");

      print("Price: ${scannedItem.value?.price}");

      print("Barcode: ${scannedItem.value?.barcode}");

      Get.snackbar(
        "Item Found",
        "${scannedItem.value?.itemName} found successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print("SEARCH ERROR: $e");

      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      loading.value = false;
    }
  }

  // --------------------------------
  // CALCULATE TOTAL
  // --------------------------------
  void calculateTotal() {
    final qty = scannedItem.value?.quantity ?? 0;

    final price = scannedItem.value?.price ?? 0.0;

    totalValue.value = qty * price;
  }

  Future<void> deleteDate() async {
    final barcode = barcodeSn.text.trim();
    final result = await FirebaseFirestore.instance
        .collection("recivedItems")
        .where("barcode", isEqualTo: barcode)
        .limit(1)
        .get();
    print("Documents found: ${result.docs.length}");

    if (result.docs.isNotEmpty) {
      await result.docs.first.reference.delete();
      Get.toNamed(AppRoutes.dashboard);
    }
  }

  // --------------------------------
  // CLOSE
  // --------------------------------
  @override
  void onClose() {
    barcodeSn.dispose();
    super.onClose();
  }
}
