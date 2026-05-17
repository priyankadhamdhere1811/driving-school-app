import 'package:flutter/foundation.dart';

import '../models/attendance_model.dart';
import '../services/attendance_service.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceService _attendanceService;

  AttendanceProvider({AttendanceService? attendanceService})
    : _attendanceService = attendanceService ?? AttendanceService();

  final List<AttendanceModel> _attendanceRecords = [];
  bool _isLoading = false;
  String? _loadingStudentId;
  String? _verifyingStudentId;
  String? _errorMessage;
  String? _generatedOtpForTesting;
  String? _generatedOtpStudentId;

  List<AttendanceModel> get attendanceRecords =>
      List.unmodifiable(_attendanceRecords);
  bool get isLoading => _isLoading;
  String? get loadingStudentId => _loadingStudentId;
  String? get verifyingStudentId => _verifyingStudentId;
  String? get errorMessage => _errorMessage;
  String? get generatedOtpForTesting => _generatedOtpForTesting;
  String? get generatedOtpStudentId => _generatedOtpStudentId;
  int get presentToday => _attendanceRecords.where(_isPresentToday).length;

  Future<bool> fetchAttendance() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedRecords = await _attendanceService.fetchAttendance();
      _attendanceRecords
        ..clear()
        ..addAll(fetchedRecords);
      return true;
    } catch (error) {
      _errorMessage = 'Unable to load attendance. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> generateOtp(String studentId) async {
    _loadingStudentId = studentId;
    _errorMessage = null;
    notifyListeners();

    try {
      _generatedOtpForTesting = await _attendanceService.generateOtp(studentId);
      _generatedOtpStudentId = studentId;
      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _loadingStudentId = null;
      notifyListeners();
    }
  }

  Future<bool> verifyOtpAndMarkAttendance(String studentId, String otp) async {
    _loadingStudentId = null;
    _verifyingStudentId = studentId;
    _errorMessage = null;
    notifyListeners();

    try {
      await _attendanceService.verifyOtpAndMarkAttendance(studentId, otp);
      _generatedOtpForTesting = null;
      _generatedOtpStudentId = null;
      await fetchAttendance();
      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _loadingStudentId = null;
      _verifyingStudentId = null;
      notifyListeners();
    }
  }

  Future<bool> fetchAttendanceByStudentId(String studentId) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _refreshStudentAttendance(studentId);
      return true;
    } catch (error) {
      _errorMessage = 'Unable to load attendance. Please try again.';
      return false;
    } finally {
      notifyListeners();
    }
  }

  bool isPresentToday(String studentId) {
    return _attendanceRecords.any(
      (record) => record.studentId == studentId && _isPresentToday(record),
    );
  }

  DateTime? lastAttendedDate(String studentId) {
    final records =
        _attendanceRecords
            .where(
              (record) => record.studentId == studentId && record.isPresent,
            )
            .toList()
          ..sort((a, b) {
            final aDate =
                a.attendanceDate ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDate =
                b.attendanceDate ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bDate.compareTo(aDate);
          });

    return records.isEmpty ? null : records.first.attendanceDate;
  }

  int attendanceCount(String studentId) {
    return _attendanceRecords
        .where((record) => record.studentId == studentId && record.isPresent)
        .length;
  }

  int attendanceTotalCount(String studentId) {
    return _attendanceRecords
        .where((record) => record.studentId == studentId)
        .length;
  }

  int attendancePercentage(String studentId) {
    final totalCount = attendanceTotalCount(studentId);
    if (totalCount == 0) {
      return 0;
    }

    return ((attendanceCount(studentId) / totalCount) * 100).round();
  }

  void resetAttendance() {
    _attendanceRecords.clear();
    _isLoading = false;
    _loadingStudentId = null;
    _verifyingStudentId = null;
    _generatedOtpForTesting = null;
    _generatedOtpStudentId = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _refreshStudentAttendance(String studentId) async {
    final fetchedRecords = await _attendanceService.fetchAttendanceByStudentId(
      studentId,
    );
    _attendanceRecords.removeWhere((record) => record.studentId == studentId);
    _attendanceRecords.addAll(fetchedRecords);
  }

  bool _isPresentToday(AttendanceModel record) {
    final date = record.attendanceDate;
    final now = DateTime.now();

    return record.isPresent &&
        date != null &&
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
