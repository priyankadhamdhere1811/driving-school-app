class Validators {
  static String? requiredName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  static String? mobileNumber(String? value) {
    if (value == null || value.trim().length < 10) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }
}
