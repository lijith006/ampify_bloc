//import 'package:ampify_bloc/authentication/service/auth_service.dart';
import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/cart/cart.dart';
import 'package:ampify_bloc/screens/home/home_content.dart';
import 'package:ampify_bloc/screens/profile/profile.dart';
import 'package:ampify_bloc/screens/search_filter/search_service/search_filter_service.dart';
import 'package:ampify_bloc/screens/search_filter/search_widgets/filters/filter_bottom_sheet.dart';
import 'package:ampify_bloc/screens/search_filter/search_widgets/search/search_field.dart';
import 'package:ampify_bloc/screens/search_filter/search_widgets/search/search_results.dart';
import 'package:ampify_bloc/screens/wishlist_screen/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
    //  final _auth = AuthService();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        excludeHeaderSemantics: true,
        backgroundColor: AppColors.backgroundColor,
        title:
            _selectedIndex == 0 ? buildSearchField() : Text(getScreenTitle()),
        actions: [
          if (_selectedIndex == 0) buildFilterButton(),
          // buildLogoutButton(_auth),
        ],
      ),
      body: Stack(
        children: [
          // Main content based on--- navigation
          IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),

          // Search results or filtered products
          if (_selectedIndex == 0 && (searchQuery.isNotEmpty || isFilterActive))
            buildSearchAndFilterResults(),
        ],
      ),
      bottomNavigationBar: buildBottomNav(),
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

  String getScreenTitle() {
    switch (_selectedIndex) {
      case 1:
        return '';
      case 2:
        return '';
      case 3:
        return '';
      default:
        return 'Home';
    }
  }

  void updateSearch() {
    setState(() {
      searchQuery = searchController.text.trim().toLowerCase();
    });
  }

//Bottom nav bar
  Widget buildBottomNav() {
    return GNav(
      gap: 8,
      selectedIndex: _selectedIndex,
      onTabChange: (index) {
        HapticFeedback.heavyImpact();
        setState(() {
          _selectedIndex = index;
          // Clear search when switching tabs
          if (_selectedIndex != 0) {
            searchQuery = '';
            searchController.clear();
          }
        });
      },
      tabs: const [
        GButton(icon: Icons.home, text: 'Home'),
        GButton(icon: Icons.favorite, text: 'Wishlist'),
        GButton(icon: Icons.shopping_cart, text: 'My cart'),
        GButton(icon: Icons.person, text: 'Profile'),
      ],
    );
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
