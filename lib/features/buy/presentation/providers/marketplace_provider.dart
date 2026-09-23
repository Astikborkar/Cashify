import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../data/services/marketplace_api_service.dart';
import '../../domain/models/refurbished_product_model.dart';

class MarketplaceFilterState {
  final String selectedBrand;
  final BadgeType? selectedGrade;
  final String sortBy;
  final List<RefurbishedProductModel> products;
  final bool isLoading;

  const MarketplaceFilterState({
    this.selectedBrand = 'All',
    this.selectedGrade,
    this.sortBy = 'popularity',
    this.products = const [],
    this.isLoading = true,
  });

  MarketplaceFilterState copyWith({
    String? selectedBrand,
    BadgeType? selectedGrade,
    bool clearGrade = false,
    String? sortBy,
    List<RefurbishedProductModel>? products,
    bool? isLoading,
  }) {
    return MarketplaceFilterState(
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedGrade: clearGrade ? null : (selectedGrade ?? this.selectedGrade),
      sortBy: sortBy ?? this.sortBy,
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final marketplaceNotifierProvider = StateNotifierProvider<MarketplaceNotifier, MarketplaceFilterState>((ref) {
  final apiService = ref.read(marketplaceApiServiceProvider);
  return MarketplaceNotifier(apiService);
});

class MarketplaceNotifier extends StateNotifier<MarketplaceFilterState> {
  final MarketplaceApiService _apiService;

  MarketplaceNotifier(this._apiService) : super(const MarketplaceFilterState()) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true);
    final list = await _apiService.getProducts(
      brand: state.selectedBrand,
      grade: state.selectedGrade,
      sortBy: state.sortBy,
    );
    state = state.copyWith(products: list, isLoading: false);
  }

  void setBrand(String brand) {
    state = state.copyWith(selectedBrand: brand);
    fetchProducts();
  }

  void setGrade(BadgeType? grade) {
    if (grade == null) {
      state = state.copyWith(clearGrade: true);
    } else {
      state = state.copyWith(selectedGrade: grade);
    }
    fetchProducts();
  }

  void setSortBy(String sort) {
    state = state.copyWith(sortBy: sort);
    fetchProducts();
  }
}

// Wishlist Provider
final wishlistNotifierProvider = StateNotifierProvider<WishlistNotifier, Set<String>>((ref) {
  return WishlistNotifier();
});

class WishlistNotifier extends StateNotifier<Set<String>> {
  WishlistNotifier() : super({'prod_ip13_mid'});

  void toggleWishlist(String productId) {
    if (state.contains(productId)) {
      state = Set.from(state)..remove(productId);
    } else {
      state = Set.from(state)..add(productId);
    }
  }

  bool isWishlisted(String productId) => state.contains(productId);
}
