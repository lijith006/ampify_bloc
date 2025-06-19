// import 'dart:convert';
// import 'package:ampify_bloc/screens/categories/bloc/categories_bloc.dart';
// import 'package:ampify_bloc/screens/categories/bloc/categories_event.dart';
// import 'package:ampify_bloc/screens/categories/categories.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CategoryListWidget extends StatelessWidget {
//   final FirebaseFirestore firestore;

//   const CategoryListWidget({Key? key, required this.firestore})
//       : super(key: key);

//   Stream<QuerySnapshot> _fetchCategories() {
//     return firestore.collection('categories').snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Categories',
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//         const SizedBox(height: 5),
//         StreamBuilder<QuerySnapshot>(
//           stream: _fetchCategories(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             final categories = snapshot.data!.docs;
//             return SizedBox(
//               height: 100,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: categories.length,
//                 itemBuilder: (context, index) {
//                   final category = categories[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BlocProvider(
//                             create: (context) => CategoriesBloc(
//                               firestore: firestore,
//                             )..add(FetchProducts(category.id)),
//                             child: Categories(
//                               categoryId: category.id,
//                               categoryName: category['name'],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: Column(
//                         children: [
//                           Container(
//                             width: 60,
//                             height: 60,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               image: DecorationImage(
//                                 image: MemoryImage(
//                                   base64Decode(category['image']),
//                                 ),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(category['name']),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
import 'dart:convert';

import 'package:ampify_bloc/screens/categories/bloc/categories_bloc.dart';
import 'package:ampify_bloc/screens/categories/bloc/categories_event.dart';
import 'package:ampify_bloc/screens/categories/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListWidget extends StatelessWidget {
  final List<DocumentSnapshot> categories;
  final FirebaseFirestore firestore;

  const CategoryListWidget({
    Key? key,
    required this.categories,
    required this.firestore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => CategoriesBloc(
                          firestore: firestore,
                        )..add(FetchProducts(category.id)),
                        child: Categories(
                          categoryId: category.id,
                          categoryName: category['name'],
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: MemoryImage(
                              base64Decode(category['image']),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(category['name']),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
