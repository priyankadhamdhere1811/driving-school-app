class ReminderModel {
  final String id;
  final String studentId;
  final String reminderType;
  final String title;
  final String message;
  final DateTime? dueDate;
  final String status;
  final DateTime? createdAt;

  const ReminderModel({
    required this.id,
    required this.studentId,
    required this.reminderType,
    required this.title,
    required this.message,
    required this.dueDate,
    required this.status,
    required this.createdAt,
  });

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: _readString(map, ['id']),
      studentId: _readString(map, ['student_id', 'studentId']),
      reminderType: _readString(map, ['reminder_type', 'reminderType']),
      title: _readString(map, ['title']),
      message: _readString(map, ['message']),
      dueDate: _readDate(map, ['due_date', 'dueDate']),
      status: _readString(map, ['status']),
      createdAt: _readDate(map, ['created_at', 'createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'student_id': studentId,
      'reminder_type': reminderType,
      'title': title,
      'message': message,
      'due_date': _dateToJson(dueDate),
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get dueDateText {
    if (dueDate == null) {
      return '-';
    }

    final day = dueDate!.day.toString().padLeft(2, '0');
    final month = dueDate!.month.toString().padLeft(2, '0');
    return '$day/$month/${dueDate!.year}';
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
