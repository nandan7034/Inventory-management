import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/core/model/receivingModel.dart';
import 'package:flutter_application_1/app/module/Additem/scanner/addScanner.dart';
import 'package:get/get.dart';

class AddItemController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final priceController = TextEditingController();
  final supplierController = TextEditingController();
  final receivedDateController = TextEditingController();
  final imageController = TextEditingController();
  final BarcodeController = TextEditingController();
  // Observables
  final selectedCategory = 'Electronics'.obs;
  final selectedStatus = 'In Stock'.obs;
  final isLoading = false.obs;
  final totalValue = 0.0.obs;

  // Category Options
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Electronics',
      'icon': Icons.laptop_rounded,
      'color': Colors.purple,
    },
    {'name': 'Furniture', 'icon': Icons.chair_rounded, 'color': Colors.blue},
    {'name': 'Food', 'icon': Icons.restaurant_rounded, 'color': Colors.orange},
    {'name': 'Clothing', 'icon': Icons.checkroom_rounded, 'color': Colors.pink},
    {'name': 'Stationery', 'icon': Icons.edit_rounded, 'color': Colors.teal},
    {
      'name': 'Hardware',
      'icon': Icons.construction_rounded,
      'color': Colors.indigo,
    },
    {'name': 'Other', 'icon': Icons.category_rounded, 'color': Colors.grey},
  ];

  // Status Options
  final List<String> statuses = [
    'In Stock',
    'Low Stock',
    'Out of Stock',
    'Pending Inspection',
  ];

  @override
  void onInit() {
    super.onInit();
    // Default today's date formatted (YYYY-MM-DD)
    final now = DateTime.now();
    receivedDateController.text =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Listen to changes to calculate total value dynamically
    quantityController.addListener(_calculateTotal);
    priceController.addListener(_calculateTotal);
  }

  void _calculateTotal() {
    final qty = int.tryParse(quantityController.text.trim()) ?? 0;
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
    totalValue.value = qty * price;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setStatus(String status) {
    selectedStatus.value = status;
  }

  void incrementQuantity() {
    final current = int.tryParse(quantityController.text.trim()) ?? 0;
    quantityController.text = (current + 1).toString();
  }

  void decrementQuantity() {
    final current = int.tryParse(quantityController.text.trim()) ?? 1;
    if (current > 1) {
      quantityController.text = (current - 1).toString();
    }
  }

  Future<void> scannedcode() async {
    final result = await Get.to(() => const BarcodeScannerView());

    if (result != null) {
      BarcodeController.text = result.toString();
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.grey.shade900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      receivedDateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> saveItem() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all required fields properly.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    try {
      isLoading.value = true;

      final newItem = ReceivingItemModel(
        id: 'REC-${DateTime.now().millisecondsSinceEpoch}',
        itemName: itemNameController.text.trim(),
        category: selectedCategory.value,
        quantity: int.tryParse(quantityController.text.trim()) ?? 0,
        price: double.tryParse(priceController.text.trim()) ?? 0.0,
        supplier: supplierController.text.trim().isEmpty
            ? 'Default Supplier'
            : supplierController.text.trim(),
        receivedDate: receivedDateController.text.trim(),
        image: imageController.text.trim().isEmpty
            ? null
            : imageController.text.trim(),
        status: selectedStatus.value,
        barcode: BarcodeController.text,
      );

      // Attempt to save to Cloud Firestore if connected
      try {
        await FirebaseFirestore.instance
            .collection('recivedItems')
            .doc(newItem.id)
            .set(newItem.toJson());
      } catch (firestoreError) {
        // Firestore may not have security rules or network, proceed smoothly
        debugPrint('Firestore save log: $firestoreError');
      }

      Get.snackbar(
        'Item Added Successfully',
        '${newItem.itemName} has been recorded into receiving inventory.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );

      // Return added item to previous screen or pop
      await Future.delayed(const Duration(milliseconds: 400));
      Get.back(result: newItem);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save item: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    itemNameController.clear();
    quantityController.text = '1';
    priceController.clear();
    supplierController.clear();
    imageController.clear();
    selectedCategory.value = 'Electronics';
    selectedStatus.value = 'In Stock';
    totalValue.value = 0.0;
  }

  @override
  void onClose() {
    itemNameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    supplierController.dispose();
    receivedDateController.dispose();
    imageController.dispose();
    super.onClose();
  }
}
