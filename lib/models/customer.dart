class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  double balance;
  final bool isElDokkiResident;
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.balance,
    required this.isElDokkiResident,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'balance': balance,
      'isElDokkiResident': isElDokkiResident,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      balance: json['balance'].toDouble(),
      isElDokkiResident: json['isElDokkiResident'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Customer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    double? balance,
    bool? isElDokkiResident,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      balance: balance ?? this.balance,
      isElDokkiResident: isElDokkiResident ?? this.isElDokkiResident,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
