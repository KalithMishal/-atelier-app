const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String formatMoney(num amount, {String currency = 'USD'}) {
  final symbol = switch (currency.toUpperCase()) {
    'USD' => '\$',
    'EUR' => '€',
    'GBP' => '£',
    'LKR' => 'LKR ',
    _ => '$currency ',
  };
  return '$symbol${amount.toStringAsFixed(2)}';
}

String formatOrderDate(DateTime? date) {
  if (date == null) return 'Date pending';
  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}

String shortOrderId(String id) {
  if (id.length <= 8) return id.toUpperCase();
  return id.substring(0, 8).toUpperCase();
}
