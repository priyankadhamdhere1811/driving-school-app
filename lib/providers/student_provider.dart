import 'package:flutter/foundation.dart';

import '../models/student_model.dart';
import '../services/student_service.dart';

/// Manages student list state for owner screens.
/// Student screens read from here while Supabase access stays in the service.
class StudentProvider extends ChangeNotifier {
  final StudentService _studentService;

  StudentProvider({StudentService? studentService})
    : _studentService = studentService ?? StudentService();

  final List<StudentModel> _students = [];
  StudentModel? _selectedStudent;
  bool _isLoading = false;
  String? _errorMessage;

  List<StudentModel> get students => List.unmodifiable(_students);
  StudentModel? get selectedStudent => _selectedStudent;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> fetchStudents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedStudents = await _studentService.fetchStudents();
      _students
        ..clear()
        ..addAll(fetchedStudents);
      return true;
    } catch (error) {
      _errorMessage = 'Unable to load students. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createStudent(StudentModel student) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _studentService.createStudent(student);
      final fetchedStudents = await _studentService.fetchStudents();
      _students
        ..clear()
        ..addAll(fetchedStudents);
      return true;
    } catch (error) {
      _errorMessage = 'Unable to save student. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> fetchStudentById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedStudent = null;
    notifyListeners();

    try {
      _selectedStudent = await _studentService.fetchStudentById(id);
      return _selectedStudent != null;
    } catch (error) {
      _errorMessage = 'Unable to load student details. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearStudents() {
    _students.clear();
    notifyListeners();
  }
}
