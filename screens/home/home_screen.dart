import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/cart/cart.dart';
import 'package:ampify_bloc/screens/home/home_content.dart';
import 'package:ampify_bloc/screens/profile/profile.dart';
import 'package:ampify_bloc/screens/search_filter/search_service/search_filter_service.dart';
import 'package:ampify_bloc/screens/search_filter/search_widgets/filters/filter_bottom_sheet.dart';
import 'package:ampify_bloc/screens/search_filter/search_widgets/search/search_field.dart';
import 'package:ampify_bloc/screens/search_filter/search_widgets/search/search_results.dart';
import 'package:ampify_bloc/screens/wishlist_screen/wishlist_screen.dart';
import 'package:ampify_bloc/widgets/custom_nav/custom_bottom_navbar.dart';
import 'package:ampify_bloc/widgets/custom_nav/nav_cubit.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();
  final CarouselSliderController controller = CarouselSliderController();
  final SearchFilterService searchFilterService =
      SearchFilterService(FirebaseFirestore.instance);
  ProductFilter filter = ProductFilter();
  String searchQuery = '';
  bool isFilterActive = false;

  final List<Widget> screens = [
    HomeContent(),
    const WishlistScreen(),
    const MyCart(),
    const MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<NavCubit, int>(
          builder: (context, selectedIndex) {
            return AppBar(
              backgroundColor: AppColors.backgroundColor,
              title: selectedIndex == 0
                  ? buildSearchField()
                  : Text(getScreenTitle(selectedIndex)),
              actions: [
                if (selectedIndex == 0) buildFilterButton(),
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<NavCubit, int>(
        builder: (context, selectedIndex) {
          return Stack(
            children: [
              // Main content based on navigation
              IndexedStack(
                //  selectedIndex from NavCubit
                index: selectedIndex,
                children: screens,
              ),

              // Search results
              if (selectedIndex == 0 &&
                  (searchQuery.isNotEmpty || isFilterActive))
                buildSearchAndFilterResults(),
            ],
          );
        },
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }

  Widget buildSearchField() {
    return SearchField(
      controller: searchController,
      onSearch: () {
        setState(() {
          searchQuery = searchController.text.trim().toLowerCase();
        });
      },
    );
  }

  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FilterBottomSheet(
          initialFilter: filter,
          searchFilterService: searchFilterService,
          onApplyFilters: (newFilter) {
            setState(() {
              filter = newFilter;
              isFilterActive = filter.isActive;
            });
          },
        );
      },
    );
  }

  // Method to clear specific filter
  void clearFilter(String filterType, String? value) {
    setState(() {
      switch (filterType) {
        case 'search':
          searchQuery = '';
          searchController.clear();
          break;
        case 'category':
          filter.categories?.remove(value);
          if (filter.categories!.isEmpty) filter.categories = null;
          break;
        case 'brand':
          filter.brands?.remove(value);
          if (filter.brands!.isEmpty) filter.brands = null;
          break;
        case 'price':
          filter.minPrice = null;
          filter.maxPrice = null;
          break;
      }
      isFilterActive = filter.isActive;
    });
  }

  // Method to clear all filters
  void clearAllFilters() {
    setState(() {
      searchQuery = '';
      searchController.clear();
      filter.clear();
      isFilterActive = false;
    });
  }

//Filter button
  Widget buildFilterButton() {
    return IconButton(
      color: Colors.black,
      icon: const Icon(Icons.filter_list),
      onPressed: showFilterBottomSheet,
    );
  }

  String getScreenTitle(int selectedIndex) {
    switch (_selectedIndex) {
      case 1:
        return 'Wishlist';
      case 2:
        return 'Cart';
      case 3:
        return 'Profile';
      default:
        return '';
    }
  }

  void updateSearch() {
    setState(() {
      searchQuery = searchController.text.trim().toLowerCase();
    });
  }

  Widget buildSearchAndFilterResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: searchFilterService.fetchProducts(
        searchQuery: searchQuery,
        filter: filter,
      ),
      builder: (context, snapshot) {
        return SearchResults(
          searchResults: snapshot.hasData ? snapshot.data : null,
          searchQuery: searchQuery,
          filter: filter,
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          onClearFilters: clearAllFilters,
          onClearFilter: clearFilter,
          searchFilterService: searchFilterService,
        );
      },
    );
  }
}
