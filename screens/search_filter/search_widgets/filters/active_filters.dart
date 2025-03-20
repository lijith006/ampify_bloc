import 'package:ampify_bloc/screens/search_filter/search_service/search_filter_service.dart';
import 'package:flutter/material.dart';

class ActiveFiltersDisplay extends StatelessWidget {
  final ProductFilter filter;
  final String searchQuery;
  final VoidCallback onClearAll;
  // final Function(String) onClearFilter;
  final Function(String, String?) onClearFilter;
  final SearchFilterService searchFilterService;

  const ActiveFiltersDisplay({
    Key? key,
    required this.filter,
    required this.searchQuery,
    required this.onClearAll,
    required this.onClearFilter,
    required this.searchFilterService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Filters',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: onClearAll,
                child: const Text('Clear All'),
              ),
            ],
          ),
          Wrap(
            spacing: 8.0,
            children: [
              if (searchQuery.isNotEmpty)
                Chip(
                  label: Text('Search: $searchQuery'),
                  onDeleted: () => onClearFilter('search', null),
                ),
//************************************************************************** */
              // Display category names
              if (filter.categories != null && filter.categories!.isNotEmpty)
                FutureBuilder<List<String>>(
                  future: searchFilterService
                      .fetchCategoryNames(filter.categories!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    } else {
                      final categoryNames = snapshot.data!;
                      return Wrap(
                        spacing: 8.0,
                        children: categoryNames.map((name) {
                          return Chip(
                            label: Text('Category: $name'),
                            onDeleted: () => onClearFilter('category', name),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),

              // Display brand names
              if (filter.brands != null && filter.brands!.isNotEmpty)
                FutureBuilder<List<String>>(
                  future: searchFilterService.fetchBrandNames(filter.brands!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    } else {
                      final brandNames = snapshot.data!;
                      return Wrap(
                        spacing: 8.0,
                        children: brandNames.map((name) {
                          return Chip(
                            label: Text('Brand: $name'),
                            onDeleted: () => onClearFilter('brand', name),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),

//************************************************************************** */

              if (filter.minPrice != null && filter.maxPrice != null)
                Chip(
                  label: Text(
                      'Price: ₹${filter.minPrice!.toInt()} - ₹${filter.maxPrice!.toInt()}'),
                  onDeleted: () => onClearFilter('price', null),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
