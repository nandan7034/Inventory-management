class ReceivingItemModel {
  String? id;
  String? itemName;
  String? category;
  int? quantity;
  double? price;
  String? supplier;
  String? receivedDate;
  String? image;
  String? status;
  String? barcode;

  ReceivingItemModel({
    this.id,
    this.itemName,
    this.category,
    this.quantity,
    this.price,
    this.supplier,
    this.receivedDate,
    this.image,
    this.status,
    this.barcode,
  });

  factory ReceivingItemModel.fromJson(Map<String, dynamic> json) {
    return ReceivingItemModel(
      id: json['id'],
      itemName: json['itemName'],
      category: json['category'],
      quantity: json['quantity'],
      price: (json['price'] as num?)?.toDouble(),
      supplier: json['supplier'],
      receivedDate: json['receivedDate'],
      image: json['image'],
      status: json['status'],
      barcode: json['barcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'category': category,
      'quantity': quantity,
      'price': price,
      'supplier': supplier,
      'receivedDate': receivedDate,
      'image': image,
      'status': status,
      'barcode': barcode,
    };
  }

  Map<String, dynamic> OutTojson() {
    return {
      'id': id,
      'quantity': quantity,
      'price': price,
      'image': image,
      'status': status,
      'barcode': barcode,
    };
  }
}
