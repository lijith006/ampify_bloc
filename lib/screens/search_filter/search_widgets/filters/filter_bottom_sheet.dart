import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/search_filter/search_service/search_filter_service.dart';
import 'package:ampify_bloc/screens/search_filter/search_widgets/filters/filter_widgets.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final ProductFilter initialFilter;
  final SearchFilterService searchFilterService;
  final Function(ProductFilter) onApplyFilters;
  const FilterBottomSheet(
      {super.key,
      required this.initialFilter,
      required this.searchFilterService,
      required this.onApplyFilters});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late ProductFilter filter;

  @override
  void initState() {
    super.initState();
    filter = widget.initialFilter.clone();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PriceRangeFilter(
                      minPrice: filter.minPrice?.toDouble() ?? 0.0,
                      maxPrice: filter.maxPrice?.toDouble() ?? 90000.0,
                      onChanged: (min, max) {
                        setState(() {
                          filter.minPrice = min;
                          filter.maxPrice = max;
                        });
                      }),
                  const SizedBox(height: 20),
                  CategoryFilter(
                    selectedCategories: filter.categories,
                    searchFilterService: widget.searchFilterService,
                    onCategoriesSelected: (categories) {
                      setState(() {
                        filter.categories = categories;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  BrandFilter(
                    selectedBrands: filter.brands,
                    searchFilterService: widget.searchFilterService,
                    onBrandsSelected: (brands) {
                      setState(() {
                        filter.brands = brands;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters(filter);

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dark,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ))),
        ],
      ),
    );
  }
}
