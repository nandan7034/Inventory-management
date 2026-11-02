class AnalyticsCategoryModel {
  final String category;
  final int quantity;
  final double value;

  AnalyticsCategoryModel({
    required this.category,
    required this.quantity,
    required this.value,
  });
}

class StockMovementModel {
  final String date;
  final int stockIn;
  final int stockOut;

  StockMovementModel({
    required this.date,
    required this.stockIn,
    required this.stockOut,
  });
}

class ItemMovementModel {
  final String itemId;
  final String itemName;
  final int quantity;

  ItemMovementModel({
    required this.itemId,
    required this.itemName,
    required this.quantity,
  });
}