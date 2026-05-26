import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../dev/sample_products.dart';
import 'models/product.dart';

class ProductRepository {
  ProductRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  static List<Product> _mapSnapshotToProducts(
    QuerySnapshot<Map<String, dynamic>> snap,
  ) {
    final out = <Product>[];
    for (final d in snap.docs) {
      try {
        out.add(Product.fromDoc(d));
      } catch (e, st) {
        debugPrint('Skipping invalid product document ${d.id}: $e');
        assert(() {
          debugPrint('$st');
          return true;
        }());
      }
    }
    return out;
  }

  Stream<List<Product>> watchFeatured({int limit = 20}) {
    return _products
        .where('isFeatured', isEqualTo: true)
        .limit(limit)
        .snapshots()
        .map(_mapSnapshotToProducts);
  }

  Stream<List<Product>> watchAll({int limit = 400}) {
    return _products
        .limit(limit)
        .snapshots()
        .map(_mapSnapshotToProducts);
  }

  Future<Product?> getById(String id) async {
    final doc = await _products.doc(id).get();
    if (!doc.exists) return null;
    try {
      return Product.fromDoc(doc);
    } catch (e) {
      debugPrint('getById: invalid product $id: $e');
      return null;
    }
  }

  Stream<List<Product>> watchByCategory(String categoryId, {int limit = 100}) {
    return _products
        .where('categoryId', isEqualTo: categoryId)
        .limit(limit)
        .snapshots()
        .map(_mapSnapshotToProducts);
  }

  static const _legacySampleIds = [
    'sample-gown',
    'sample-blouse',
    'sample-trousers',
  ];

  /// Seeds the free sample catalogue (public image URLs — no Storage required).
  /// Removes old demo products (e.g. sample-trousers) so only the current catalogue remains.
  Future<void> seedSampleCatalogue() async {
    final newIds = sampleProductDocs.map((d) => d['id'] as String).toSet();
    final existing = await _products.get();

    var batch = _firestore.batch();
    var ops = 0;

    Future<void> commitIfNeeded({bool force = false}) async {
      if (ops == 0) return;
      if (force || ops >= 450) {
        await batch.commit();
        batch = _firestore.batch();
        ops = 0;
      }
    }

    for (final doc in existing.docs) {
      if (newIds.contains(doc.id)) continue;
      batch.delete(doc.reference);
      ops++;
      await commitIfNeeded();
    }

    final now = FieldValue.serverTimestamp();
    for (final legacyId in _legacySampleIds) {
      if (!newIds.contains(legacyId)) {
        batch.delete(_products.doc(legacyId));
        ops++;
        await commitIfNeeded();
      }
    }

    for (final doc in sampleProductDocs) {
      final id = doc['id'] as String;
      final data = Map<String, dynamic>.from(doc)..remove('id');
      batch.set(_products.doc(id), {
        ...data,
        'seeded': true,
        'updatedAt': now,
      });
      ops++;
      await commitIfNeeded();
    }

    await commitIfNeeded(force: true);
  }
}
