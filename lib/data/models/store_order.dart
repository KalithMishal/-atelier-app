import 'package:cloud_firestore/cloud_firestore.dart';

class StoreOrder {
  const StoreOrder({
    required this.id,
    required this.userId,
    required this.status,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.currency,
    required this.previewImageUrls,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String status;
  final num subtotal;
  final num shipping;
  final num tax;
  final num total;
  final String currency;
  final List<String> previewImageUrls;
  final Timestamp? createdAt;

  bool get isDelivered => status.toLowerCase() == 'delivered';
  bool get isActive => !isDelivered && status.toLowerCase() != 'cancelled';

  String get displayStatus {
    switch (status.toLowerCase()) {
      case 'delivered':
        return 'DELIVERED';
      case 'cancelled':
        return 'CANCELLED';
      case 'shipped':
        return 'SHIPPED';
      case 'confirmed':
        return 'CONFIRMED';
      default:
        return 'ON ITS WAY';
    }
  }

  factory StoreOrder.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return StoreOrder(
      id: doc.id,
      userId: (data['userId'] ?? '').toString(),
      status: (data['status'] ?? 'placed').toString(),
      subtotal: (data['subtotal'] ?? 0) as num,
      shipping: (data['shipping'] ?? 0) as num,
      tax: (data['tax'] ?? 0) as num,
      total: (data['total'] ?? 0) as num,
      currency: (data['currency'] ?? 'USD').toString(),
      previewImageUrls: (data['previewImageUrls'] is Iterable)
          ? (data['previewImageUrls'] as Iterable).map((e) => e.toString()).where((u) => u.isNotEmpty).toList()
          : const <String>[],
      createdAt: data['createdAt'] is Timestamp ? data['createdAt'] as Timestamp : null,
    );
  }
}

class OrderLineItem {
  const OrderLineItem({
    required this.productId,
    required this.nameSnapshot,
    required this.brandSnapshot,
    required this.imageUrlSnapshot,
    required this.qty,
    required this.unitPrice,
    required this.currency,
  });

  final String productId;
  final String nameSnapshot;
  final String brandSnapshot;
  final String imageUrlSnapshot;
  final int qty;
  final num unitPrice;
  final String currency;

  factory OrderLineItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return OrderLineItem(
      productId: (data['productId'] ?? doc.id).toString(),
      nameSnapshot: (data['nameSnapshot'] ?? '').toString(),
      brandSnapshot: (data['brandSnapshot'] ?? '').toString(),
      imageUrlSnapshot: (data['imageUrlSnapshot'] ?? '').toString(),
      qty: ((data['qty'] ?? 1) as num).toInt(),
      unitPrice: (data['unitPrice'] ?? 0) as num,
      currency: (data['currency'] ?? 'USD').toString(),
    );
  }
}

class OrderStatusEvent {
  const OrderStatusEvent({
    required this.status,
    required this.label,
    required this.note,
    this.timestamp,
    this.tracking,
  });

  final String status;
  final String label;
  final String note;
  final Timestamp? timestamp;
  final String? tracking;

  factory OrderStatusEvent.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return OrderStatusEvent(
      status: (data['status'] ?? '').toString(),
      label: (data['label'] ?? data['status'] ?? '').toString(),
      note: (data['note'] ?? '').toString(),
      timestamp: data['timestamp'] is Timestamp ? data['timestamp'] as Timestamp : null,
      tracking: data['tracking']?.toString(),
    );
  }
}
