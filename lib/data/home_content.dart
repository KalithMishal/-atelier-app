import 'fashion_image_urls.dart';
import 'retailer_storefront_images.dart';

/// ODEL.lk–style home content (departments, promos, brands, banners).

class HomeBannerSlide {
  const HomeBannerSlide({
    required this.imageUrl,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.cta,
    this.fallbackAsset = 'assets/images/home_hero.png',
  });

  final String imageUrl;
  final String eyebrow;
  final String title;
  final String subtitle;
  final String cta;
  final String fallbackAsset;
}

class HomePromoTile {
  const HomePromoTile({
    required this.imageUrl,
    required this.label,
    required this.priceHint,
    this.fallbackAsset = 'assets/images/search_edit_quiet.png',
  });

  final String imageUrl;
  final String label;
  final String priceHint;
  final String fallbackAsset;
}

class HomeCategoryTile {
  const HomeCategoryTile({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.fallbackAsset = 'assets/images/search_recent_gown.png',
    this.filterIndex = 0,
    this.showTitleOverlay = true,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final String fallbackAsset;
  /// Maps to home category chip index when tapped.
  final int filterIndex;
  /// When false, only the image is shown (e.g. bundled art that already includes the title).
  final bool showTitleOverlay;
}

/// Top icon row — mirrors ODEL Men sub-departments.
class OdelQuickCategory {
  const OdelQuickCategory({
    required this.label,
    required this.imageUrl,
    required this.fallbackAsset,
    required this.filterIndex,
  });

  final String label;
  final String imageUrl;
  final String fallbackAsset;
  final int filterIndex;
}

class OdelDualPromo {
  const OdelDualPromo({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.fallbackAsset,
    this.filterIndex = 0,
  });

  final String badge;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String fallbackAsset;
  final int filterIndex;
}

const kMarqueeBrands = [
  'ODEL',
  'NOLIMIT',
  'SIGNATURE',
  'COTTON COLLECTION',
  'LEVI\'S',
  'U.S. POLO',
  'ARROW',
  'TOMMY HILFIGER',
  'KIN STUDIO',
  'ATELIER',
];

const kOdelFeaturedBrands = [
  'NOLIMIT',
  'SIGNATURE',
  'COTTON COLLECTION',
  'KIN STUDIO',
  'EKKO',
  'PEPPER ST.',
  'THE FACTORY OUTLET',
  'ODEL',
];

final kHomeBannerSlides = [
  HomeBannerSlide(
    imageUrl: bannerImg(FashionPhotos.bannerStore),
    eyebrow: 'ATELIER × ODEL STYLE',
    title: 'Sri Lanka\'s\nDepartment Edit',
    subtitle: 'Menswear from Colombo\'s favourite brands — shop like odel.lk',
    cta: 'SHOP NOW',
    fallbackAsset: 'assets/images/home_hero.png',
  ),
  HomeBannerSlide(
    imageUrl: bannerImg(FashionPhotos.bannerMens),
    eyebrow: 'MENS · NEW SEASON',
    title: 'Casual &\nFormalwear',
    subtitle: 'Polos, shirts, blazers & chinos — from LKR 2,490',
    cta: 'SHOP MEN',
    fallbackAsset: 'assets/images/search_edit_quiet.png',
  ),
  HomeBannerSlide(
    imageUrl: bannerImg(FashionPhotos.bannerFormal),
    eyebrow: 'UP TO 30% OFF',
    title: 'Formal\nEssentials',
    subtitle: 'Office shirts, tailored blazers & trousers',
    cta: 'VIEW FORMALWEAR',
    fallbackAsset: 'assets/images/search_edit_classic.png',
  ),
  HomeBannerSlide(
    imageUrl: bannerImg(FashionPhotos.bannerSale),
    eyebrow: 'WEEKEND SALE',
    title: 'Island\nOffers',
    subtitle: 'Selected styles from NOLIMIT, Signature & more',
    cta: 'SEE OFFERS',
    fallbackAsset: 'assets/images/search_edit_quiet.png',
  ),
];

/// ODEL men’s aisle shortcuts (Casualwear, Formalwear, …).
final kOdelQuickCategories = [
  OdelQuickCategory(
    label: 'Casualwear',
    imageUrl: promoImg(FashionPhotos.deptCasual),
    fallbackAsset: fallbackForDepartment('CASUAL'),
    filterIndex: 3,
  ),
  OdelQuickCategory(
    label: 'Formalwear',
    imageUrl: promoImg(FashionPhotos.deptFormal),
    fallbackAsset: fallbackForDepartment('FORMAL'),
    filterIndex: 2,
  ),
  OdelQuickCategory(
    label: 'Footwear',
    imageUrl: promoImg(FashionPhotos.chinoKhaki1),
    fallbackAsset: 'assets/images/search_recent_tote.png',
    filterIndex: 0,
  ),
  OdelQuickCategory(
    label: 'Accessories',
    imageUrl: accessoriesDepartmentImage(w: 400, h: 520),
    fallbackAsset: fallbackForDepartment('ACCESSORIES'),
    filterIndex: 4,
  ),
  OdelQuickCategory(
    label: 'New In',
    imageUrl: promoImg(FashionPhotos.denimIndigo1),
    fallbackAsset: 'assets/images/wish_cashmere_trench.png',
    filterIndex: 1,
  ),
  OdelQuickCategory(
    label: 'Essentials',
    imageUrl: promoImg(FashionPhotos.teeBlack1),
    fallbackAsset: 'assets/images/search_edit_quiet.png',
    filterIndex: 0,
  ),
];

final kOdelDualPromos = [
  OdelDualPromo(
    badge: '30% OFF',
    title: 'Formal Shirts',
    subtitle: 'Arrow · Signature',
    imageUrl: promoImg(FashionPhotos.shirtWhite1),
    fallbackAsset: 'assets/images/search_edit_classic.png',
    filterIndex: 2,
  ),
  OdelDualPromo(
    badge: 'NEW',
    title: 'Casual Polos',
    subtitle: 'NOLIMIT · U.S. Polo',
    imageUrl: promoImg(FashionPhotos.poloNavy1),
    fallbackAsset: 'assets/images/search_edit_quiet.png',
    filterIndex: 3,
  ),
];

final kHomePromoTiles = [
  HomePromoTile(
    imageUrl: promoImg(FashionPhotos.poloNavy1),
    label: 'Pique Polo',
    priceHint: 'From LKR 2,490',
    fallbackAsset: 'assets/images/search_edit_quiet.png',
  ),
  HomePromoTile(
    imageUrl: promoImg(FashionPhotos.denimIndigo1),
    label: 'Denim Jacket',
    priceHint: 'From LKR 5,490',
    fallbackAsset: 'assets/images/wish_cashmere_trench.png',
  ),
  HomePromoTile(
    imageUrl: promoImg(FashionPhotos.linenBeige1),
    label: 'Linen Shirt',
    priceHint: 'From LKR 4,590',
    fallbackAsset: 'assets/images/bag_item_shirt.png',
  ),
  HomePromoTile(
    imageUrl: promoImg(FashionPhotos.chinoKhaki1),
    label: 'Smart Chino',
    priceHint: 'From LKR 3,790',
    fallbackAsset: 'assets/images/bag_item_necklace.png',
  ),
  HomePromoTile(
    imageUrl: promoImg(FashionPhotos.teeBlack1),
    label: 'Street Tee',
    priceHint: 'From LKR 3,290',
    fallbackAsset: 'assets/images/search_edit_quiet.png',
  ),
];

/// Large department blocks — ODEL “Shop Men / Women / Home” style.
final kHomeCategoryTiles = [
  HomeCategoryTile(
    title: 'MEN',
    subtitle: 'Full collection',
    imageUrl: DepartmentCategoryAssets.men,
    fallbackAsset: fallbackForDepartment('MEN'),
    filterIndex: 0,
  ),
  HomeCategoryTile(
    title: 'FORMALWEAR',
    subtitle: 'Shirts · Blazers · Trousers',
    imageUrl: categoryImg(FashionPhotos.deptFormal),
    fallbackAsset: fallbackForDepartment('FORMAL'),
    filterIndex: 2,
  ),
  HomeCategoryTile(
    title: 'CASUALWEAR',
    subtitle: 'Polos · Tees · Chinos',
    imageUrl: categoryImg(FashionPhotos.deptCasual),
    fallbackAsset: fallbackForDepartment('CASUAL'),
    filterIndex: 3,
  ),
  HomeCategoryTile(
    title: 'ACCESSORIES',
    subtitle: 'Belts · Watches · More',
    imageUrl: accessoriesDepartmentImage(w: 600, h: 720),
    fallbackAsset: 'assets/images/search_edit_quiet.png',
    filterIndex: 4,
  ),
];
