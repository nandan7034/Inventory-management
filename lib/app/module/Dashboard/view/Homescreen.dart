import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/core/widgets/homenavigation/homenavCnt.dart';
import 'package:flutter_application_1/app/module/Dashboard/dashcontroller/dashCtrl.dart';
import 'package:flutter_application_1/app/routes/appPage/appPage.dart';
import 'package:get/get.dart';

const _primary = Colors.deepPurple;
const _bg = Color(0xFFF6F5FB);
const _ink = Color(0xFF0F172A);
const _muted = Color(0xFF64748B);

class Dashboard extends GetView<DashCntrl> {
  Dashboard({super.key});

  // Local reactive state (move these into DashCntrl later if you want
  // the selection to survive tab switches).
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;

  static const List<(String, IconData)> categories = [
    ('All', Icons.apps_rounded),
    ('Electronics', Icons.laptop_rounded),
    ('Furniture', Icons.chair_rounded),
    ('Food', Icons.restaurant_rounded),
    ('Clothing', Icons.checkroom_rounded),
    ('Stationery', Icons.edit_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: StreamBuilder(
          stream: controller.itemstream,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text("Error: ${snap.error}"));
            }
            if (!snap.hasData || snap.data!.docs.isEmpty) {
              return _emptyState(
                icon: Icons.inventory_2_outlined,
                text: "No items found",
              );
            }

            final items = snap.data!.docs.map((d) => d.data()).toList();

            final totalQuantity = items.fold<int>(0, (s, d) => s + _qty(d));
            final totalValue = items.fold<double>(
              0,
              (s, d) => s + _qty(d) * _price(d),
            );
            final lowStock = items.where((d) => _qty(d) < 5).length;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                _header(lowStock),
                const SizedBox(height: 20),
                const Text(
                  "Inventory Overview",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Track your stock at a glance",
                  style: TextStyle(color: _muted),
                ),
                const SizedBox(height: 16),
                _searchField(),
                const SizedBox(height: 16),

                // ---- Stats ----
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.25,
                  children: [
                    _statCard(
                      label: "Total Items",
                      value: items.length.toString(),
                      icon: Icons.inventory_2_rounded,
                      color: Colors.purple,
                    ),
                    _statCard(
                      label: "Total Quantity",
                      value: totalQuantity.toString(),
                      icon: Icons.inventory_rounded,
                      color: Colors.blue,
                    ),
                    _statCard(
                      label: "Total Value",
                      value: totalValue.toStringAsFixed(2),
                      icon: Icons.account_balance_wallet_rounded,
                      color: Colors.green,
                    ),
                    _statCard(
                      label: "Low Stock",
                      value: lowStock.toString(),
                      icon: Icons.warning_amber_rounded,
                      color: Colors.deepOrange,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ---- Quick actions ----
                _sectionTitle("Quick Actions"),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _quickAction(
                        label: "Stock In",
                        icon: Icons.arrow_downward_rounded,
                        color: Colors.green,
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: _quickAction(
                        label: "Stock Out",
                        icon: Icons.arrow_upward_rounded,
                        color: Colors.deepOrange,
                        onTap: () => Get.toNamed(AppRoutes.stockmovement),
                      ),
                    ),
                    Expanded(
                      child: _quickAction(
                        label: "Add Item",
                        icon: Icons.add_rounded,
                        color: _primary,
                        onTap: () => Get.toNamed(AppRoutes.addItem),
                      ),
                    ),
                    Expanded(
                      child: _quickAction(
                        label: "Low Stock",
                        icon: Icons.timelapse_rounded,
                        color: Colors.orange,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ---- History banner ----
                _historyBanner(lowStock),
                const SizedBox(height: 24),

                // ---- Categories ----
                _sectionTitle("Categories"),
                const SizedBox(height: 12),

                SizedBox(
                  height: 42,
                  child: Obx(() {
                    final currentCategory = selectedCategory.value;

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final (name, icon) = categories[index];
                        final isSelected = currentCategory == name;

                        return GestureDetector(
                          onTap: () {
                            selectedCategory.value = name;
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? _primary : Colors.white,
                              borderRadius: BorderRadius.circular(21),
                              border: Border.all(
                                color: isSelected
                                    ? _primary
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  size: 17,
                                  color: isSelected ? Colors.white : _muted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : _ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),

                const SizedBox(height: 24),

                // ---- Recent entries (filtered) ----
                Obx(() {
                  final cat = selectedCategory.value;
                  final q = searchQuery.value;
                  final filtered = items.where((d) {
                    final category = (d['category'] ?? '').toString();
                    final name = (d['itemName'] ?? '').toString().toLowerCase();
                    final matchesCat = cat == 'All' || category == cat;
                    final matchesQuery =
                        q.isEmpty ||
                        name.contains(q) ||
                        category.toLowerCase().contains(q);
                    return matchesCat && matchesQuery;
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _sectionTitle("Recent Entries"),
                          const Spacer(),
                          Text(
                            "${filtered.length} items",
                            style: const TextStyle(color: _muted, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (filtered.isEmpty)
                        _emptyState(
                          icon: Icons.search_off_rounded,
                          text: "No matching items",
                        )
                      else
                        for (final d in filtered) _itemTile(d),
                    ],
                  );
                }),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.addItem),
        backgroundColor: _primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Item", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Pieces
  // ---------------------------------------------------------------------

  Widget _header(int lowStock) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warehouse_rounded, size: 18, color: _primary),
              SizedBox(width: 6),
              Text(
                "Main Warehouse",
                style: TextStyle(fontWeight: FontWeight.w600, color: _primary),
              ),
            ],
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_none_rounded, color: _ink),
            ),
            if (lowStock > 0)
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 21,
          backgroundColor: _primary.withValues(alpha: 0.15),
          child: const Icon(Icons.person_rounded, color: _primary),
        ),
      ],
    );
  }

  Widget _searchField() {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: c, width: w),
    );

    return TextField(
      onChanged: (v) => searchQuery.value = v.trim().toLowerCase(),
      decoration: InputDecoration(
        hintText: "Search items or categories",
        hintStyle: const TextStyle(color: _muted),
        prefixIcon: const Icon(Icons.search_rounded, color: _muted),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: border(Colors.transparent),
        enabledBorder: border(Colors.transparent),
        focusedBorder: border(_primary, 1.5),
      ),
    );
  }

  Widget _historyBanner(int lowStock) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      // Switches the bottom-nav tab so the navbar stays visible.
      onTap: () => Get.find<Homenavcnt>().navchnage(1),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF7043), Color(0xFFE64A19)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withValues(alpha: 0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.history_rounded, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Check history movements",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lowStock > 0
                        ? "$lowStock items are running low"
                        : "All items are well stocked",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _itemTile(Map<String, dynamic> d) {
    final qty = _qty(d);
    final low = qty < 5;
    final statusColor = low ? Colors.red : Colors.green;
    final image = (d['image'] ?? '').toString();

    Widget placeholder() =>
        const Icon(Icons.image_not_supported_outlined, color: _muted, size: 26);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 64,
              height: 64,
              color: Colors.grey.shade100,
              child: image.isEmpty
                  ? placeholder()
                  : Image.network(
                      image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stack) => placeholder(),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (d['itemName'] ?? 'Unnamed').toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (d['category'] ?? '-').toString(),
                  style: const TextStyle(color: _muted, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  "Qty: $qty",
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              low ? "Low Stock" : "In Stock",
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------

int _qty(Map<String, dynamic> d) => (d['quantity'] as num?)?.toInt() ?? 0;

double _price(Map<String, dynamic> d) => (d['price'] as num?)?.toDouble() ?? 0;

BoxDecoration _cardDecoration([double radius = 18]) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(radius),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ],
);

Widget _sectionTitle(String text) => Text(
  text,
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: _ink,
  ),
);

Widget _emptyState({required IconData icon, required String text}) => Center(
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(text, style: const TextStyle(color: _muted)),
      ],
    ),
  ),
);

Widget _statCard({
  required String label,
  required String value,
  required IconData icon,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: _cardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          // width: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 45, color: color),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _muted,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _quickAction({
  required String label,
  required IconData icon,
  required Color color,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _ink,
          ),
        ),
      ],
    ),
  );
}
