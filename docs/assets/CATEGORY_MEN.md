# Men category image (Deedat — URL, no local file)

The Men department tile uses a **direct image URL** in `lib/data/retailer_storefront_images.dart` (`DepartmentCategoryAssets.men`).

## Why not `https://deedatclothing.com/collections/men`?

That link is an **HTML page**, not an image. The app needs a URL that ends in something like `.jpg` / `.png` / `cdn.shopify.com/...` (“**Copy image address**” from a product photo).

## Current URL

It points to the **featured Shopify CDN image** of the first product in [Deedat — Men](https://deedatclothing.com/collections/men) (same visual as the top of that collection listing).

## How to change it

1. Open [deedatclothing.com/collections/men](https://deedatclothing.com/collections/men).
2. Right‑click a product image → **Copy image address**.
3. Paste that `https://…` string over `DepartmentCategoryAssets.men` in `retailer_storefront_images.dart`.

Hot restart the app after editing.

## Men → Formal Wear

Uses `DepartmentCategoryAssets.menFormalWearCategory` (direct **Pexels** URL — men’s suit / formal look).

The [Freepik men’s formal attire gallery](https://www.freepik.com/free-photos-vectors/mens-formal-attire) is a **web page**, not an image URL. To use a Freepik file in the app:

1. Open the file on Freepik and comply with its **license**.
2. Use **Copy link** / **Copy image address** for the actual file on their CDN (starts with `https://`), or download and add under `assets/images/`.

Then paste that URL (or asset path) over `menFormalWearCategory` in `retailer_storefront_images.dart`.

## Men → Casual Wear (department landing grid)

Uses `DepartmentCategoryAssets.menCasualWearCategory` in `retailer_storefront_images.dart` — direct **Italian Vega** Shopify article image URL for the COOFANDY men’s casual beach shirt tile.  
If the link stops loading, paste a fresh “Copy image address” URL or switch to a bundled file under `assets/images/`.
