import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/cart_item.dart';
import 'models/product.dart';

class CartRepository {
  CartRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _itemsRef(String uid) {
    return _firestore.collection('carts').doc(uid).collection('items');
  }

  Stream<List<CartItem>> watchItems(String uid) {
    return _itemsRef(uid)
        .snapshots()
        .map((snap) => snap.docs.map(CartItem.fromDoc).toList());
  }

  Future<void> addOrIncrement({
    required String uid,
    required Product product,
    required int qty,
    Map<String, dynamic>? variant,
  }) async {
    final itemDoc = _itemsRef(uid).doc(product.id);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(itemDoc);
      final now = FieldValue.serverTimestamp();
      if (snap.exists) {
        final currentQty = ((snap.data()?['qty'] ?? 1) as num).toInt();
        tx.set(itemDoc, {
          'qty': currentQty + qty,
          'updatedAt': now,
        }, SetOptions(merge: true));
      } else {
        tx.set(itemDoc, {
          'qty': qty,
          'unitPrice': product.price,
          'currency': product.currency,
          'nameSnapshot': product.name,
          'brandSnapshot': product.brand,
          'imageUrlSnapshot': product.primaryImageUrl,
          'variant': variant ?? const <String, dynamic>{},
          'addedAt': now,
          'updatedAt': now,
        });
      }
      tx.set(_firestore.collection('carts').doc(uid), {'updatedAt': now}, SetOptions(merge: true));
    });
  }

  Future<void> setQty({
    required String uid,
    required String productId,
    required int qty,
  }) async {
    final doc = _itemsRef(uid).doc(productId);
    if (qty <= 0) {
      await doc.delete();
      return;
    }
    await doc.set({'qty': qty, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  Future<void> remove({
    required String uid,
    required String productId,
  }) {
    return _itemsRef(uid).doc(productId).delete();
  }

  Future<void> clear(String uid) async {
    final batch = _firestore.batch();
    final snap = await _itemsRef(uid).get();
    for (final d in snap.docs) {
      batch.delete(d.reference);
    }
    batch.set(_firestore.collection('carts').doc(uid), {'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    await batch.commit();
  }
}

