// import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
// import 'package:ampify_bloc/authentication/screens/auth_wrapper.dart';
// import 'package:ampify_bloc/authentication/service/auth_service.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
// import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
// import 'package:ampify_bloc/screens/cart/cart_service.dart';
// import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
// import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
// import 'package:ampify_bloc/screens/checkout_screen/addresstService.dart';

// import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
// import 'package:ampify_bloc/screens/payment/bloc/payment_bloc.dart';
// import 'package:ampify_bloc/screens/products/bloc/product_details_bloc.dart';
// import 'package:ampify_bloc/screens/profile/bloc/profile_bloc.dart';
// import 'package:ampify_bloc/screens/profile/profile_service.dart';

// import 'package:ampify_bloc/screens/splash_screen.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
// import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
// import 'package:ampify_bloc/widgets/custom_nav/nav_cubit.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';

// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await requestLocationPermission();
//   await Firebase.initializeApp();

//   runApp(
//     MultiProvider(
//       providers: [
//         Provider<ProfileService>(
//           create: (_) => ProfileService(),
//         ),
//         Provider<CartService>(
//           create: (_) => CartService(),
//         ),
//         MultiBlocProvider(
//           providers: [
//             //   BlocProvider(create: (context) => CartBloc(CartService())),
//             BlocProvider<AuthBloc>(
//               create: (_) => AuthBloc(AuthService()),
//             ),
//             BlocProvider(
//                 create: (context) =>
//                     CartBloc(CartService())..add(LoadCartItems())),
//             //   BlocProvider(create: (context) => WishlistBloc()),
//             BlocProvider<ProductDetailsBloc>(
//               create: (_) => ProductDetailsBloc(),
//             ),
//             BlocProvider<WishlistBloc>(
//               create: (context) => WishlistBloc()..add(FetchWishlist()),
//             ),
//             BlocProvider<OrderBloc>(
//               create: (context) =>
//                   OrderBloc(firestore: FirebaseFirestore.instance),
//             ),
//             BlocProvider<ProfileBloc>(
//               create: (context) => ProfileBloc(context.read<ProfileService>())
//                 ..add(LoadProfile()),
//             ),
//             BlocProvider(
//                 create: (context) =>
//                     CheckoutBloc(AddressService())..add(LoadAddresses())),
//             BlocProvider<PaymentBloc>(
//               create: (context) =>
//                   PaymentBloc(orderBloc: context.read<OrderBloc>()),
//             ),
//             BlocProvider(create: (context) => NavCubit()),
//           ],
//           child: MaterialApp(
//               theme: ThemeData(
//                 fontFamily: 'Nunito',
//                 textTheme: const TextTheme(
//                   bodyLarge: TextStyle(
//                       fontFamily: 'RobotoMono',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       //color: Colors.black87
//                       color: Colors.black87),
//                   bodyMedium: TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                       color: Colors.black87),
//                   bodySmall: TextStyle(
//                     fontFamily: 'Inter',
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                   ),
//                   headlineLarge: TextStyle(
//                       fontFamily: 'RobotoMono',
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                   headlineMedium: TextStyle(
//                       fontFamily: 'RobotoMono',
//                       fontSize: 20,
//                       color: Colors.black54,
//                       fontWeight: FontWeight.w600),
//                   headlineSmall: TextStyle(
//                       fontFamily: 'RobotoMono',
//                       fontSize: 18,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500),
//                 ),
//               ),
//               debugShowCheckedModeBanner: false,
//               title: 'Ampify',
//               home: const SplashScreen(),
//               routes: {
//                 '/auth_wrapper': (context) => const AuthWrapper(),
//               }),
//         ),
//       ],
//     ),
//   );
// }

// Future<void> requestLocationPermission() async {
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       debugPrint("Location permissions are denied");
//     }
//   }
//   if (permission == LocationPermission.deniedForever) {
//     debugPrint(
//         "Location permissions are permanently denied, enable them from settings.");
//   }
// }
//-------------------------------------------------------------------------------------------
import 'package:ampify_bloc/authentication/bloc/auth_bloc.dart';
import 'package:ampify_bloc/authentication/screens/auth_wrapper.dart';
import 'package:ampify_bloc/authentication/service/auth_service.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_bloc.dart';
import 'package:ampify_bloc/screens/cart/bloc/cart_event.dart';
import 'package:ampify_bloc/screens/cart/cart_service.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_bloc.dart';
import 'package:ampify_bloc/screens/checkout_screen/bloc/checkout_event.dart';
import 'package:ampify_bloc/screens/checkout_screen/addresstService.dart';

import 'package:ampify_bloc/screens/orders/bloc/order_bloc.dart';
import 'package:ampify_bloc/screens/payment/bloc/payment_bloc.dart';
import 'package:ampify_bloc/screens/products/bloc/product_details_bloc.dart';
import 'package:ampify_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:ampify_bloc/screens/profile/profile_service.dart';

import 'package:ampify_bloc/screens/splash_screen.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_bloc.dart';
import 'package:ampify_bloc/screens/wishlist_screen/bloc/whishlist_event.dart';
import 'package:ampify_bloc/widgets/custom_nav/nav_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            //   BlocProvider(create: (context) => CartBloc(CartService())),
            BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(AuthService()),
            ),
            BlocProvider(
                create: (context) =>
                    CartBloc(CartService())..add(LoadCartItems())),
            //   BlocProvider(create: (context) => WishlistBloc()),
            BlocProvider<ProductDetailsBloc>(
              create: (_) => ProductDetailsBloc(),
            ),
            BlocProvider<WishlistBloc>(
              create: (context) => WishlistBloc()..add(FetchWishlist()),
            ),
            BlocProvider<OrderBloc>(
              create: (context) =>
                  OrderBloc(firestore: FirebaseFirestore.instance),
            ),
            BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(context.read<ProfileService>())
                ..add(LoadProfile()),
            ),
            BlocProvider(
                create: (context) =>
                    CheckoutBloc(AddressService())..add(LoadAddresses())),
            BlocProvider<PaymentBloc>(
              create: (context) =>
                  PaymentBloc(orderBloc: context.read<OrderBloc>()),
            ),
            BlocProvider(create: (context) => NavCubit()),
          ],
          child: MaterialApp(
              theme: ThemeData(
                useMaterial3: true,
                fontFamily: 'Nunito',
                scaffoldBackgroundColor: Colors.white,
                applyElevationOverlayColor: false,

                //AppBar dark overlay
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.transparent,
                ),

                textTheme: const TextTheme(
                  bodyLarge: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      //color: Colors.black87
                      color: Colors.black87),
                  bodyMedium: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black87),
                  bodySmall: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  headlineLarge: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  headlineMedium: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600),
                  headlineSmall: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
              debugShowCheckedModeBanner: false,
              title: 'Ampify',
              home: const SplashScreen(),
              routes: {
                '/auth_wrapper': (context) => const AuthWrapper(),
              }),
        ),
      ],
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
