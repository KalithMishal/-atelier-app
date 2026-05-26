import 'package:cloud_firestore/cloud_firestore.dart';

class SavedAddress {
  const SavedAddress({
    required this.id,
    required this.tag,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.apt,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.isDefault,
  });

  final String id;
  final String tag;
  final String fullName;
  final String phone;
  final String street;
  final String apt;
  final String city;
  final String postalCode;
  final String country;
  final bool isDefault;

  factory SavedAddress.fromDoc(String id, Map<String, dynamic>? data) {
    final d = data ?? const <String, dynamic>{};
    return SavedAddress(
      id: id,
      tag: (d['tag'] ?? 'HOME').toString(),
      fullName: (d['fullName'] ?? '').toString(),
      phone: (d['phone'] ?? '').toString(),
      street: (d['street'] ?? '').toString(),
      apt: (d['apt'] ?? '').toString(),
      city: (d['city'] ?? '').toString(),
      postalCode: (d['postalCode'] ?? '').toString(),
      country: (d['country'] ?? 'Sri Lanka').toString(),
      isDefault: d['isDefault'] == true,
    );
  }

  Map<String, dynamic> toMap() => {
        'tag': tag,
        'fullName': fullName,
        'phone': phone,
        'street': street,
        'apt': apt,
        'city': city,
        'postalCode': postalCode,
        'country': country,
        'isDefault': isDefault,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> toCheckoutDraft() => {
        'firstName': fullName.split(' ').first,
        'lastName': fullName.split(' ').length > 1 ? fullName.split(' ').sublist(1).join(' ') : '',
        'phone': phone,
        'street': street,
        'apt': apt,
        'city': city,
        'postalCode': postalCode,
        'country': country,
      };
}
