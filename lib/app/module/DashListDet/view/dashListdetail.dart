import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/module/StockMovment/stockController/stockController.dart';
import 'package:get/get.dart';

class DashListDetail extends GetView<Stockcnt> {
  const DashListDetail({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive selected Firestore item
    final Map<String, dynamic> item = Get.arguments as Map<String, dynamic>;

    // Read item details
    final String name = (item['itemName'] ?? 'No name').toString();
    final String category = (item['category'] ?? '-').toString();
    final String barcode = (item['barcode'] ?? 'N/A').toString();
    final String supplier = (item['supplier'] ?? 'N/A').toString();
    final String image = (item['image'] ?? '').toString();
    final String receivedDate = (item['receivedDate'] ?? 'N/A').toString();

    final int quantity = (item['quantity'] as num?)?.toInt() ?? 0;

    final double price = (item['price'] as num?)?.toDouble() ?? 0.0;

    final double totalValue = quantity * price;

    final bool inStock = quantity > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Item Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ITEM IMAGE AND INFORMATION
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
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.inventory_2_outlined,
                                size: 60,
                              ),
                            ),
                          )
                        : const Icon(Icons.inventory_2_outlined, size: 60),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    category,
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  ),

                  const SizedBox(height: 12),

                  Chip(
                    label: SelectableText("Barcode: $barcode"),
                    backgroundColor: Colors.deepPurple.withOpacity(0.1),
                    labelStyle: const TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CURRENT STOCK
            const Text(
              "Current Stock",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$quantity",
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

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: inStock
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          inStock ? "In Stock" : "Out of Stock",
                          style: TextStyle(
                            color: inStock ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 30),

                  _detailRow("Price", "₹$price"),

                  const SizedBox(height: 14),

                  _detailRow(
                    "Total Value",
                    "₹${totalValue.toStringAsFixed(2)}",
                    valueColor: Colors.deepPurple,
                  ),

                  const SizedBox(height: 14),

                  _detailRow("Supplier", supplier),

                  const SizedBox(height: 14),

                  _detailRow("Received Date", receivedDate),
                  const SizedBox(height: 14),
                  _detailRow("Barcode", barcode),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // STOCK ACTIONS

            // Add your Stock In / Stock Out buttons here.
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
