import 'fashion_image_urls.dart';
import 'men_formal_wear_catalog_image_urls.dart';

/// Department hero images as **direct HTTPS URLs** (e.g. “Copy image address” from a product photo).
///
/// [Men](https://deedatclothing.com/collections/men) — Shopify serves product images on `cdn.shopify.com`.
/// The URL below is the featured image of the first product in that collection (same as opening the
/// collection and copying the main product shot). To swap art, paste another `https://…` from
/// [deedatclothing.com](https://deedatclothing.com/collections/men) (right-click image → copy image address).
///
/// Kept in this library with [RetailerStorefrontImages] so web dev builds load one fewer DDC module
/// (reduces flaky “Library not defined … Failed to initialize” errors on Chrome).
abstract final class DepartmentCategoryAssets {
  /// Featured shot from Deedat’s Men collection (Shopify CDN).
  static const men =
      'https://cdn.shopify.com/s/files/1/0885/4182/3274/files/0y7a7218-washed-black-graphic-t-shirt-washed-black-with-red-stitching-cotton-blend-with-washed-finish-relaxed-fit-top-front-view.jpg?v=1778919784';

  /// Collection page (for reference / deep links — not an image URL).
  static const menCollectionPage = 'https://deedatclothing.com/collections/men';

  /// Men **Casual Wear** subcategory tile — Italian Vega / COOFANDY article hero (Shopify CDN).
  static const menCasualWearCategory =
      'https://italianvega.com/cdn/shop/articles/COOFANDY_Men_s_Casual_Short_Sleeve_Button_Down_Summer_Beach_Shirt_Lightweight_Textured_Wrinkle_Free.jpg?v=1721642661';

  /// Men **Formal Wear** subcategory tile — Fashion Bug men’s formal shirt (`kMenFormalWearCategoryHero`).
  static const menFormalWearCategory = kMenFormalWearCategoryHero;

  /// Men **Basics & innerwear** subcategory tile — bundled WebP (white ribbed tank / undershirt style).
  ///
  /// Vendored from the Google Shopping thumbnail the team chose (same pixels as “Copy image address”):
  /// `https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcTZ-or0uzTWrGda7kYJQn__tgOmvQAj3x_vDaOX8dXQcMYIuSvkP0WX_9hIwc3vKLugJoh14spDoAL59TZ_Z6zgqBGfGDEmVMGPP-9_f1w1txxx_TAo6Lty092MhqWyy18fGDodLd4&usqp=CAc`
  /// — gstatic shopping URLs are volatile; replace this file under `assets/images/` if the link stops working.
  static const menInnerwearCategory = 'assets/images/men_innerwear_category.webp';

  /// Men **Swim & Beachwear** subcategory tile — bundled JPEG (man in wetsuit / surf — beach & water sports).
  ///
  /// The Google Images thumbnail you shared
  /// (`https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLZK_5GoPYGjHiw-aTRReHsANhsqiDVJG3akxWrHFoww&s`)
  /// is only a few kilobytes and upscales to a muddy tile; this file is a **high-res Pexels** still
  /// ([6381208](https://www.pexels.com/photo/a-man-surfing-on-the-waves-6381208/)) saved as `men_swim_beach_category.jpg`.
  static const menSwimBeachCategory = 'assets/images/men_swim_beach_category.jpg';
}

/// Large tiles for home “Shop by department”.
///
/// **Men** uses a Deedat / Shopify CDN hero (`[DepartmentCategoryAssets.men]`). Other departments still use
/// **Pexels** editorial URLs until stable retailer CDN links are supplied.
abstract final class RetailerStorefrontImages {
  static String get men => DepartmentCategoryAssets.men;
  static String get women => pexelsImg(FashionPhotos.deptWomen, w: 960, h: 1200);
  static String get kids => pexelsImg(FashionPhotos.kidsGroup1, w: 960, h: 1200);
  static String get accessories => accessoriesDepartmentImage(w: 960, h: 1200);
}
