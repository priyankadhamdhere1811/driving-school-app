class EnquiryModel {
  final String id;
  final String fullName;
  final String mobileNumber;
  final String interestedCourse;
  final String message;
  final String status;
  final DateTime? createdAt;

  const EnquiryModel({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.interestedCourse,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  EnquiryModel copyWith({
    String? id,
    String? fullName,
    String? mobileNumber,
    String? interestedCourse,
    String? message,
    String? status,
    DateTime? createdAt,
  }) {
    return EnquiryModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      interestedCourse: interestedCourse ?? this.interestedCourse,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory EnquiryModel.fromMap(Map<String, dynamic> map) {
    return EnquiryModel(
      id: _readString(map, ['id']),
      fullName: _readString(map, ['full_name', 'name', 'fullName']),
      mobileNumber: _readString(map, [
        'mobile_number',
        'mobile',
        'phone',
        'mobileNumber',
      ]),
      interestedCourse: _readString(map, [
        'interested_course',
        'course',
        'interestedCourse',
      ]),
      message: _readString(map, ['message', 'notes']),
      status: _readString(map, ['status'], fallback: 'New'),
      createdAt: _readDate(map, ['created_at', 'createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'full_name': fullName,
      'mobile_number': mobileNumber,
      'interested_course': interestedCourse,
      'message': message,
      'status': status,
    };
  }

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
