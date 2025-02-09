class CartItem {
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final List<String> imageUrls;
  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrls,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrls': imageUrls,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      title: map['title'],
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
    );
  }
}
