import 'package:flutter/foundation.dart';

import '../models/payment_model.dart';
import '../services/payment_service.dart';

/// Tracks payment state for dashboards and payment screens.
class PaymentProvider extends ChangeNotifier {
  final PaymentService _paymentService;

  PaymentProvider({PaymentService? paymentService})
    : _paymentService = paymentService ?? PaymentService();

  final List<PaymentModel> _payments = [];
  int _paymentCount = 0;
  bool _isLoading = false;
  String? _errorMessage;

  List<PaymentModel> get payments => List.unmodifiable(_payments);
  int get paymentCount => _paymentCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> fetchPaymentsByStudentId(String studentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedPayments = await _paymentService.fetchPaymentsByStudentId(
        studentId,
      );
      _payments
        ..clear()
        ..addAll(fetchedPayments);
      _paymentCount = _payments.length;
      return true;
    } catch (error) {
      _payments.clear();
      _paymentCount = 0;
      _errorMessage = 'Unable to load payment history. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addPayment() {
    _paymentCount++;
    notifyListeners();
  }

  void resetPayments() {
    _payments.clear();
    _paymentCount = 0;
    _errorMessage = null;
    notifyListeners();
  }
}
