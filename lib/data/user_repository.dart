import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/saved_address.dart';
import 'models/user_profile.dart';

class UserRepository {
  UserRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<UserProfile> watchProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      return UserProfile.fromDoc(uid, doc.data());
    });
  }

  /// Always returns a [UserProfile]; if the Firestore doc is missing, fields may be empty
  /// and callers should merge with [UserProfile.fromFirebaseUser].
  Future<UserProfile> getProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return UserProfile.fromDoc(uid, doc.exists ? doc.data() : null);
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> patch) {
    return _firestore.collection('users').doc(uid).set(
      {
        ...patch,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  CollectionReference<Map<String, dynamic>> _addresses(String uid) =>
      _firestore.collection('users').doc(uid).collection('addresses');

  Stream<List<SavedAddress>> watchAddresses(String uid) {
    return _addresses(uid).snapshots().map((snap) {
      final list = snap.docs.map((d) => SavedAddress.fromDoc(d.id, d.data())).toList();
      list.sort((a, b) {
        if (a.isDefault != b.isDefault) return a.isDefault ? -1 : 1;
        return a.tag.compareTo(b.tag);
      });
      return list;
    });
  }

  Future<String> saveAddress(String uid, SavedAddress address, {String? id}) async {
    final ref = id != null ? _addresses(uid).doc(id) : _addresses(uid).doc();
    if (address.isDefault) {
      await _clearDefaultAddress(uid);
    }
    await ref.set({
      ...address.toMap(),
      if (id == null) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return ref.id;
  }

  Future<void> deleteAddress(String uid, String addressId) =>
      _addresses(uid).doc(addressId).delete();

  Future<void> _clearDefaultAddress(String uid) async {
    final snap = await _addresses(uid).where('isDefault', isEqualTo: true).get();
    final batch = _firestore.batch();
    for (final d in snap.docs) {
      batch.update(d.reference, {'isDefault': false});
    }
    await batch.commit();
  }
}

