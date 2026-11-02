import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/module/reports/reportcontroller/reportCnt.dart';

import 'package:get/get.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Reports",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Export Management Reports",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Select a report and choose PDF or Excel format.",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 25),

              const Text(
                "Report Type",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,

                padding: const EdgeInsets.symmetric(horizontal: 15),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedReport.value,

                    isExpanded: true,

                    items: controller.reportTypes.map((report) {
                      return DropdownMenuItem<String>(
                        value: report,
                        child: Text(report),
                      );
                    }).toList(),

                    onChanged: (value) {
                      if (value != null) {
                        controller.selectReport(value);
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              _reportInfo(),

              const SizedBox(height: 30),

              const Text(
                "Export Format",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _exportButton(
                      icon: Icons.picture_as_pdf,
                      title: "PDF",
                      onPressed: controller.loading.value
                          ? null
                          : () {
                              controller.exportPdf();
                            },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _exportButton(
                      icon: Icons.table_chart,
                      title: "Excel",
                      onPressed: controller.loading.value
                          ? null
                          : () {
                              controller.exportExcel();
                            },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (controller.loading.value)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      }),
    );
  }

  // ==================================================
  // REPORT INFORMATION
  // ==================================================

  Widget _reportInfo() {
    String description = "";

    switch (controller.selectedReport.value) {
      case "Stock Summary":
        description =
            "Shows all inventory items with SKU, category, quantity, price and total value.";
        break;

      case "Low Stock":
        description = "Shows items with quantity at or below 5 units.";
        break;

      case "Dead Stock":
        description = "Shows items with no movement for 30 or more days.";
        break;

      case "Movement History":
        description = "Shows stock in and stock out movement history.";
        break;

      case "Category Value":
        description = "Shows total inventory value grouped by category.";
        break;
    }

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.08),

        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Icon(Icons.description_outlined, color: Colors.deepPurple),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  controller.selectedReport.value,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,

                  style: const TextStyle(color: Colors.grey, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // EXPORT BUTTON
  // ==================================================

  Widget _exportButton({
    required IconData icon,
    required String title,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,

      icon: Icon(icon),

      label: Text(title),

      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),

        backgroundColor: Colors.deepPurple,

        foregroundColor: Colors.white,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
