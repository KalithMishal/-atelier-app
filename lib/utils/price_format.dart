String formatPrice(num amount, {String currency = 'LKR'}) {
  final whole = amount.round();
  final s = whole.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return '$currency ${buf.toString()}';
}
