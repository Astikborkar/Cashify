/// Backend API endpoint constants matching architecture.md specifications.
class ApiEndpoints {
  ApiEndpoints._();

  // Base API configuration
  static const String baseUrl = 'https://api.cashifyclone.in/api/v1';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Authentication
  static const String requestOtp = '/auth/request-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String googleAuth = '/auth/google';
  static const String appleAuth = '/auth/apple';
  static const String emailLogin = '/auth/email/login';
  static const String emailRegister = '/auth/email/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Profile & Addresses
  static const String userProfile = '/profile/me';
  static const String addresses = '/profile/addresses';
  static const String bankAccounts = '/profile/bank-accounts';

  // Catalog Master
  static const String categories = '/catalog/categories';
  static const String searchCatalog = '/catalog/search';
  static String categoryBrands(String categoryId) => '/catalog/categories/$categoryId/brands';
  static String brandModels(String brandId) => '/catalog/brands/$brandId/models';
  static String modelVariants(String modelId) => '/catalog/models/$modelId/variants';
  static String modelSpecs(String modelId) => '/catalog/models/$modelId/specs';
  static String categoryQuestions(String categoryId) => '/catalog/categories/$categoryId/questions';

  // Sell & Diagnostics
  static const String validateImei = '/sell/validate-imei';
  static const String calculateQuote = '/sell/calculate-quote';
  static const String lockQuote = '/sell/lock-quote';
  static const String initDiagnosticsSession = '/sell/diagnostics/session';
  static String submitDiagnosticResult(String sessionId) => '/sell/diagnostics/$sessionId/test-result';
  static String diagnosticSummary(String sessionId) => '/sell/diagnostics/$sessionId/summary';
  static const String sellOrders = '/sell/orders';

  // Buy Refurbished & Marketplace
  static const String marketplaceProducts = '/marketplace/products';
  static const String hotDeals = '/marketplace/deals';
  static const String wishlist = '/marketplace/wishlist';
  static const String cart = '/marketplace/cart';
  static const String cartItems = '/marketplace/cart/items';
  static const String applyCoupon = '/marketplace/coupons/apply';
  static const String checkout = '/marketplace/checkout';
  static const String verifyPayment = '/marketplace/payments/verify';

  // Repair Services
  static const String repairCategories = '/repairs/categories';
  static const String repairEstimate = '/repairs/estimate';
  static const String bookRepair = '/repairs/book';
  static String repairTracking(String orderId) => '/repairs/orders/$orderId/tracking';

  // Wallet & Referral
  static const String walletBalance = '/wallet/balance';
  static const String walletTransactions = '/wallet/transactions';
  static const String walletWithdraw = '/wallet/withdraw';
  static const String referralCode = '/referral/code';
  static const String referralStats = '/referral/stats';
  static const String referralLeaderboard = '/referral/leaderboard';

  // Notifications & Support
  static const String notifications = '/notifications';
  static const String registerPushToken = '/notifications/push-token';
  static const String supportChat = '/support/chat';
}
