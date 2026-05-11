import 'package:flutter/foundation.dart';

/// Keeps enquiry counts available to owner dashboard screens.
/// Real enquiry forms and persistence can update this later.
class EnquiryProvider extends ChangeNotifier {
  int _openEnquiries = 0;

  int get openEnquiries => _openEnquiries;

  void addEnquiry() {
    _openEnquiries++;
    notifyListeners();
  }

  void closeEnquiry() {
    if (_openEnquiries == 0) {
      return;
    }

    _openEnquiries--;
    notifyListeners();
  }
}
