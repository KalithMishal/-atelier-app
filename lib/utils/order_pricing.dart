import '../data/models/cart_item.dart';
import '../data/order_repository.dart';

class OrderTotals {
  const OrderTotals({
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.currency,
  });

  final num subtotal;
  final num shipping;
  final num tax;
  final num total;
  final String currency;
}

OrderTotals computeOrderTotals(List<CartItem> items) {
  final subtotal = items.fold<num>(0, (sum, i) => sum + i.lineTotal);
  final currency = items.isNotEmpty ? items.first.currency : 'USD';
  final shipping = items.isEmpty ? 0.0 : OrderRepository.shippingFlat;
  final tax = subtotal * OrderRepository.taxRate;
  return OrderTotals(
    subtotal: subtotal,
    shipping: shipping,
    tax: tax,
    total: subtotal + shipping + tax,
    currency: currency,
  );
}
