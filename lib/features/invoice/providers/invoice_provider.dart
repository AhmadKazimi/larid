import 'package:flutter/material.dart';
import '../../../core/models/customer.dart';
import '../../../core/models/invoice_item.dart';

class InvoiceProvider with ChangeNotifier {
  Customer? _customer;
  List<InvoiceItem> _items = [];
  String _invoiceNumber = '';
  String _comments = '';
  double _totalAmount = 0.0;
  double _totalTax = 0.0;

  // Getters
  Customer get customer => _customer!;
  List<InvoiceItem> get items => _items;
  String get invoiceNumber => _invoiceNumber;
  String get comments => _comments;
  double get totalAmount => _totalAmount;
  double get totalTax => _totalTax;
  double get grandTotal => _totalAmount + _totalTax;

  bool get hasCustomer => _customer != null;
  bool get hasItems => _items.isNotEmpty;

  // Setters
  void setCustomer(Customer customer) {
    _customer = customer;
    notifyListeners();
  }

  void setInvoiceNumber(String invoiceNumber) {
    _invoiceNumber = invoiceNumber;
    notifyListeners();
  }

  void setComments(String comments) {
    _comments = comments;
    notifyListeners();
  }

  // Add a new item to the invoice
  void addItem(InvoiceItem item) {
    _items.add(item);
    _recalculateTotals();
    notifyListeners();
  }

  // Update an existing item in the invoice
  void updateItem(int index, InvoiceItem item) {
    if (index >= 0 && index < _items.length) {
      _items[index] = item;
      _recalculateTotals();
      notifyListeners();
    }
  }

  // Remove an item from the invoice
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      _recalculateTotals();
      notifyListeners();
    }
  }

  // Clear all items from the invoice
  void clearItems() {
    _items = [];
    _recalculateTotals();
    notifyListeners();
  }

  // Clear the entire invoice
  void clearInvoice() {
    _customer = null;
    _items = [];
    _invoiceNumber = '';
    _comments = '';
    _totalAmount = 0.0;
    _totalTax = 0.0;
    notifyListeners();
  }

  // Generate a new invoice number
  void generateInvoiceNumber() {
    // Generate a unique invoice reference number
    // This could be based on date, customer, sequential number, etc.
    final now = DateTime.now();
    final dateStr =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

    _invoiceNumber = 'INV-$dateStr-$timeStr';
    notifyListeners();
  }

  // Recalculate invoice totals
  void _recalculateTotals() {
    _totalAmount = 0.0;
    _totalTax = 0.0;

    for (var item in _items) {
      _totalAmount += item.subtotal;
      _totalTax += item.taxAmount;
    }
  }
}
