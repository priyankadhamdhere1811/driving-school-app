import 'package:flutter/foundation.dart';

import '../models/payment_model.dart';
import '../services/payment_service.dart';
import '../services/student_service.dart';

/// Tracks payment state for dashboards and payment screens.
class PaymentProvider extends ChangeNotifier {
  final PaymentService _paymentService;
  final StudentService _studentService;

  PaymentProvider({
    PaymentService? paymentService,
    StudentService? studentService,
  }) : _paymentService = paymentService ?? PaymentService(),
       _studentService = studentService ?? StudentService();

  final List<PaymentModel> _payments = [];
  int _paymentCount = 0;
  bool _isLoading = false;
  String? _errorMessage;

  List<PaymentModel> get payments => List.unmodifiable(_payments);
  int get paymentCount => _paymentCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> fetchPayments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedPayments = await _paymentService.fetchPayments();
      _payments
        ..clear()
        ..addAll(fetchedPayments);
      _paymentCount = _payments.length;
      return true;
    } catch (error) {
      _payments.clear();
      _paymentCount = 0;
      _errorMessage = 'Unable to load payments. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  Future<bool> createPayment(PaymentModel payment) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _paymentService.createPayment(payment);
      final fetchedPayments = await _paymentService.fetchPaymentsByStudentId(
        payment.studentId,
      );
      final student = await _studentService.fetchStudentById(payment.studentId);
      if (student == null) {
        _errorMessage = 'Unable to update student financial summary.';
        return false;
      }

      final totalPaid = fetchedPayments.fold<num>(
        0,
        (total, item) => total + item.amount,
      );
      final remainingFees = student.totalFees - totalPaid;
      final status = _statusFor(totalPaid, remainingFees);

      await _studentService.updateStudentFinancials(
        payment.studentId,
        totalPaid,
        remainingFees < 0 ? 0 : remainingFees,
        status,
      );

      _payments
        ..clear()
        ..addAll(fetchedPayments);
      _paymentCount = _payments.length;
      return true;
    } catch (error) {
      _errorMessage = 'Unable to save payment. Please try again.';
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

  String _statusFor(num totalPaid, num remainingFees) {
    if (remainingFees <= 0) {
      return 'Completed';
    }

    if (totalPaid == 0) {
      return 'Pending Payment';
    }

    return 'Active';
  }
}
