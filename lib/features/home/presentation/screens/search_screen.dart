import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/route_paths.dart';
import '../providers/search_provider.dart';

/// Full-screen search with debounce, recent search history, and trending queries.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  static const List<String> trendingSearches = [
    'iPhone 13',
    'iPhone 14 Pro',
    'Samsung S23 Ultra',
    'OnePlus 11',
    'MacBook Air M1',
    'Screen Replacement',
    'Pixel 7',
    'iPad 9th Gen',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSelectQuery(String query) {
    ref.read(searchNotifierProvider.notifier).addRecentSearch(query);
    _searchController.text = query;
    // Route to sell or marketplace based on query
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $query')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (val) => ref.read(searchNotifierProvider.notifier).onQueryChanged(val),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'Search models, repairs, accessories...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20, color: AppColors.neutral500),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchNotifierProvider.notifier).onQueryChanged('');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Search Suggestions
            if (searchState.suggestions.isNotEmpty) ...[
              const Text(
                'Suggestions',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.neutral700),
              ),
              const SizedBox(height: AppSpacing.sm),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchState.suggestions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final suggestion = searchState.suggestions[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.search_rounded, color: AppColors.neutral500, size: 20),
                    title: Text(suggestion, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.north_west_rounded, size: 16, color: AppColors.neutral500),
                    onTap: () => _onSelectQuery(suggestion),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Recent Searches Section
            if (searchState.recentSearches.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Searches',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.neutral700),
                  ),
                  GestureDetector(
                    onTap: () => ref.read(searchNotifierProvider.notifier).clearRecentSearches(),
                    child: const Text(
                      'Clear',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: searchState.recentSearches.map((term) {
                  return ActionChip(
                    avatar: const Icon(Icons.history_rounded, size: 16, color: AppColors.neutral500),
                    label: Text(term),
                    backgroundColor: AppColors.neutral100,
                    labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.neutral900),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedPill),
                    onPressed: () => _onSelectQuery(term),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Trending Searches Section
            const Text(
              'Trending Searches',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.neutral700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: trendingSearches.map((term) {
                return ActionChip(
                  avatar: const Icon(Icons.trending_up_rounded, size: 16, color: AppColors.primaryDark),
                  label: Text(term),
                  backgroundColor: AppColors.primaryLight,
                  labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedPill),
                  onPressed: () => _onSelectQuery(term),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
