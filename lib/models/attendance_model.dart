class AttendanceModel {
  final String id;
  final String studentId;
  final DateTime? attendanceDate;
  final String status;
  final bool otpVerified;
  final DateTime? createdAt;

  const AttendanceModel({
    required this.id,
    required this.studentId,
    required this.attendanceDate,
    required this.status,
    required this.otpVerified,
    required this.createdAt,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: _readString(map, ['id']),
      studentId: _readString(map, ['student_id', 'studentId']),
      attendanceDate: _readDate(map, ['attendance_date', 'attendanceDate']),
      status: _readString(map, ['status'], fallback: 'Absent'),
      otpVerified: _readBool(map, ['otp_verified', 'otpVerified']),
      createdAt: _readDate(map, ['created_at', 'createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'student_id': studentId,
      'attendance_date': _dateToJson(attendanceDate),
      'status': status,
      'otp_verified': otpVerified,
    };
  }

  bool get isPresent => status.toLowerCase() == 'present';

  static String _readString(
    Map<String, dynamic> map,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = map[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return fallback;
  }

  static bool _readBool(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is bool) {
        return value;
      }
      if (value is String) {
        return value.toLowerCase() == 'true';
      }
    }

    return false;
  }

  static DateTime? _readDate(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is DateTime) {
        return value;
      }
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value);
      }
    }

    return null;
  }

  static String? _dateToJson(DateTime? date) {
    if (date == null) {
      return null;
    }

    return date.toIso8601String().split('T').first;
  }
}
