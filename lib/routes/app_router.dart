import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/otp_verification_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/buy/presentation/screens/buy_screen.dart';
import '../features/buy/presentation/screens/product_compare_screen.dart';
import '../features/buy/presentation/screens/product_detail_screen.dart';
import '../features/buy/presentation/screens/wishlist_screen.dart';
import '../features/cart/presentation/screens/cart_screen.dart';
import '../features/cart/presentation/screens/checkout_screen.dart';
import '../features/cart/presentation/screens/order_success_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/home/presentation/screens/search_screen.dart';
import '../features/main_shell/presentation/screens/main_shell_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/orders/presentation/screens/order_history_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/saved_addresses_screen.dart';
import '../features/referral/presentation/screens/referral_screen.dart';
import '../features/repair/presentation/screens/repair_booking_screen.dart';
import '../features/repair/presentation/screens/repair_screen.dart';
import '../features/repair/presentation/screens/technician_tracking_screen.dart';
import '../features/support/presentation/screens/support_chat_screen.dart';
import '../features/wallet/presentation/screens/wallet_screen.dart';
import '../features/sell/presentation/screens/sell_brands_screen.dart';
import '../features/sell/presentation/screens/sell_diagnostics_screen.dart';
import '../features/sell/presentation/screens/sell_models_screen.dart';
import '../features/sell/presentation/screens/sell_pickup_screen.dart';
import '../features/sell/presentation/screens/sell_questionnaire_screen.dart';
import '../features/sell/presentation/screens/sell_quote_screen.dart';
import '../features/sell/presentation/screens/sell_screen.dart';
import '../features/sell/presentation/screens/sell_variants_screen.dart';
import 'route_paths.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorSell = GlobalKey<NavigatorState>(debugLabel: 'shellSell');
final _shellNavigatorBuy = GlobalKey<NavigatorState>(debugLabel: 'shellBuy');
final _shellNavigatorRepair = GlobalKey<NavigatorState>(debugLabel: 'shellRepair');
final _shellNavigatorProfile = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

/// Riverpod provider delivering the configured GoRouter instance with full Auth routing.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.home,
    routes: [
      // Top-level Authentication Routes
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.otp,
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return OtpVerificationScreen(phone: phone);
        },
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: RoutePaths.sellBrands,
        builder: (context, state) => const SellBrandsScreen(),
      ),
      GoRoute(
        path: RoutePaths.sellModels,
        builder: (context, state) => const SellModelsScreen(),
      ),
      GoRoute(
        path: RoutePaths.sellVariants,
        builder: (context, state) => const SellVariantsScreen(),
      ),
      GoRoute(
        path: RoutePaths.sellQuestionnaire,
        builder: (context, state) => const SellQuestionnaireScreen(),
      ),
      GoRoute(
        path: RoutePaths.sellDiagnostics,
        builder: (context, state) => const SellDiagnosticsScreen(),
      ),
      GoRoute(
        path: RoutePaths.sellQuoteResult,
        builder: (context, state) => const SellQuoteScreen(),
      ),
      GoRoute(
        path: RoutePaths.sellPickupSchedule,
        builder: (context, state) => const SellPickupScreen(),
      ),
      GoRoute(
        path: RoutePaths.productDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'prod_ip13_mid';
          return ProductDetailScreen(productId: id);
        },
      ),
      GoRoute(
        path: RoutePaths.productCompare,
        builder: (context, state) => const ProductCompareScreen(),
      ),
      GoRoute(
        path: RoutePaths.wishlist,
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: RoutePaths.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: RoutePaths.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: RoutePaths.orderSuccess,
        builder: (context, state) => const OrderSuccessScreen(),
      ),
      GoRoute(
        path: RoutePaths.repairBooking,
        builder: (context, state) => const RepairBookingScreen(),
      ),
      GoRoute(
        path: RoutePaths.repairTracking,
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? 'REP-84920';
          return TechnicianTrackingScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: RoutePaths.wallet,
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: RoutePaths.referral,
        builder: (context, state) => const ReferralScreen(),
      ),
      GoRoute(
        path: RoutePaths.orders,
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: RoutePaths.addresses,
        builder: (context, state) => const SavedAddressesScreen(),
      ),
      GoRoute(
        path: RoutePaths.supportChat,
        builder: (context, state) => const SupportChatScreen(),
      ),
      GoRoute(
        path: RoutePaths.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // 5-Tab Persistent Stateful Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Branch 2: Sell Device Flow
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSell,
            routes: [
              GoRoute(
                path: RoutePaths.sell,
                builder: (context, state) => const SellScreen(),
              ),
            ],
          ),

          // Branch 3: Buy Refurbished Marketplace
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBuy,
            routes: [
              GoRoute(
                path: RoutePaths.buy,
                builder: (context, state) => const BuyScreen(),
              ),
            ],
          ),

          // Branch 4: Doorstep Repair Services
          StatefulShellBranch(
            navigatorKey: _shellNavigatorRepair,
            routes: [
              GoRoute(
                path: RoutePaths.repair,
                builder: (context, state) => const RepairScreen(),
              ),
            ],
          ),

          // Branch 5: Profile, Orders & Wallet
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
