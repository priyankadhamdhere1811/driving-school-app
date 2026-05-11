import 'package:flutter/foundation.dart';

/// Stores attendance state for daily and batch attendance views.
/// This is intentionally static until backend attendance is introduced.
class AttendanceProvider extends ChangeNotifier {
  int _presentToday = 0;

  int get presentToday => _presentToday;

  void markAttendance() {
    _presentToday++;
    notifyListeners();
  }

  void resetAttendance() {
    _presentToday = 0;
    notifyListeners();
  }
}
