import 'nolimit_cdn_product_image.dart';

/// Hero shots from **NOLIMIT’s own CDN** (no bundled assets). Product ids match listings on
/// [nolimit.lk](https://www.nolimit.lk) at the time of wiring; titles in the app may still say
/// “TOM DAVID” where we reuse NOLIMIT’s closest in-stock oversized tees.
abstract final class MenCasualCatalogImageUrls {
  /// NOLIMIT Men’s Slim Fit Cotton Polo T‑Shirt Green — [product 55713](https://www.nolimit.lk/products/NOLIMIT-Men's-Slim-Fit-Cotton-Polo-T-Shirt-Green/55713).
  static String get nolimitPoloForest => nolimitCdnProductImageUrl(55713);

  /// Dark oversized tee — Warner Bros men’s oversized **Steel Blue** (closest to navy).
  static String get tomDavidTeeNavy => nolimitCdnProductImageUrl(46560);

  /// NOLIMIT Men’s Oversized Screen Print T‑Shirt **Misty Rose** (mint-adjacent on site).
  static String get tomDavidTeeMint => nolimitCdnProductImageUrl(56437);
}
