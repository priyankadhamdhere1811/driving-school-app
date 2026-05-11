class StudentModel {
  final String id;
  final String fullName;
  final String mobileNumber;
  final String alternateMobile;
  final String areaVillage;
  final String address;
  final String course;
  final String duration;
  final num totalFees;
  final num paidAmount;
  final num remainingFees;
  final String status;
  final String preferredBatch;
  final DateTime? startDate;
  final DateTime? nextPaymentDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String notes;

  const StudentModel({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.alternateMobile,
    required this.areaVillage,
    required this.address,
    required this.course,
    required this.duration,
    required this.totalFees,
    required this.paidAmount,
    required this.remainingFees,
    required this.status,
    required this.preferredBatch,
    required this.startDate,
    required this.nextPaymentDate,
    required this.createdAt,
    required this.updatedAt,
    required this.notes,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel.fromMap(json);
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: _readString(map, ['id']),
      fullName: _readString(map, ['full_name', 'name', 'student_name']),
      mobileNumber: _readString(map, ['mobile_number', 'mobile', 'phone']),
      alternateMobile: _readString(map, [
        'alternate_mobile',
        'alternate_mobile_number',
        'alternate_phone',
      ]),
      areaVillage: _readString(map, ['area_village', 'area', 'village']),
      address: _readString(map, ['address']),
      course: _readString(map, ['course', 'course_name']),
      duration: _readString(map, ['duration']),
      totalFees: _readNumber(map, ['total_fees', 'totalFees']),
      paidAmount: _readNumber(map, [
        'paid_amount',
        'advance_paid',
        'paid',
        'advance',
      ]),
      remainingFees: _readNumber(map, ['remaining_fees', 'remaining']),
      status: _readString(map, ['status'], fallback: 'Active'),
      preferredBatch: _readString(map, [
        'preferred_time_slot',
        'preferred_batch',
        'batch',
      ]),
      startDate: _readDate(map, ['start_date', 'startDate']),
      nextPaymentDate: _readDate(map, ['next_payment_date', 'nextPaymentDate']),
      createdAt: _readDate(map, ['created_at', 'createdAt']),
      updatedAt: _readDate(map, ['updated_at', 'updatedAt']),
      notes: _readString(map, ['notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'full_name': fullName,
      'mobile_number': mobileNumber,
      'alternate_mobile': alternateMobile,
      'area_village': areaVillage,
      'address': address,
      'course': course,
      'duration': duration,
      'start_date': _dateToJson(startDate),
      'preferred_batch': preferredBatch,
      'total_fees': totalFees,
      'advance_paid': paidAmount,
      'remaining_fees': remainingFees,
      'next_payment_date': _dateToJson(nextPaymentDate),
      'notes': notes,
      'status': status,
    };
  }

  String get totalFeesText => _formatAmount(totalFees);
  String get paidAmountText => _formatAmount(paidAmount);
  String get remainingFeesText => _formatAmount(remainingFees);

  String get displayStatus {
    if (status.isNotEmpty) {
      return status;
    }

    return remainingFees > 0 ? 'Pending Payment' : 'Active';
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

  static num _readNumber(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is num) {
        return value;
      }
      if (value is String) {
        return num.tryParse(value) ?? 0;
      }
    }

    return 0;
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

  static String _formatAmount(num value) {
    if (value == 0) {
      return 'Rs 0';
    }

    final amount =
        value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
    return 'Rs $amount';
  }
}
