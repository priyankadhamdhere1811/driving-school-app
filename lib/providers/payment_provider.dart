import 'package:flutter/foundation.dart';

/// Tracks payment state for dashboards and payment screens.
/// Supabase payment records can be connected here in a later phase.
class PaymentProvider extends ChangeNotifier {
  int _paymentCount = 0;

  int get paymentCount => _paymentCount;

  void addPayment() {
    _paymentCount++;
    notifyListeners();
  }

  void resetPayments() {
    _paymentCount = 0;
    notifyListeners();
  }
}
