import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/home_api_service.dart';

class SearchState {
  final String query;
  final List<String> suggestions;
  final List<String> recentSearches;
  final bool isSearching;

  const SearchState({
    this.query = '',
    this.suggestions = const [],
    this.recentSearches = const ['iPhone 13', 'OnePlus 11', 'MacBook Air M1'],
    this.isSearching = false,
  });

  SearchState copyWith({
    String? query,
    List<String>? suggestions,
    List<String>? recentSearches,
    bool? isSearching,
  }) {
    return SearchState(
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      recentSearches: recentSearches ?? this.recentSearches,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

final searchNotifierProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final apiService = ref.read(homeApiServiceProvider);
  return SearchNotifier(apiService);
});

class SearchNotifier extends StateNotifier<SearchState> {
  final HomeApiService _apiService;
  Timer? _debounceTimer;

  SearchNotifier(this._apiService) : super(const SearchState());

  void onQueryChanged(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      state = state.copyWith(query: '', suggestions: [], isSearching: false);
      return;
    }

    state = state.copyWith(query: query, isSearching: true);
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      final results = await _apiService.searchSuggestions(query);
      state = state.copyWith(suggestions: results, isSearching: false);
    });
  }

  void addRecentSearch(String term) {
    if (term.trim().isEmpty) return;
    final updated = [term, ...state.recentSearches.where((s) => s != term)].take(5).toList();
    state = state.copyWith(recentSearches: updated);
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: []);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
