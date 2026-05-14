class OtpVerificationModel {
  final String id;
  final String studentId;
  final String otpCode;
  final bool isVerified;
  final DateTime? expiresAt;
  final DateTime? verifiedAt;
  final DateTime? createdAt;

  const OtpVerificationModel({
    required this.id,
    required this.studentId,
    required this.otpCode,
    required this.isVerified,
    required this.expiresAt,
    required this.verifiedAt,
    required this.createdAt,
  });

  factory OtpVerificationModel.fromMap(Map<String, dynamic> map) {
    return OtpVerificationModel(
      id: _readString(map, ['id']),
      studentId: _readString(map, ['student_id', 'studentId']),
      otpCode: _readString(map, ['otp_code']),
      isVerified: _readBool(map, ['is_verified', 'verified']),
      expiresAt: _readDate(map, ['expires_at', 'expiresAt']),
      verifiedAt: _readDate(map, ['verified_at', 'verifiedAt']),
      createdAt: _readDate(map, ['created_at', 'createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'student_id': studentId,
      'otp_code': otpCode,
      'is_verified': isVerified,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
    };
  }

  static String _readString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return '';
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
}
