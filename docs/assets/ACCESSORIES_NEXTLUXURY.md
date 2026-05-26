# Accessories category image

## What you were seeing (brown tote)

The **Accessories** tile used your Next Luxury **URL** in code, but on **Flutter Web** many third-party image hosts do not send CORS headers. The request fails, and the UI fell back to **`assets/images/search_recent_tote.png`** — a brown leather tote — so it looked like the “wrong” category image.

## What we do now

1. **`assets/images/accessories_nextluxury_flatlay.jpg`** — vendored copy of  
   [Top-15-Fashion-Accessories-For-Men-1.jpg](https://nextluxury.com/wp-content/uploads/Top-15-Fashion-Accessories-For-Men-1.jpg) (men’s accessories flat lay: boots, hat, bag, watch, bow tie, etc.).

2. **`accessoriesDepartmentImage()`** in `lib/data/fashion_image_urls.dart` returns  
   **`kAccessoriesDepartmentHeroAssetPath`** (`assets/images/accessories_nextluxury_flatlay.jpg`) so the same art loads on **web, iOS, and Android** without CORS issues.

3. **`kNextLuxuryAccessoriesHeroImageUrl`** — kept as the canonical **remote** URL for attribution and for re-downloading.

## Refresh the file

From repo root:

```powershell
.\scripts\download_accessories_hero.ps1
```

Respect Next Luxury’s license and terms for production use; hosting your own copy under `assets/` is the reliable approach for the app.
