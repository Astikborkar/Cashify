/// Application-wide constants for Cashify Clone.
class AppConstants {
  AppConstants._();

  static const String appName = 'Cashify Clone';
  static const String appTagline = 'India\'s Largest Re-Commerce Marketplace';
  static const String appVersion = '1.0.0';

  // SLA & Business Logic Defaults
  static const int quoteLockDays = 7;
  static const int standardWarrantyMonths = 6;
  static const int extendedWarrantyMonths = 12;
  static const int maxComparisonItems = 3;

  // Local Storage Box Names (Hive)
  static const String authBoxName = 'cashify_auth_box';
  static const String userPreferencesBox = 'cashify_user_prefs';
  static const String cartBoxName = 'cashify_cart_box';
  static const String offlineCatalogBox = 'cashify_catalog_cache';

  // Secure Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyBiometricEnabled = 'biometric_enabled';

  // Support Contacts
  static const String supportPhone = '+91 98765 43210';
  static const String supportEmail = 'support@cashifyclone.in';
}
