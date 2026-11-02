class StockMovementModel {
  String? id;
  String? itemId;
  String? itemName;
  String? type;
  int? quantity;
  String? date;
  String? reason;

  StockMovementModel({
    this.id,
    this.itemId,
    this.itemName,
    this.type,
    this.quantity,
    this.date,
    this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'itemName': itemName,
      'type': type,
      'quantity': quantity,
      'date': date,
      'reason': reason,
    };
  }
}
