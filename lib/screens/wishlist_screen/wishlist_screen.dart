import 'package:ampify_bloc/common/app_colors.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_state.dart';
import 'package:ampify_bloc/screens/wishlist_screen/wishlist_widgets/wishlist_item_card.dart';
import 'package:ampify_bloc/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to see wishlist')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: 'Wishlist'),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        buildWhen: (previous, current) =>
            current is WishlistLoaded || current is WishlistError,
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WishlistError) {
            return Center(child: Text(state.message));
          }

          if (state is WishlistLoaded && state.wishlist.isEmpty) {
            return const Center(child: Text('No items in wishlist.'));
          }

          if (state is WishlistLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              key: PageStorageKey('wishlist_grid'),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: state.wishlist.length,
              itemBuilder: (context, index) {
                final doc = state.wishlist[index];
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: WishlistItemCard(
                    key: ValueKey(doc.id), //keeping each card's state
                    docId: doc.id,
                    data: doc.data() as Map<String, dynamic>,
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
