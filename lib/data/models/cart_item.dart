import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  const CartItem({
    required this.productId,
    required this.nameSnapshot,
    required this.brandSnapshot,
    required this.imageUrlSnapshot,
    required this.currency,
    required this.unitPrice,
    required this.qty,
    required this.variant,
  });

  final String productId;
  final String nameSnapshot;
  final String brandSnapshot;
  final String imageUrlSnapshot;
  final String currency;
  final num unitPrice;
  final int qty;
  final Map<String, dynamic> variant;

  num get lineTotal => unitPrice * qty;

  factory CartItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return CartItem(
      productId: doc.id,
      nameSnapshot: (data['nameSnapshot'] ?? '').toString(),
      brandSnapshot: (data['brandSnapshot'] ?? '').toString(),
      imageUrlSnapshot: (data['imageUrlSnapshot'] ?? '').toString(),
      currency: (data['currency'] ?? '').toString(),
      unitPrice: (data['unitPrice'] ?? 0) as num,
      qty: ((data['qty'] ?? 1) as num).toInt(),
      variant: (data['variant'] is Map) ? Map<String, dynamic>.from(data['variant'] as Map) : const <String, dynamic>{},
    );
  }
}

