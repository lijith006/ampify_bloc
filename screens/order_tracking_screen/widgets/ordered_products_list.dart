import 'package:ampify_bloc/screens/cart/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:ampify_bloc/common/image_to_base.dart';

class OrderItemsList extends StatelessWidget {
  final List<CartItem> items;

  const OrderItemsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, productIndex) {
        final product = items[productIndex];
        return Column(
          children: [
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageUtils.base64ToImage(product.imageUrls[0]),
              ),
              title: Text(
                product.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Quantity: ${product.quantity}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              trailing: Text(
                "₹${product.price * product.quantity}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (productIndex < items.length - 1)
              const Divider(height: 1, thickness: 1),
          ],
        );
      },
    );
  }
}
