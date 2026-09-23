/// Validation utilities including standard forms and client-side IMEI Luhn algorithm.
class Validators {
  Validators._();

  /// Validates standard 10-digit Indian mobile numbers
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final clean = value.replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
    final phoneRegex = RegExp(r'^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[6789]\d{9}$');
    if (!phoneRegex.hasMatch(clean)) {
      return 'Please enter a valid 10-digit Indian mobile number';
    }
    return null;
  }

  /// Validates standard email address
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates 6-digit OTP
  static String? validateOtp(String? value) {
    if (value == null || value.trim().length != 6) {
      return 'Please enter a complete 6-digit OTP';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'OTP must contain numbers only';
    }
    return null;
  }

  /// Validates 15-digit IMEI using the Luhn Checksum Algorithm (Mod 10)
  static String? validateImei(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IMEI is required';
    }
    final imei = value.replaceAll(RegExp(r'\s+'), '');
    if (imei.length != 15) {
      return 'IMEI must be exactly 15 digits long';
    }
    if (!RegExp(r'^\d{15}$').hasMatch(imei)) {
      return 'IMEI must contain digits only';
    }

    // Luhn algorithm verification
    int sum = 0;
    for (int i = 0; i < 14; i++) {
      int digit = int.parse(imei[i]);
      if (i % 2 != 0) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      sum += digit;
    }
    final checkDigit = (10 - (sum % 10)) % 10;
    if (checkDigit != int.parse(imei[14])) {
      return 'Invalid IMEI checksum. Please check and re-enter';
    }

    return null;
  }
}
