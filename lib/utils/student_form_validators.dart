import '../models/student_model.dart';

class StudentFormValidators {
  static String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return 'Full name is required';
    }
    if (name.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (RegExp(r'^\d+$').hasMatch(name)) {
      return 'Full name cannot contain only numbers';
    }
    return null;
  }

  static String? validateMobile(String? value, {bool required = true}) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return required ? 'Mobile number is required' : null;
    }

    final normalized = normalizeIndianMobile(input);
    if (normalized == null) {
      return 'Enter a valid 10-digit mobile number';
    }

    return null;
  }

  static String? validatePositiveAmount(String? value, String label) {
    final amount = _parseAmount(value);
    if (amount == null) {
      return '$label must be a valid amount';
    }
    if (amount <= 0) {
      return '$label must be greater than 0';
    }
    return null;
  }

  static String? validateNonNegativeAmount(String? value, String label) {
    final amount = _parseAmount(value);
    if (amount == null) {
      return '$label must be a valid amount';
    }
    if (amount < 0) {
      return '$label cannot be negative';
    }
    return null;
  }

  static String? validateDuration(String? value) {
    final duration = int.tryParse(value?.trim() ?? '');
    if (duration == null) {
      return 'Enter duration in days';
    }
    if (duration <= 0) {
      return 'Duration must be greater than 0';
    }
    if (duration > 365) {
      return 'Duration cannot be more than 365 days';
    }
    return null;
  }

  static String? normalizeIndianMobile(String value) {
    var digits = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (digits.startsWith('+')) {
      digits = digits.substring(1);
    }
    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return null;
    }
    if (digits.length == 12 && digits.startsWith('91')) {
      digits = digits.substring(2);
    }
    if (digits.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(digits)) {
      return null;
    }
    return digits;
  }

  static bool hasDuplicateMobile(
    Iterable<StudentModel> students,
    String mobileNumber, {
    String? excludingStudentId,
  }) {
    final normalized = normalizeIndianMobile(mobileNumber);
    if (normalized == null) {
      return false;
    }

    return students.any((student) {
      if (excludingStudentId != null && student.id == excludingStudentId) {
        return false;
      }
      return normalizeIndianMobile(student.mobileNumber) == normalized;
    });
  }

  static num? _parseAmount(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    return num.tryParse(trimmed);
  }
}
