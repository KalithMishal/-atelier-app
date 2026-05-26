# Men’s casual images from NOLIMIT (no local asset)

The four catalogue SKUs use **NOLIMIT’s CDN** (`nolimitlk.b-cdn.net`), built as:

`https://nolimitlk.b-cdn.net/ProductImage/{PRODUCT_ID}.jpg`

Implementation: `lib/data/nolimit_cdn_product_image.dart` and `lib/data/men_casual_catalog_image_urls.dart`.

## If a photo stops loading

1. Open the product on [nolimit.lk](https://www.nolimit.lk).
2. DevTools → **Network** → filter **Img** → reload.
3. Copy the real image URL and either:
   - paste it into `men_casual_catalog_image_urls.dart` for that getter, or  
   - change the product id passed into `nolimitCdnProductImageUrl(...)`.

`ProductNetworkImage` sends `Referer: https://www.nolimit.lk/` for NOLIMIT CDN hosts so the CDN allows hotlinking from the app.

## Firestore

If you already seeded products with old URLs, update `imageUrls` / variant `imageUrls` for those SKUs or re-run your seed script.
