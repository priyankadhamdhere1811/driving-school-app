import 'package:flutter/foundation.dart';

/// Manages student list state for owner screens.
/// Backend data can replace the placeholder list later.
class StudentProvider extends ChangeNotifier {
  final List<String> _students = ['Amit Sharma', 'Neha Singh'];

  List<String> get students => List.unmodifiable(_students);

  void addStudent(String name) {
    _students.add(name);
    notifyListeners();
  }

  void clearStudents() {
    _students.clear();
    notifyListeners();
  }
}
