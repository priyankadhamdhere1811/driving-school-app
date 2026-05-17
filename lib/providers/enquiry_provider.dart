import 'package:flutter/foundation.dart';

import '../models/enquiry_model.dart';
import '../services/enquiry_service.dart';

class EnquiryProvider extends ChangeNotifier {
  final EnquiryService _enquiryService;

  EnquiryProvider({EnquiryService? enquiryService})
    : _enquiryService = enquiryService ?? EnquiryService();

  final List<EnquiryModel> _enquiries = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EnquiryModel> get enquiries => List.unmodifiable(_enquiries);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get openEnquiries =>
      _enquiries.where((enquiry) => enquiry.status != 'Closed').length;

  Future<bool> fetchEnquiries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedEnquiries = await _enquiryService.fetchEnquiries();
      _enquiries
        ..clear()
        ..addAll(fetchedEnquiries);
      return true;
    } catch (error) {
      _errorMessage = 'Unable to load enquiries. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createEnquiry(EnquiryModel enquiry) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final createdEnquiry = await _enquiryService.createEnquiry(enquiry);
      _enquiries.insert(0, createdEnquiry);
      return true;
    } catch (error) {
      _errorMessage = 'Unable to submit enquiry. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addEnquiry() {
    notifyListeners();
  }

  void closeEnquiry() {
    notifyListeners();
  }
}
