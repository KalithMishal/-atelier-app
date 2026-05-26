import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/product.dart';
import 'models/wishlist_item.dart';

/// Cloud (Firestore) or local (SharedPreferences) wishlist — same API for UI.
abstract class WishlistRepository {
  Stream<List<WishlistItem>> watchItems(String uid);

  Stream<Set<String>> watchProductIds(String uid);

  Future<bool> toggle(String uid, Product product);

  Future<void> remove(String uid, String productId);
}

class FirestoreWishlistRepository implements WishlistRepository {
  FirestoreWishlistRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _ref(String uid) =>
      _firestore.collection('users').doc(uid).collection('wishlist');

  @override
  Stream<List<WishlistItem>> watchItems(String uid) {
    return _ref(uid)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => WishlistItem.fromDoc(d.id, d.data())).toList());
  }

  @override
  Stream<Set<String>> watchProductIds(String uid) {
    return _ref(uid).snapshots().map((snap) => snap.docs.map((d) => d.id).toSet());
  }

  @override
  Future<bool> toggle(String uid, Product product) async {
    final doc = _ref(uid).doc(product.id);
    final snap = await doc.get();
    if (snap.exists) {
      await doc.delete();
      return false;
    }
    await doc.set({
      'productId': product.id,
      'nameSnapshot': product.name,
      'brandSnapshot': product.brand,
      'imageUrlSnapshot': product.primaryImageUrl,
      'price': product.price,
      'currency': product.currency,
      'addedAt': FieldValue.serverTimestamp(),
    });
    return true;
  }

  @override
  Future<void> remove(String uid, String productId) => _ref(uid).doc(productId).delete();
}

/// Persists wishlist on device when Firestore is disabled (e.g. Windows desktop).
class SharedPrefsWishlistRepository implements WishlistRepository {
  SharedPrefsWishlistRepository(this._prefs);

  final SharedPreferences _prefs;

  final Map<String, StreamController<List<WishlistItem>>> _controllers = {};

  String _storageKey(String uid) => 'atelier_wishlist_v1_$uid';

  List<WishlistItem> _readSorted(String uid) {
    final raw = _prefs.getString(_storageKey(uid));
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    final items = <WishlistItem>[];
    for (final e in decoded) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final id = (m['productId'] ?? '').toString();
      if (id.isEmpty) continue;
      final ms = m['addedAtMs'];
      if (ms is int) {
        m['addedAt'] = Timestamp.fromMillisecondsSinceEpoch(ms);
      }
      items.add(WishlistItem.fromDoc(id, m));
    }
    items.sort((a, b) {
      final ta = a.addedAt?.millisecondsSinceEpoch ?? 0;
      final tb = b.addedAt?.millisecondsSinceEpoch ?? 0;
      return tb.compareTo(ta);
    });
    return items;
  }

  Future<void> _write(String uid, List<WishlistItem> items) async {
    final encoded = items.map((it) {
      return <String, dynamic>{
        'productId': it.productId,
        'nameSnapshot': it.name,
        'brandSnapshot': it.brand,
        'imageUrlSnapshot': it.imageUrl,
        'price': it.price,
        'currency': it.currency,
        'addedAtMs': it.addedAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      };
    }).toList();
    await _prefs.setString(_storageKey(uid), jsonEncode(encoded));
  }

  void _emit(String uid) {
    final list = _readSorted(uid);
    final c = _controllers[uid];
    if (c != null && !c.isClosed) {
      c.add(list);
    }
  }

  StreamController<List<WishlistItem>> _controllerFor(String uid) {
    return _controllers.putIfAbsent(uid, () {
      final c = StreamController<List<WishlistItem>>.broadcast();
      c.add(_readSorted(uid));
      return c;
    });
  }

  @override
  Stream<List<WishlistItem>> watchItems(String uid) => _controllerFor(uid).stream;

  @override
  Stream<Set<String>> watchProductIds(String uid) {
    return watchItems(uid).map((items) => items.map((e) => e.productId).toSet());
  }

  @override
  Future<bool> toggle(String uid, Product product) async {
    var items = _readSorted(uid);
    final i = items.indexWhere((e) => e.productId == product.id);
    if (i >= 0) {
      items = List.of(items)..removeAt(i);
      await _write(uid, items);
      _emit(uid);
      return false;
    }
    final next = List<WishlistItem>.from(items)
      ..insert(
        0,
        WishlistItem.fromDoc(product.id, {
          'nameSnapshot': product.name,
          'brandSnapshot': product.brand,
          'imageUrlSnapshot': product.primaryImageUrl,
          'price': product.price,
          'currency': product.currency,
          'addedAt': Timestamp.fromDate(DateTime.now()),
        }),
      );
    await _write(uid, next);
    _emit(uid);
    return true;
  }

  @override
  Future<void> remove(String uid, String productId) async {
    final items = _readSorted(uid).where((e) => e.productId != productId).toList();
    await _write(uid, items);
    _emit(uid);
  }
}
