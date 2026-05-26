/// Builds NOLIMIT’s Bunny CDN hero image URL for a **website product id** (the number at the end
/// of `nolimit.lk/products/.../#####`).
///
/// Pattern is inferred from their CDN (`…/ProductImage/{id}.jpg`). If a photo stops loading after a
/// site update, open the product on [nolimit.lk](https://www.nolimit.lk), copy the real `img src`
/// from DevTools, and adjust this template.
String nolimitCdnProductImageUrl(int productId) {
  return 'https://nolimitlk.b-cdn.net/ProductImage/$productId.jpg';
}

/// True for NOLIMIT image hosts that expect a browser-like [Referer].
bool nolimitCdnImageNeedsReferrer(String imageUrl) {
  final u = imageUrl.toLowerCase();
  return u.contains('nolimitlk.b-cdn.net') || u.contains('nolimitcdn.com');
}
