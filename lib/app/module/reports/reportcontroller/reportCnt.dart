import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/app/module/reports/reportservice/reportservice.dart';
import 'package:get/get.dart';


class ReportController extends GetxController {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final loading = false.obs;

  final selectedReport = "Stock Summary".obs;

  final reportTypes = [
    "Stock Summary",
    "Low Stock",
    "Dead Stock",
    "Movement History",
    "Category Value",
  ];

  // --------------------------------------------------
  // REPORT TYPE
  // --------------------------------------------------

  void selectReport(String report) {
    selectedReport.value = report;
  }

  // --------------------------------------------------
  // EXPORT PDF
  // --------------------------------------------------

  Future<void> exportPdf() async {
    try {
      loading.value = true;

      final reportData =
          await _getReportData();

      if (reportData.isEmpty) {
        Get.snackbar(
          "No Data",
          "There is no data available for this report.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await ReportService.generatePdf(
        reportName: selectedReport.value,
        data: reportData,
      );

      Get.snackbar(
        "Success",
        "PDF report generated successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "PDF export failed: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  // --------------------------------------------------
  // EXPORT EXCEL
  // --------------------------------------------------

  Future<void> exportExcel() async {
    try {
      loading.value = true;

      final reportData =
          await _getReportData();

      if (reportData.isEmpty) {
        Get.snackbar(
          "No Data",
          "There is no data available for this report.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await ReportService.generateExcel(
        reportName: selectedReport.value,
        data: reportData,
      );

      Get.snackbar(
        "Success",
        "Excel report generated successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Excel export failed: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  // --------------------------------------------------
  // GET REPORT DATA
  // --------------------------------------------------

  Future<List<Map<String, dynamic>>>
      _getReportData() async {
    switch (selectedReport.value) {
      case "Stock Summary":
        return await _stockSummary();

      case "Low Stock":
        return await _lowStock();

      case "Dead Stock":
        return await _deadStock();

      case "Movement History":
        return await _movementHistory();

      case "Category Value":
        return await _categoryValue();

      default:
        return [];
    }
  }

  // --------------------------------------------------
  // STOCK SUMMARY
  // --------------------------------------------------

  Future<List<Map<String, dynamic>>>
      _stockSummary() async {
    final snapshot = await _firestore
        .collection("recivedItems")
        .get();

    final List<Map<String, dynamic>> data = [];

    for (final doc in snapshot.docs) {
      final item = doc.data();

      final int quantity =
          _getInt(item["quantity"]);

      final double price =
          _getDouble(item["price"]);

      data.add({
        "SKU": item["barcode"] ?? doc.id,
        "Item Name":
            item["itemName"] ?? "",
        "Category":
            item["category"] ?? "",
        "Quantity": quantity,
        "Unit Price": price,
        "Total Value":
            quantity * price,
        "Received Date":
            item["receivedDate"] ?? "",
      });
    }

    return data;
  }

  // --------------------------------------------------
  // LOW STOCK
  // --------------------------------------------------

  Future<List<Map<String, dynamic>>>
      _lowStock() async {
    final snapshot = await _firestore
        .collection("recivedItems")
        .get();

    final List<Map<String, dynamic>> data = [];

    for (final doc in snapshot.docs) {
      final item = doc.data();

      final int quantity =
          _getInt(item["quantity"]);

      if (quantity <= 5) {
        data.add({
          "SKU":
              item["barcode"] ?? doc.id,
          "Item Name":
              item["itemName"] ?? "",
          "Category":
              item["category"] ?? "",
          "Current Quantity":
              quantity,
          "Status": quantity == 0
              ? "Out of Stock"
              : "Low Stock",
        });
      }
    }

    return data;
  }

  // --------------------------------------------------
  // DEAD STOCK
  // --------------------------------------------------

  Future<List<Map<String, dynamic>>>
      _deadStock() async {
    final items = await _firestore
        .collection("recivedItems")
        .get();

    final movements = await _firestore
        .collection("stockMovements")
        .get();

    final Map<String, DateTime> lastMovement = {};

    for (final doc in movements.docs) {
      final data = doc.data();

      final itemId =
          data["itemId"]?.toString();

      final date =
          _parseDate(data["date"]);

      if (itemId == null || date == null) {
        continue;
      }

      if (!lastMovement.containsKey(itemId) ||
          date.isAfter(lastMovement[itemId]!)) {
        lastMovement[itemId] = date;
      }
    }

    final List<Map<String, dynamic>> data = [];

    final now = DateTime.now();

    for (final doc in items.docs) {
      final item = doc.data();

      final lastDate =
          lastMovement[doc.id];

      if (lastDate == null) {
        data.add({
          "SKU":
              item["barcode"] ?? doc.id,
          "Item Name":
              item["itemName"] ?? "",
          "Category":
              item["category"] ?? "",
          "Last Movement":
              "No movement",
          "Status":
              "Dead Stock",
        });

        continue;
      }

      final days =
          now.difference(lastDate).inDays;

      if (days >= 30) {
        data.add({
          "SKU":
              item["barcode"] ?? doc.id,
          "Item Name":
              item["itemName"] ?? "",
          "Category":
              item["category"] ?? "",
          "Last Movement":
              lastDate.toString(),
          "Days Since Movement":
              days,
          "Status":
              "Dead Stock",
        });
      }
    }

    return data;
  }

  // --------------------------------------------------
  // MOVEMENT HISTORY
  // --------------------------------------------------

  Future<List<Map<String, dynamic>>>
      _movementHistory() async {
    final snapshot = await _firestore
        .collection("stockMovements")
        .orderBy(
          "date",
          descending: true,
        )
        .get();

    final List<Map<String, dynamic>> data = [];

    for (final doc in snapshot.docs) {
      final item = doc.data();

      data.add({
        "Item ID":
            item["itemId"] ?? "",
        "Item Name":
            item["itemName"] ?? "",
        "Barcode":
            item["barcode"] ?? "",
        "Type":
            item["type"] ?? "",
        "Quantity":
            _getInt(item["quantity"]),
        "Date":
            item["date"] ?? "",
      });
    }

    return data;
  }

  // --------------------------------------------------
  // CATEGORY VALUE
  // --------------------------------------------------

  Future<List<Map<String, dynamic>>>
      _categoryValue() async {
    final snapshot = await _firestore
        .collection("recivedItems")
        .get();

    final Map<String, double> categoryTotals =
        {};

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final category =
          data["category"]?.toString() ??
              "Other";

      final quantity =
          _getInt(data["quantity"]);

      final price =
          _getDouble(data["price"]);

      final value =
          quantity * price;

      categoryTotals[category] =
          (categoryTotals[category] ?? 0) +
              value;
    }

    final List<Map<String, dynamic>> result =
        [];

    categoryTotals.forEach(
      (category, value) {
        result.add({
          "Category": category,
          "Inventory Value": value,
        });
      },
    );

    return result;
  }

  // --------------------------------------------------
  // HELPERS
  // --------------------------------------------------

  int _getInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? "",
        ) ??
        0;
  }

  double _getDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? "",
        ) ??
        0;
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }
}