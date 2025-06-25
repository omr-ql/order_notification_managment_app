class Product {
  final String serialNumber;
  final String name;
  final String vendor;
  final String category;
  final double price;
  int stock;

  Product({
    required this.serialNumber,
    required this.name,
    required this.vendor,
    required this.category,
    required this.price,
    required this.stock,
  });

  Map<String, dynamic> toJson() {
    return {
      'serialNumber': serialNumber,
      'name': name,
      'vendor': vendor,
      'category': category,
      'price': price,
      'stock': stock,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      serialNumber: json['serialNumber'],
      name: json['name'],
      vendor: json['vendor'],
      category: json['category'],
      price: json['price'].toDouble(),
      stock: json['stock'],
    );
  }

  Product copyWith({
    String? serialNumber,
    String? name,
    String? vendor,
    String? category,
    double? price,
    int? stock,
  }) {
    return Product(
      serialNumber: serialNumber ?? this.serialNumber,
      name: name ?? this.name,
      vendor: vendor ?? this.vendor,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }
}
