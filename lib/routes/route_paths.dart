/// Centralized route paths for GoRouter navigation.
class RoutePaths {
  RoutePaths._();

  // Root Shell Tabs
  static const String home = '/';
  static const String sell = '/sell';
  static const String buy = '/buy';
  static const String repair = '/repair';
  static const String profile = '/profile';
  static const String search = '/search';

  // Auth Flow
  static const String login = '/login';
  static const String otp = '/otp';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Sell Sub-flows
  static const String sellBrands = '/sell/brands';
  static const String sellModels = '/sell/models';
  static const String sellVariants = '/sell/variants';
  static const String sellQuestionnaire = '/sell/questionnaire';
  static const String sellDiagnostics = '/sell/diagnostics';
  static const String sellQuoteResult = '/sell/quote-result';
  static const String sellPickupSchedule = '/sell/pickup-schedule';

  // Buy & Marketplace Sub-flows
  static const String productDetail = '/buy/product/:id';
  static const String productCompare = '/buy/compare';
  static const String wishlist = '/buy/wishlist';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';

  // Repair Sub-flows
  static const String repairIssues = '/repair/issues';
  static const String repairBooking = '/repair/booking';
  static const String repairTracking = '/repair/tracking/:orderId';

  // Profile & Wallet Sub-flows
  static const String wallet = '/wallet';
  static const String referral = '/referral';
  static const String orders = '/orders';
  static const String addresses = '/addresses';
  static const String supportChat = '/support-chat';
  static const String notifications = '/notifications';
}
