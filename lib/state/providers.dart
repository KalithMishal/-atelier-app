import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/firebase_backend.dart';
import '../data/app_preferences.dart';
import '../data/auth_repository.dart';
import '../data/cart_repository.dart';
import '../data/local_catalogue.dart';
import '../data/models/cart_item.dart';
import '../data/models/product.dart';
import '../data/models/saved_address.dart';
import '../data/models/store_order.dart';
import '../data/models/user_profile.dart';
import '../data/models/wishlist_item.dart';
import '../data/order_repository.dart';
import '../data/product_repository.dart';
import '../data/user_repository.dart';
import '../data/wishlist_repository.dart';

/// Non-null only when [useFirestoreBackend] is true. On Windows this stays null
/// so nothing ever calls [FirebaseFirestore.instance] (avoids native crashes).
final firebaseFirestoreProvider = Provider<FirebaseFirestore?>((ref) {
  if (!useFirestoreBackend) return null;
  return FirebaseFirestore.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(firestore: ref.watch(firebaseFirestoreProvider));
});

final productRepositoryProvider = Provider<ProductRepository?>((ref) {
  final fs = ref.watch(firebaseFirestoreProvider);
  if (fs == null) return null;
  return ProductRepository(firestore: fs);
});

final cartRepositoryProvider = Provider<CartRepository?>((ref) {
  final fs = ref.watch(firebaseFirestoreProvider);
  if (fs == null) return null;
  return CartRepository(firestore: fs);
});

final orderRepositoryProvider = Provider<OrderRepository?>((ref) {
  final fs = ref.watch(firebaseFirestoreProvider);
  if (fs == null) return null;
  return OrderRepository(firestore: fs);
});

final userRepositoryProvider = Provider<UserRepository?>((ref) {
  final fs = ref.watch(firebaseFirestoreProvider);
  if (fs == null) return null;
  return UserRepository(firestore: fs);
});

final wishlistRepositoryProvider = Provider<WishlistRepository?>((ref) {
  if (useFirestoreBackend) {
    final fs = ref.watch(firebaseFirestoreProvider);
    if (fs == null) return null;
    return FirestoreWishlistRepository(firestore: fs);
  }
  return SharedPrefsWishlistRepository(atelierSharedPreferences);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

/// Merges bundled sample SKUs with Firestore so partial cloud data (e.g. only one
/// department seeded) still shows every category. Remote overrides non-seeded ids;
/// [LocalCatalogue.seededProductIds] keep in-code fields (especially [Product.imageUrls]) so
/// catalogue image fixes apply without re-running Firestore seed.
List<Product> _mergeRemoteWithLocal(List<Product> remote) {
  final local = LocalCatalogue.products;
  if (remote.isEmpty) return local;
  final seededIds = LocalCatalogue.seededProductIds;
  final byId = <String, Product>{for (final p in local) p.id: p};
  for (final p in remote) {
    if (LocalCatalogue.shouldHideFromCatalogue(p)) continue;
    if (seededIds.contains(p.id)) continue;
    byId[p.id] = p;
  }
  return byId.values.toList();
}

final featuredProductsProvider = StreamProvider<List<Product>>((ref) {
  if (!useFirestoreBackend) {
    return Stream.value(LocalCatalogue.featured());
  }
  final repo = ref.watch(productRepositoryProvider);
  if (repo == null) {
    return Stream.value(LocalCatalogue.featured());
  }
  return repo.watchFeatured().map((remote) {
    final filtered = remote.where((p) => !LocalCatalogue.shouldHideFromCatalogue(p)).toList();
    // Same merge as [allProductsProvider]: when Firestore returns a non-empty featured list we must
    // still overlay **bundled** seeded SKUs (correct `imageUrls`). Returning `remote` alone used
    // stale cloud heroes (e.g. slip-dress placeholders) for NOLIMIT saree tiles.
    final merged = _mergeRemoteWithLocal(filtered);
    return merged.where((p) => p.isFeatured).toList();
  });
});

final allProductsProvider = StreamProvider<List<Product>>((ref) {
  if (!useFirestoreBackend) {
    return Stream.value(LocalCatalogue.products);
  }
  final repo = ref.watch(productRepositoryProvider);
  if (repo == null) {
    return Stream.value(LocalCatalogue.products);
  }
  return repo.watchAll().map(_mergeRemoteWithLocal);
});

final cartItemsProvider = StreamProvider<List<CartItem>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream<List<CartItem>>.empty();
  if (!useFirestoreBackend) {
    return Stream.value(const <CartItem>[]);
  }
  final cart = ref.watch(cartRepositoryProvider);
  if (cart == null) {
    return Stream.value(const <CartItem>[]);
  }
  return cart.watchItems(user.uid);
});

class CheckoutDraftNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => <String, dynamic>{};

  void setDraft(Map<String, dynamic> draft) => state = draft;
  void clear() => state = <String, dynamic>{};
}

final checkoutDraftProvider =
    NotifierProvider<CheckoutDraftNotifier, Map<String, dynamic>>(CheckoutDraftNotifier.new);

final userProfileProvider = StreamProvider<UserProfile>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream<UserProfile>.empty();
  if (!useFirestoreBackend) {
    return Stream.value(UserProfile.fromFirebaseUser(user));
  }
  final users = ref.watch(userRepositoryProvider);
  if (users == null) {
    return Stream.value(UserProfile.fromFirebaseUser(user));
  }
  return users.watchProfile(user.uid);
});

final userOrdersProvider = StreamProvider<List<StoreOrder>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream<List<StoreOrder>>.empty();
  if (!useFirestoreBackend) {
    return Stream.value(const <StoreOrder>[]);
  }
  final orders = ref.watch(orderRepositoryProvider);
  if (orders == null) {
    return Stream.value(const <StoreOrder>[]);
  }
  return orders.watchUserOrders(user.uid);
});

final wishlistItemsProvider = StreamProvider<List<WishlistItem>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream<List<WishlistItem>>.empty();
  final wish = ref.watch(wishlistRepositoryProvider);
  if (wish == null) {
    return Stream.value(const <WishlistItem>[]);
  }
  return wish.watchItems(user.uid);
});

final wishlistProductIdsProvider = StreamProvider<Set<String>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(<String>{});
  final wish = ref.watch(wishlistRepositoryProvider);
  if (wish == null) {
    return Stream.value(<String>{});
  }
  return wish.watchProductIds(user.uid);
});

final savedAddressesProvider = StreamProvider<List<SavedAddress>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream<List<SavedAddress>>.empty();
  if (!useFirestoreBackend) {
    return Stream.value(const <SavedAddress>[]);
  }
  final users = ref.watch(userRepositoryProvider);
  if (users == null) {
    return Stream.value(const <SavedAddress>[]);
  }
  return users.watchAddresses(user.uid);
});
