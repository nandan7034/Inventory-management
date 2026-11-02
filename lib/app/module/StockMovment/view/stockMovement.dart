import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/module/StockMovment/stockController/stockController.dart';
import 'package:get/get.dart';

class Stockmovement extends GetView<Stockcnt> {
  const Stockmovement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),

        title: const Text(
          "Item Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =====================================================
            // BARCODE SCANNER
            // =====================================================
            Container(
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.deepPurple.shade500,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Row(
                      children: [
                        Icon(Icons.qr_code, size: 20, color: Colors.white),

                        SizedBox(width: 7),

                        Text(
                          "Stock Item",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: controller.barcodeSn,

                      decoration: InputDecoration(
                        hintText: "Scan or enter the barcode",

                        filled: true,
                        fillColor: Colors.white,

                        prefixIcon: const Icon(Icons.qr_code_scanner),

                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.scannedcode();
                          },
                          icon: const Icon(Icons.camera_alt),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),

                      onSubmitted: (value) {
                        controller.Stockmove();
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =====================================================
            // LOADING
            // =====================================================
            Obx(() {
              if (!controller.loading.value) {
                return const SizedBox();
              }

              return const Padding(
                padding: EdgeInsets.only(bottom: 15),

                child: LinearProgressIndicator(),
              );
            }),

            // =====================================================
            // SCANNED ITEM DETAILS
            // =====================================================
            Obx(() {
              final item = controller.scannedItem.value;

              // -------------------------------------------------
              // NO ITEM SCANNED
              // -------------------------------------------------
              if (item == null) {
                return Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(30),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(16),

                    border: Border.all(color: Colors.grey.shade200),
                  ),

                  child: const Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 65,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 12),

                      Text(
                        "Scan an item",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Scan a barcode to view item details",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              // -------------------------------------------------
              // ITEM FOUND
              // -------------------------------------------------
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // =============================================
                  // ITEM IMAGE + BASIC INFORMATION
                  // =============================================
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(color: Colors.grey.shade200),
                    ),

                    child: Column(
                      children: [
                        // ---------------------------------------
                        // IMAGE
                        // ---------------------------------------
                        Container(
                          height: 180,
                          width: 180,

                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,

                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: item.image != null && item.image!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),

                                  child: Image.network(
                                    item.image!,
                                    fit: BoxFit.cover,

                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported,
                                        size: 60,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                )
                              : const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                        ),

                        const SizedBox(height: 18),

                        // ---------------------------------------
                        // ITEM NAME
                        // ---------------------------------------
                        Text(
                          item.itemName ?? "No name",

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // ---------------------------------------
                        // CATEGORY
                        // ---------------------------------------
                        Text(
                          item.category ?? "No category",

                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ---------------------------------------
                        // BARCODE
                        // ---------------------------------------
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.1),

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(
                            "Barcode: ${item.barcode ?? "N/A"}",

                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =============================================
                  // CURRENT STOCK TITLE
                  // =============================================
                  const Text(
                    "Current Stock",

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // =============================================
                  // CURRENT STOCK CARD
                  // =============================================
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(color: Colors.grey.shade200),
                    ),

                    child: Column(
                      children: [
                        // ---------------------------------------
                        // QUANTITY + STATUS
                        // ---------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  "${item.quantity ?? 0}",

                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const Text(
                                  "Units",

                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),

                            // STATUS
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),

                              decoration: BoxDecoration(
                                color: (item.quantity ?? 0) > 0
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),

                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 5,

                                    backgroundColor: (item.quantity ?? 0) > 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),

                                  const SizedBox(width: 7),

                                  Text(
                                    (item.quantity ?? 0) > 0
                                        ? "In Stock"
                                        : "Out of Stock",

                                    style: TextStyle(
                                      color: (item.quantity ?? 0) > 0
                                          ? Colors.green
                                          : Colors.red,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 30),

                        // ---------------------------------------
                        // PRICE
                        // ---------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            const Text(
                              "Price",

                              style: TextStyle(color: Colors.grey),
                            ),

                            Text(
                              "₹${item.price ?? 0}",

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // ---------------------------------------
                        // TOTAL VALUE
                        // ---------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            const Text(
                              "Total Value",

                              style: TextStyle(color: Colors.grey),
                            ),

                            Text(
                              "₹${controller.totalValue.value.toStringAsFixed(2)}",

                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // ---------------------------------------
                        // SUPPLIER
                        // ---------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            const Text(
                              "Supplier",

                              style: TextStyle(color: Colors.grey),
                            ),

                            Flexible(
                              child: Text(
                                item.supplier ?? "N/A",

                                textAlign: TextAlign.end,

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // ---------------------------------------
                        // RECEIVED DATE
                        // ---------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            const Text(
                              "Received Date",

                              style: TextStyle(color: Colors.grey),
                            ),

                            Text(
                              item.receivedDate ?? "N/A",

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // =============================================
                  // STOCK ACTIONS
                  // =============================================
                  const Text(
                    "Stock Actions",

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    " Stock Out Count",

                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: controller.count,
                    decoration: InputDecoration(
                      hintText: "Enter the count",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.deepPurple.shade100,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      // -----------------------------------------
                      // STOCK IN
                      const SizedBox(width: 10),

                      // -----------------------------------------
                      // STOCK OUT
                      // -----------------------------------------
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.stockupdate();
                            Get.snackbar("Stock Out", "Stock Out selected");
                          },

                          icon: const Icon(Icons.remove),

                          label: const Text("Stock Out"),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,

                            foregroundColor: Colors.white,

                            padding: const EdgeInsets.symmetric(vertical: 15),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // =============================================
                  // MOVEMENT HISTORY
                  // =============================================
                  const SizedBox(height: 30),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
