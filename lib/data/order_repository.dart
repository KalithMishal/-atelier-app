import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/cart_item.dart';
import 'models/store_order.dart';

class OrderRepository {
  OrderRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  static const shippingFlat = 15.0;
  static const taxRate = 0.09;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');

  Stream<List<StoreOrder>> watchUserOrders(String uid, {int limit = 50}) {
    return _orders
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(StoreOrder.fromDoc).toList());
  }

  Stream<StoreOrder?> watchOrder(String orderId) {
    return _orders.doc(orderId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return StoreOrder.fromDoc(doc);
    });
  }

  Stream<List<OrderLineItem>> watchOrderItems(String orderId) {
    return _orders
        .doc(orderId)
        .collection('items')
        .snapshots()
        .map((snap) => snap.docs.map(OrderLineItem.fromDoc).toList());
  }

  Stream<List<OrderStatusEvent>> watchStatusEvents(String orderId) {
    return _orders
        .doc(orderId)
        .collection('statusEvents')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map(OrderStatusEvent.fromDoc).toList());
  }

  Future<String> placeOrder({
    required String uid,
    required List<CartItem> items,
    required Map<String, dynamic> deliveryAddress,
  }) async {
    final now = FieldValue.serverTimestamp();
    final subtotal = items.fold<num>(0, (s, i) => s + i.lineTotal);
    final shipping = items.isEmpty ? 0.0 : shippingFlat;
    final tax = (subtotal * taxRate);
    final total = subtotal + shipping + tax;
    final previews = items
        .map((i) => i.imageUrlSnapshot)
        .where((u) => u.startsWith('http') || u.startsWith('assets/'))
        .take(2)
        .toList();

    final orderRef = _orders.doc();

    final batch = _firestore.batch();
    batch.set(orderRef, {
      'userId': uid,
      'currency': items.isNotEmpty ? items.first.currency : 'USD',
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'total': total,
      'previewImageUrls': previews,
      'deliveryAddress': deliveryAddress,
      'status': 'placed',
      'createdAt': now,
      'updatedAt': now,
    });

    for (final item in items) {
      final itemRef = orderRef.collection('items').doc();
      batch.set(itemRef, {
        'userId': uid,
        'productId': item.productId,
        'nameSnapshot': item.nameSnapshot,
        'brandSnapshot': item.brandSnapshot,
        'imageUrlSnapshot': item.imageUrlSnapshot,
        'qty': item.qty,
        'unitPrice': item.unitPrice,
        'currency': item.currency,
        'variant': item.variant,
      });
    }

    final placedRef = orderRef.collection('statusEvents').doc();
    batch.set(placedRef, {
      'userId': uid,
      'status': 'placed',
      'label': 'Order placed',
      'timestamp': now,
      'note': 'We have received your order.',
    });
    final confirmedRef = orderRef.collection('statusEvents').doc();
    batch.set(confirmedRef, {
      'userId': uid,
      'status': 'confirmed',
      'label': 'Confirmed',
      'timestamp': now,
      'note': 'Your order is being prepared.',
    });

    await batch.commit();
    return orderRef.id;
  }
}
