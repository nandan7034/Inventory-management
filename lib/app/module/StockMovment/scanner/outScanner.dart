import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

class OutBarcodeScanner extends StatefulWidget {
  const OutBarcodeScanner({super.key});

  @override
  State<OutBarcodeScanner> createState() => _OutBarcodeScannerState();
}

class _OutBarcodeScannerState extends State<OutBarcodeScanner> {
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan Barcode'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Camera Scanner
          MobileScanner(
            onDetect: (BarcodeCapture capture) {
              if (isScanned) return;

              final List<Barcode> barcodes = capture.barcodes;

              if (barcodes.isNotEmpty) {
                final String? value = barcodes.first.rawValue;

                if (value != null && value.isNotEmpty) {
                  isScanned = true;

                  Get.back(result: value);
                }
              }
            },
          ),

          // Scanner Box
          Center(
            child: Container(
              width: 280,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Bottom Text
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Place the barcode inside the box',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
