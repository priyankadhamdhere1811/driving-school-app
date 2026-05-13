class PaymentModel {
  final String id;
  final String studentId;
  final num amount;
  final String paymentMethod;
  final DateTime? paymentDate;
  final String notes;

  const PaymentModel({
    required this.id,
    required this.studentId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
    required this.notes,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: _readString(map, ['id']),
      studentId: _readString(map, ['student_id', 'studentId']),
      amount: _readNumber(map, ['amount', 'payment_amount']),
      paymentMethod: _readString(map, [
        'payment_method',
        'method',
        'paymentMode',
      ]),
      paymentDate: _readDate(map, ['payment_date', 'date', 'created_at']),
      notes: _readString(map, ['notes', 'note', 'remarks']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'student_id': studentId,
      'amount': amount,
      'payment_method': paymentMethod,
      'payment_date': _dateToJson(paymentDate),
      'notes': notes,
    };
  }

  String get amountText {
    final value =
        amount % 1 == 0 ? amount.toInt().toString() : amount.toStringAsFixed(2);
    return 'Rs $value';
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
}
