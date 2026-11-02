import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/module/Additem/controller/additem_controller.dart';
import 'package:get/get.dart';

class AddItemView extends GetView<AddItemController> {
  const AddItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Add New Item',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: controller.resetForm,
            icon: const Icon(Icons.refresh_rounded, size: 18, color: Colors.deepPurple),
            label: const Text(
              'Reset',
              style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name
                _buildLabel('Item Name *'),
                TextFormField(
                  controller: controller.itemNameController,
                  decoration: _inputDecoration(
                    hint: 'e.g. Dell XPS 15 Laptop, Office Chair',
                    prefixIcon: Icons.inventory_2_outlined,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Barcode / SKU
                _buildLabel('Barcode / SKU (Optional)'),
                TextFormField(
                  controller: controller.BarcodeController,
                  decoration: _inputDecoration(
                    hint: 'Scan or type barcode',
                    prefixIcon: Icons.qr_code_scanner_rounded,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.camera_alt_rounded, color: Colors.deepPurple),
                      onPressed: () => controller.scannedcode(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category Selector
                _buildLabel('Category *'),
                const SizedBox(height: 6),
                _buildCategorySelector(),
                const SizedBox(height: 16),

                // Quantity & Price Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Quantity *'),
                          Row(
                            children: [
                              _buildQtyBtn(icon: Icons.remove, onTap: controller.decrementQuantity),
                              const SizedBox(width: 6),
                              Expanded(
                                child: TextFormField(
                                  controller: controller.quantityController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: _inputDecoration(hint: '1', isDense: true),
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return 'Required';
                                    final n = int.tryParse(val.trim());
                                    if (n == null || n <= 0) return '> 0';
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 6),
                              _buildQtyBtn(icon: Icons.add, onTap: controller.incrementQuantity),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Unit Price (₹) *'),
                          TextFormField(
                            controller: controller.priceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: _inputDecoration(hint: '0.00', prefixText: '₹ '),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'Required';
                              final n = double.tryParse(val.trim());
                              if (n == null || n < 0) return 'Invalid';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Dynamic Total Batch Value
                Obx(() {
                  final total = controller.totalValue.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.deepPurple.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Batch Value:',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.deepPurple),
                        ),
                        Text(
                          '₹ ${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.deepPurple.shade800,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Supplier
                _buildLabel('Supplier / Vendor Name'),
                TextFormField(
                  controller: controller.supplierController,
                  decoration: _inputDecoration(
                    hint: 'e.g. Apex Global Distributors',
                    prefixIcon: Icons.storefront_outlined,
                  ),
                ),
                const SizedBox(height: 16),

                // Received Date & Status
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Received Date'),
                          InkWell(
                            onTap: () => controller.pickDate(context),
                            borderRadius: BorderRadius.circular(12),
                            child: IgnorePointer(
                              child: TextFormField(
                                controller: controller.receivedDateController,
                                decoration: _inputDecoration(
                                  hint: 'YYYY-MM-DD',
                                  prefixIcon: Icons.calendar_today_rounded,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Status'),
                          Obx(() {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: controller.selectedStatus.value,
                                  isExpanded: true,
                                  items: controller.statuses.map((s) {
                                    return DropdownMenuItem(
                                      value: s,
                                      child: Text(s, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) controller.setStatus(val);
                                  },
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Submit Button
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.saveItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Save & Add to Inventory',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade800),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.categories.map((cat) {
          final name = cat['name'] as String;
          final icon = cat['icon'] as IconData;
          final isSelected = controller.selectedCategory.value == name;

          return InkWell(
            onTap: () => controller.setCategory(name),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepPurple : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.blueGrey),
                  const SizedBox(width: 6),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildQtyBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.deepPurple.shade200),
        ),
        child: Icon(icon, size: 18, color: Colors.deepPurple.shade700),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    IconData? prefixIcon,
    String? prefixText,
    bool isDense = false,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20, color: Colors.deepPurple.shade400) : null,
      prefixText: prefixText,
      prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 14),
      isDense: isDense,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
      ),
    );
  }
}

                                            