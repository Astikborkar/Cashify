import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/home_api_service.dart';
import '../../domain/models/banner_model.dart';
import '../../domain/models/category_model.dart';
import '../../domain/models/product_summary_model.dart';
import '../../domain/models/trending_sell_device_model.dart';

class HomeDashboardState {
  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<TrendingSellDeviceModel> trendingSellDevices;
  final List<ProductSummaryModel> refurbishedHotDeals;
  final String selectedCity;
  final String selectedPincode;
  final bool isLoading;
  final String? error;

  const HomeDashboardState({
    this.banners = const [],
    this.categories = const [],
    this.trendingSellDevices = const [],
    this.refurbishedHotDeals = const [],
    this.selectedCity = 'Bengaluru',
    this.selectedPincode = '560001',
    this.isLoading = true,
    this.error,
  });

  HomeDashboardState copyWith({
    List<BannerModel>? banners,
    List<CategoryModel>? categories,
    List<TrendingSellDeviceModel>? trendingSellDevices,
    List<ProductSummaryModel>? refurbishedHotDeals,
    String? selectedCity,
    String? selectedPincode,
    bool? isLoading,
    String? error,
  }) {
    return HomeDashboardState(
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      trendingSellDevices: trendingSellDevices ?? this.trendingSellDevices,
      refurbishedHotDeals: refurbishedHotDeals ?? this.refurbishedHotDeals,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedPincode: selectedPincode ?? this.selectedPincode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeDashboardState>((ref) {
  final apiService = ref.read(homeApiServiceProvider);
  return HomeNotifier(apiService);
});

class HomeNotifier extends StateNotifier<HomeDashboardState> {
  final HomeApiService _apiService;

  HomeNotifier(this._apiService) : super(const HomeDashboardState()) {
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final banners = await _apiService.getBanners();
      final categories = _apiService.getCategories();
      final trending = await _apiService.getTrendingSellDevices();
      final deals = await _apiService.getRefurbishedHotDeals();

      state = state.copyWith(
        banners: banners,
        categories: categories,
        trendingSellDevices: trending,
        refurbishedHotDeals: deals,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load home dashboard: $e',
      );
    }
  }

  void updateLocation(String city, String pincode) {
    state = state.copyWith(selectedCity: city, selectedPincode: pincode);
  }
}
