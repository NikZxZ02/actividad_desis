class Product {
  final int? id;
  final String code;
  final String description;
  final String unitPrice;
  final int active;

  Product(
      {this.id,
      required this.code,
      required this.description,
      required this.unitPrice,
      required this.active});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: null,
      code: json['code'],
      description: json['description'],
      unitPrice: json['unitPrice'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'unitPrice': unitPrice,
      'active': active,
    };
  }
}
