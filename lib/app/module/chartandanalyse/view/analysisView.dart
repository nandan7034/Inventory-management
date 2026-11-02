import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/module/chartandanalyse/chartController/chartCnt.dart';

import 'package:flutter_application_1/app/routes/appPage/appPage.dart';

import 'package:get/get.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Analytics",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurpleAccent,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              controller.refreshAnalytics();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshAnalytics,

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.report);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple.shade500,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Reports",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.stockhistory);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple.shade500,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Stock History",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 10),
                _sectionTitle("Inventory Overview"),

                const SizedBox(height: 12),

                _inventoryCards(),

                const SizedBox(height: 25),

                _sectionTitle("Stock Movement"),

                const SizedBox(height: 12),

                _stockMovementCard(),

                const SizedBox(height: 25),

                _sectionTitle("Category Analysis"),

                const SizedBox(height: 12),

                _categoryQuantityCard(),

                const SizedBox(height: 25),

                _sectionTitle("Inventory Value"),

                const SizedBox(height: 12),

                _categoryValueCard(),

                const SizedBox(height: 25),

                _sectionTitle("Stock Status"),

                const SizedBox(height: 12),

                _stockStatusCard(),

                const SizedBox(height: 25),

                _sectionTitle("Fast Moving Items"),

                const SizedBox(height: 12),

                _fastMovingCard(),

                const SizedBox(height: 25),

                _sectionTitle("Slow Moving Items"),

                const SizedBox(height: 12),

                _slowMovingCard(),

                const SizedBox(height: 25),

                _sectionTitle("Reorder Suggestions"),

                const SizedBox(height: 12),

                _reorderCard(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
    );
  }

  // =========================================================
  // INVENTORY CARDS
  // =========================================================

  Widget _inventoryCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                title: "Total Items",
                value: controller.totalItems.value.toString(),
                icon: Icons.inventory_2_outlined,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _statCard(
                title: "Quantity",
                value: controller.totalQuantity.value.toString(),
                icon: Icons.numbers,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _statCard(
                title: "Inventory Value",
                value:
                    "₹${controller.totalInventoryValue.value.toStringAsFixed(0)}",
                icon: Icons.currency_rupee,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _statCard(
                title: "Low Stock",
                value: controller.lowStock.value.toString(),
                icon: Icons.warning_amber_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, size: 27),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // =========================================================
  // STOCK MOVEMENT
  // =========================================================

  Widget _stockMovementCard() {
    final stockIn = controller.totalStockIn.value;

    final stockOut = controller.totalStockOut.value;

    final maxValue = [stockIn, stockOut, 1].reduce((a, b) => a > b ? a : b);

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Stock In vs Stock Out",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 250,

            child: BarChart(
              BarChartData(
                maxY: maxValue.toDouble() + 10,

                alignment: BarChartAlignment.spaceAround,

                barGroups: [
                  BarChartGroupData(
                    x: 0,

                    barRods: [
                      BarChartRodData(
                        toY: stockIn.toDouble(),
                        width: 45,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ],
                  ),

                  BarChartGroupData(
                    x: 1,

                    barRods: [
                      BarChartRodData(
                        toY: stockOut.toDouble(),
                        width: 45,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ],
                  ),
                ],

                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,

                      getTitlesWidget: (value, meta) {
                        if (value == 0) {
                          return const Text("Stock In");
                        }

                        if (value == 1) {
                          return const Text("Stock Out");
                        }

                        return const Text("");
                      },
                    ),
                  ),
                ),

                borderData: FlBorderData(show: false),

                gridData: const FlGridData(show: true),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              _movementValue("Stock In", stockIn),

              _movementValue("Stock Out", stockOut),
            ],
          ),
        ],
      ),
    );
  }

  Widget _movementValue(String title, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // =========================================================
  // CATEGORY QUANTITY
  // =========================================================

  Widget _categoryQuantityCard() {
    if (controller.categoryQuantity.isEmpty) {
      return _emptyCard("No category data available");
    }

    return _card(
      child: SizedBox(
        height: 300,

        child: PieChart(
          PieChartData(
            sectionsSpace: 3,

            centerSpaceRadius: 50,

            sections: controller.categoryQuantity.entries.map((entry) {
              return PieChartSectionData(
                value: entry.value.toDouble(),

                title: entry.value.toString(),

                radius: 80,

                titleStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // CATEGORY VALUE
  // =========================================================

  Widget _categoryValueCard() {
    if (controller.categoryValue.isEmpty) {
      return _emptyCard("No category value available");
    }

    final entries = controller.categoryValue.entries.toList();

    return _card(
      child: Column(
        children: [
          ...entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),

              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),

                  Text(
                    "₹${entry.value.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // =========================================================
  // STOCK STATUS
  // =========================================================

  Widget _stockStatusCard() {
    return _card(
      child: Column(
        children: [
          _statusRow(
            title: "In Stock",
            value: controller.inStock.value,
            icon: Icons.check_circle,
          ),

          const Divider(),

          _statusRow(
            title: "Low Stock",
            value: controller.lowStockCount.value,
            icon: Icons.warning,
          ),

          const Divider(),

          _statusRow(
            title: "Out of Stock",
            value: controller.outOfStock.value,
            icon: Icons.cancel,
          ),
        ],
      ),
    );
  }

  Widget _statusRow({
    required String title,
    required int value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        children: [
          Icon(icon),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FAST MOVING
  // =========================================================

  Widget _fastMovingCard() {
    if (controller.fastMovingItems.isEmpty) {
      return _emptyCard("No stock movement data");
    }

    return _card(
      child: Column(
        children: controller.fastMovingItems.map((item) {
          return _itemMovementRow(item);
        }).toList(),
      ),
    );
  }

  // =========================================================
  // SLOW MOVING
  // =========================================================

  Widget _slowMovingCard() {
    if (controller.slowMovingItems.isEmpty) {
      return _emptyCard("No stock movement data");
    }

    return _card(
      child: Column(
        children: controller.slowMovingItems.map((item) {
          return _itemMovementRow(item);
        }).toList(),
      ),
    );
  }

  Widget _itemMovementRow(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,

            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),

              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(Icons.inventory_2_outlined),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  item["itemName"]?.toString() ?? "Unknown",

                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  "ID: ${item["itemId"] ?? ""}",

                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          Text(
            "${item["quantity"] ?? 0}",

            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // REORDER
  // =========================================================

  Widget _reorderCard() {
    if (controller.reorderItems.isEmpty) {
      return _emptyCard("No items need restocking");
    }

    return _card(
      child: Column(
        children: controller.reorderItems.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),

            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,

                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),

                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: const Icon(Icons.warning_amber_rounded),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        item["itemName"]?.toString() ?? "Unknown",

                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Category: ${item["category"]}",

                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text(
                      "${item["quantity"]} units",

                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      "Reorder",
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // =========================================================
  // COMMON CARD
  // =========================================================

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.grey.shade200),
      ),

      child: child,
    );
  }

  // =========================================================
  // EMPTY
  // =========================================================

  Widget _emptyCard(String message) {
    return _card(
      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Center(
          child: Text(message, style: const TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
