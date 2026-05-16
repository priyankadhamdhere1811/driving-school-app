import 'package:flutter/foundation.dart';

import '../models/reminder_model.dart';
import '../services/reminder_service.dart';

class ReminderProvider extends ChangeNotifier {
  final ReminderService _reminderService;

  ReminderProvider({ReminderService? reminderService})
    : _reminderService = reminderService ?? ReminderService();

  final List<ReminderModel> _reminders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ReminderModel> get reminders => List.unmodifiable(_reminders);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> fetchReminders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedReminders = await _reminderService.fetchReminders();
      _reminders
        ..clear()
        ..addAll(fetchedReminders);
      return true;
    } catch (error) {
      _reminders.clear();
      _errorMessage = 'Unable to load reminders. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
