import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/customer.dart';

class CustomerProvider with ChangeNotifier {
  final List<Customer> _customers = [];
  Customer? _currentCustomer;

  List<Customer> get customers => _customers;
  Customer? get currentCustomer => _currentCustomer;

  List<Customer> get elDokkiCustomers {
    return _customers.where((c) => c.isElDokkiResident).toList();
  }

  double get totalBalance {
    return _customers.fold(0, (sum, customer) => sum + customer.balance);
  }

  double get averageBalance {
    if (_customers.isEmpty) return 0;
    return totalBalance / _customers.length;
  }

  int get elDokkiCustomersCount {
    return _customers.where((c) => c.isElDokkiResident).length;
  }

  CustomerProvider() {
    _initializeCustomers();
  }

  void _initializeCustomers() {
    _customers.addAll([
      Customer(
        id: const Uuid().v4(),
        name: 'Ahmed Hassan',
        email: 'ahmed.hassan@email.com',
        phone: '+201234567890',
        address: 'El-Dokki, Giza',
        balance: 1500.0,
        isElDokkiResident: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Customer(
        id: const Uuid().v4(),
        name: 'Fatma Ali',
        email: 'fatma.ali@email.com',
        phone: '+201234567891',
        address: 'El-Dokki, Giza',
        balance: 2200.0,
        isElDokkiResident: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      Customer(
        id: const Uuid().v4(),
        name: 'Mohamed Saeed',
        email: 'mohamed.saeed@email.com',
        phone: '+201234567892',
        address: 'Maadi, Cairo',
        balance: 800.0,
        isElDokkiResident: false,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Customer(
        id: const Uuid().v4(),
        name: 'Nour Mahmoud',
        email: 'nour.mahmoud@email.com',
        phone: '+201234567893',
        address: 'El-Dokki, Giza',
        balance: 3000.0,
        isElDokkiResident: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Customer(
        id: const Uuid().v4(),
        name: 'Omar Khaled',
        email: 'omar.khaled@email.com',
        phone: '+201234567894',
        address: 'Heliopolis, Cairo',
        balance: 1200.0,
        isElDokkiResident: false,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ]);
    notifyListeners();
  }

  bool registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String address,
    required double initialBalance,
  }) {
    if (_customers.any((c) => c.email == email)) {
      return false;
    }

    final isElDokki = address.toLowerCase().contains('el-dokki') ||
        address.toLowerCase().contains('dokki');

    final customer = Customer(
      id: const Uuid().v4(),
      name: name,
      email: email,
      phone: phone,
      address: address,
      balance: initialBalance,
      isElDokkiResident: isElDokki,
      createdAt: DateTime.now(),
    );

    _customers.add(customer);
    notifyListeners();
    return true;
  }

  bool loginCustomer(String email) {
    try {
      _currentCustomer = _customers.firstWhere((c) => c.email == email);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logoutCustomer() {
    _currentCustomer = null;
    notifyListeners();
  }

  bool addBalance(String customerId, double amount) {
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index != -1 && amount > 0) {
      _customers[index] = _customers[index].copyWith(
        balance: _customers[index].balance + amount,
      );

      if (_currentCustomer?.id == customerId) {
        _currentCustomer = _customers[index];
      }

      notifyListeners();
      return true;
    }
    return false;
  }

  bool deductBalance(String customerId, double amount) {
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index != -1 && _customers[index].balance >= amount) {
      _customers[index] = _customers[index].copyWith(
        balance: _customers[index].balance - amount,
      );

      if (_currentCustomer?.id == customerId) {
        _currentCustomer = _customers[index];
      }

      notifyListeners();
      return true;
    }
    return false;
  }

  Customer? getCustomer(String customerId) {
    try {
      return _customers.firstWhere((c) => c.id == customerId);
    } catch (e) {
      return null;
    }
  }

  bool hasSufficientBalance(String customerId, double amount) {
    final customer = getCustomer(customerId);
    return customer != null && customer.balance >= amount;
  }

  void updateCustomer(Customer customer) {
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      _customers[index] = customer;

      if (_currentCustomer?.id == customer.id) {
        _currentCustomer = customer;
      }

      notifyListeners();
    }
  }

  void deleteCustomer(String customerId) {
    _customers.removeWhere((c) => c.id == customerId);

    if (_currentCustomer?.id == customerId) {
      _currentCustomer = null;
    }

    notifyListeners();
  }

  List<Customer> searchCustomers(String query) {
    if (query.isEmpty) return _customers;

    return _customers.where((customer) {
      return customer.name.toLowerCase().contains(query.toLowerCase()) ||
          customer.email.toLowerCase().contains(query.toLowerCase()) ||
          customer.phone.contains(query);
    }).toList();
  }

  bool isEmailTaken(String email) {
    return _customers.any((c) => c.email == email);
  }
}
