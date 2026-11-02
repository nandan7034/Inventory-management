import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ReportService {
  // ==================================================
  // PDF
  // ==================================================

  static Future<void> generatePdf({
    required String reportName,
    required List<Map<String, dynamic>> data,
  }) async {
    final pdf = pw.Document();

    if (data.isEmpty) {
      return;
    }

    final headers =
        data.first.keys.toList();

    final rows = data.map((item) {
      return headers.map((header) {
        return item[header]?.toString() ?? "";
      }).toList();
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Text(
              "Precision Warehouse Management",
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 8),

            pw.Text(
              reportName,
              style: pw.TextStyle(
                fontSize: 16,
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Table.fromTextArray(
              headers: headers,
              data: rows,
              headerStyle:
                  pw.TextStyle(
                fontWeight:
                    pw.FontWeight.bold,
              ),
              cellStyle:
                  const pw.TextStyle(
                fontSize: 8,
              ),
            ),
          ];
        },
      ),
    );

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
      "${directory.path}/"
      "${_fileName(reportName)}.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text:
          "Precision Warehouse - $reportName",
    );
  }

  // ==================================================
  // EXCEL
  // ==================================================

  static Future<void> generateExcel({
    required String reportName,
    required List<Map<String, dynamic>> data,
  }) async {
    final excel = Excel.createExcel();

    final sheet =
        excel["Report"];

    if (data.isEmpty) {
      return;
    }

    final headers =
        data.first.keys.toList();

    // Header
    for (int i = 0;
        i < headers.length;
        i++) {
      sheet
          .cell(
            CellIndex.indexByColumnRow(
              columnIndex: i,
              rowIndex: 0,
            ),
          )
          .value = TextCellValue(
        headers[i],
      );
    }

    // Data
    for (int row = 0;
        row < data.length;
        row++) {
      for (int column = 0;
          column < headers.length;
          column++) {
        final value =
            data[row][headers[column]];

        final cell =
            sheet.cell(
          CellIndex.indexByColumnRow(
            columnIndex: column,
            rowIndex: row + 1,
          ),
        );

        if (value is int) {
          cell.value =
              IntCellValue(value);
        } else if (value is double) {
          cell.value =
              DoubleCellValue(value);
        } else {
          cell.value =
              TextCellValue(
            value?.toString() ?? "",
          );
        }
      }
    }

    final directory =
        await getApplicationDocumentsDirectory();

    final filePath =
        "${directory.path}/"
        "${_fileName(reportName)}.xlsx";

    final bytes = excel.encode();

    if (bytes == null) {
      return;
    }

    final file = File(filePath);

    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text:
          "Precision Warehouse - $reportName",
    );
  }

  // ==================================================
  // FILE NAME
  // ==================================================

  static String _fileName(
    String name,
  ) {
    return name
        .toLowerCase()
        .replaceAll(" ", "_")
        .replaceAll(
          RegExp(r'[^a-z0-9_]'),
          "",
        );
  }
}