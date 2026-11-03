
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/module/Stockhistory/stockCntl/stockController.dart';
import 'package:flutter_application_1/app/routes/appPage/appPage.dart';
import 'package:get/get.dart';

class Stockhistory extends GetView<StockhistoryController> {
  const Stockhistory({super.key});

  static const background = Color(0xFFF5F7FB);
  static const navy = Color(0xFF17243A);
  static const green = Color(0xFF15966A);
  static const orange = Color(0xFFEA7839);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.getStockHistory,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // HEADER
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.offNamed(AppRoutes.dashboard);
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 12),

                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7EAFE),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.swap_vert_rounded,
                            color: Color(0xFF5B5BD6),
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stock Movements',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: navy,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Inventory activity overview',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: controller.getStockHistory,
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // SUMMARY PANEL
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: navy,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'NET STOCK MOVEMENT',
                            style: TextStyle(
                              color: Color(0xFFB8C5D9),
                              fontSize: 11,
                              letterSpacing: 1.2,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Obx(
                            () => Text(
                              '${controller.netMovement >= 0 ? '+' : ''}'
                              '${controller.netMovement} units',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => _summaryTile(
                                    title: 'Stock In',
                                    value: '+${controller.totalIn}',
                                    icon: Icons.south_west_rounded,
                                    color: const Color(0xFF65D6A5),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Obx(
                                  () => _summaryTile(
                                    title: 'Stock Out',
                                    value: '-${controller.totalOut}',
                                    icon: Icons.north_east_rounded,
                                    color: const Color(0xFFFFB27B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // SEARCH
                    TextField(
                      controller: controller.searchText,
                      onChanged: controller.search,
                      decoration: InputDecoration(
                        hintText: 'Search item name or barcode...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.searchText.clear();
                            controller.search('');
                          },
                          icon: const Icon(Icons.close),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // FILTERS
                    Obx(
                      () => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Stock In', 'Stock Out'].map(
                            (filter) {
                              final selected =
                                  controller.selectedFilter.value == filter;

                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(filter),
                                  selected: selected,
                                  onSelected: (_) {
                                    controller.changeFilter(filter);
                                  },
                                  selectedColor: navy,
                                  backgroundColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: selected ? Colors.white : navy,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // RECENT ACTIVITY HEADER
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Recent Activity',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: navy,
                            ),
                          ),
                        ),

                        Obx(
                          () => Text(
                            '${controller.filteredMovements.length} records',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                  ]),
                ),
              ),

              // MOVEMENT LIST
              Obx(() {
                if (controller.loading.value) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final movements = controller.filteredMovements;

                if (movements.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 55,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No matching movements found',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final movement = movements[index];

                        final isIn = movement['type'] == 'Stock In';
                        final color = isIn ? green : orange;

                        final quantity =
                            (movement['quantity'] as num?)?.toInt() ?? 0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE9EDF4),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // MOVEMENT ICON
                                Container(
                                  height: 46,
                                  width: 46,
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    isIn
                                        ? Icons.south_west_rounded
                                        : Icons.north_east_rounded,
                                    color: color,
                                    size: 24,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // ITEM INFORMATION
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movement['item']?.toString() ??
                                            'Unknown Item',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: navy,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        'Barcode: ${movement['sku'] ?? 'N/A'}',
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 12,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        movement['description']?.toString() ??
                                            '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 12,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 12,
                                            color: Colors.blueGrey,
                                          ),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              '${movement['date'] ?? 'N/A'}'
                                              ' · ${movement['time'] ?? ''}',
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // QUANTITY
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${quantity > 0 ? '+' : ''}$quantity',
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isIn ? 'Stock In' : 'Stock Out',
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: movements.length,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // SUMMARY TILE
  Widget _summaryTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFB8C5D9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
