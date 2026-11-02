import 'package:flutter/material.dart';

import 'package:flutter_application_1/app/core/widgets/homenavigation/homenavCnt.dart';
import 'package:flutter_application_1/app/module/Dashboard/view/Homescreen.dart';
import 'package:flutter_application_1/app/module/chartandanalyse/view/analysisView.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class Homenagivation extends GetView<Homenavcnt> {
  const Homenagivation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.selectindex.value) {
          case 0:
            return Dashboard();

          case 1:
            return const AnalyticsView();

          case 2:
            return const Center(
              child: Text('Profile Screen', style: TextStyle(fontSize: 22)),
            );

          default:
            return Dashboard();
            print("done");  
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectindex.value,
          onTap: controller.navchnage,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              label: 'Reports',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
