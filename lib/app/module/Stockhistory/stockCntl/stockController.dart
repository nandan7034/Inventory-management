import 'package:get/get.dart';

class StockhistoryController extends GetxController {
  final selectedFilter = 'All'.obs;
  final searchText = ''.obs;

  final movements = <Map<String, dynamic>>[
    {
      'type': 'Stock In',
      'item': 'Laptop',
      'sku': 'SKU-1023',
      'quantity': 25,
      'date': '10 Oct 2026',
      'time': '10:30 AM',
      'description': 'Supplier delivery',
    },
    {
      'type': 'Stock Out',
      'item': 'Office Chair',
      'sku': 'SKU-2041',
      'quantity': -5,
      'date': '10 Oct 2026',
      'time': '09:15 AM',
      'description': 'Order #1023',
    },
    {
      'type': 'Stock In',
      'item': 'Keyboard',
      'sku': 'SKU-3012',
      'quantity': 15,
      'date': '09 Oct 2026',
      'time': '04:20 PM',
      'description': 'Supplier delivery',
    },
    {
      'type': 'Stock Out',
      'item': 'Monitor',
      'sku': 'SKU-4011',
      'quantity': -8,
      'date': '09 Oct 2026',
      'time': '11:00 AM',
      'description': 'Customer order',
    },
  ].obs;

  List<Map<String, dynamic>> get filteredMovements {
    return movements.where((movement) {
      final type = movement['type'].toString();
      final item = movement['item'].toString().toLowerCase();
      final sku = movement['sku'].toString().toLowerCase();
      final query = searchText.value.toLowerCase();

      final matchesFilter =
          selectedFilter.value == 'All' || type == selectedFilter.value;

      final matchesSearch = item.contains(query) || sku.contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  int get totalIn => movements
      .where((m) => m['type'] == 'Stock In')
      .fold<int>(0, (sum, m) => sum + (m['quantity'] as int));

  int get totalOut => movements
      .where((m) => m['type'] == 'Stock Out')
      .fold<int>(0, (sum, m) => sum + (m['quantity'] as int).abs());

  int get netMovement => totalIn - totalOut;

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void search(String value) {
    searchText.value = value;
  }
}
