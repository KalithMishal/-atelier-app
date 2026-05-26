import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistItem {
  const WishlistItem({
    required this.productId,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.currency,
    required this.addedAt,
  });

  final String productId;
  final String name;
  final String brand;
  final String imageUrl;
  final num price;
  final String currency;
  final Timestamp? addedAt;

  factory WishlistItem.fromDoc(String productId, Map<String, dynamic>? data) {
    final d = data ?? const <String, dynamic>{};
    return WishlistItem(
      productId: productId,
      name: (d['nameSnapshot'] ?? '').toString(),
      brand: (d['brandSnapshot'] ?? '').toString(),
      imageUrl: (d['imageUrlSnapshot'] ?? '').toString(),
      price: (d['price'] ?? 0) as num,
      currency: (d['currency'] ?? 'LKR').toString(),
      addedAt: d['addedAt'] is Timestamp ? d['addedAt'] as Timestamp : null,
    );
  }
}
