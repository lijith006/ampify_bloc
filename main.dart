// import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
// import 'package:ampify_bloc/authentication/service/auth_service.dart';
// import 'package:ampify_bloc/screens/products/bloc/product_details_bloc.dart';
// import 'package:ampify_bloc/screens/profile/bloc/profile_bloc.dart';
// import 'package:ampify_bloc/screens/profile/profile_service.dart';
// import 'package:ampify_bloc/screens/splash_screen.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [

//         BlocProvider<AuthBloc>(
//           create: (_) => AuthBloc(AuthService()),
//         ),
//         BlocProvider<ProductDetailsBloc>(
//           create: (_) => ProductDetailsBloc(),
//         ),
//         BlocProvider<WishlistBloc>(
//           create: (context) => WishlistBloc()..add(FetchWishlist()),
//         ),
//         BlocProvider<ProfileBloc>(
//           create: (context) => ProfileBloc(context.read<ProfileService>()),
//         ),
//       ],
//       child: const MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Ampify',
//         home: SplashScreen(),
//       ),
//     );
//   }
// }
//************************************************ */

import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
import 'package:ampify_bloc/authentication/service/auth_service.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/cart_service.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
import 'package:ampify_bloc/screens/checkout_screen/checkoutService.dart';
import 'package:ampify_bloc/screens/products/bloc/product_details_bloc.dart';
import 'package:ampify_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:ampify_bloc/screens/profile/profile_service.dart';
import 'package:ampify_bloc/screens/splash_screen.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider<ProfileService>(
          create: (_) => ProfileService(),
        ),
        Provider<CartService>(
          create: (_) => CartService(),
        ),
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => CartBloc(CartService())),
            BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(AuthService()),
            ),
            BlocProvider<ProductDetailsBloc>(
              create: (_) => ProductDetailsBloc(),
            ),
            BlocProvider<WishlistBloc>(
              create: (context) => WishlistBloc()..add(FetchWishlist()),
            ),
            BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(context.read<ProfileService>())
                ..add(LoadProfile()),
            ),
            BlocProvider(
                create: (context) =>
                    CheckoutBloc(AddressService())..add(LoadAddresses())),
          ],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ampify',
            home: SplashScreen(),
          ),
        ),
      ],
      // child: const MyApp(),
    ),
  );
}

Future<void> requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      debugPrint("Location permissions are denied");
    }
  }
  if (permission == LocationPermission.deniedForever) {
    debugPrint(
        "Location permissions are permanently denied, enable them from settings.");
  }
}
