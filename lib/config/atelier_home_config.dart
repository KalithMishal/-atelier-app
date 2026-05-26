import '../data/fashion_image_urls.dart';
import '../data/retailer_storefront_images.dart';

/// ═══════════════════════════════════════════════════════════════════════════
///  ATELIER HOME PAGE — edit this file to change your storefront homepage.
///
///  Layout style: department store (like odel.lk) — hero, categories, products.
///  Set any `show… = false` to hide a block. Reorder [sectionOrder] to move blocks.
/// ═══════════════════════════════════════════════════════════════════════════

// ─── Store identity ───────────────────────────────────────────────────────────

const kStoreName = 'ATELIER';
const kSearchHint = 'Search men, women, kids, accessories…';
const kSaleBannerText = 'MEMBER OFFERS — Up to 30% off across all departments';

// ─── Which sections appear (turn on/off) ──────────────────────────────────────

const kShowSearch = true;
const kShowHeroCarousel = true;
const kShowTrustStrip = true;
const kShowBrandTicker = false;
const kShowSaleBanner = true;
const kShowQuickLinks = false;
const kShowDepartments = true;
const kShowDualPromos = true;
const kShowPartnerBrands = false;
const kShowFlashDeals = false;
const kShowNewProductsRow = true;
const kShowCategoryChips = true;
const kShowTrendingGrid = true;

/// Order of blocks on the page (remove a line to hide that block entirely).
const kSectionOrder = [
  HomeSection.search,
  HomeSection.hero,
  HomeSection.trustStrip,
  HomeSection.departments,
  HomeSection.dualPromos,
  HomeSection.newProducts,
  HomeSection.saleBanner,
  HomeSection.categoryChips,
  HomeSection.trendingGrid,
  HomeSection.brandTicker,
  HomeSection.quickLinks,
  HomeSection.partnerBrands,
  HomeSection.flashDeals,
];

enum HomeSection {
  search,
  hero,
  trustStrip,
  brandTicker,
  saleBanner,
  quickLinks,
  departments,
  dualPromos,
  partnerBrands,
  flashDeals,
  newProducts,
  categoryChips,
  trendingGrid,
}

/// Service promises shown under the hero (like major fashion apps).
const kTrustStripItems = [
  ('local_shipping_outlined', 'Colombo delivery'),
  ('replay_outlined', 'Easy returns'),
  ('verified_user_outlined', 'Secure checkout'),
];

// ─── Filter chips above the product grid ──────────────────────────────────────

/// Chip index matches [filterProductsByChip] in shop_categories.dart.
const kCategoryChips = ['ALL', 'NEW IN', 'MEN', 'WOMEN', 'KIDS', 'ACCESSORIES'];

// ─── Scrolling brand ticker ───────────────────────────────────────────────────

const kTickerBrands = [
  'ATELIER',
  'NOLIMIT',
  'SIGNATURE',
  'COTTON COLLECTION',
  'KIN STUDIO',
  'EKKO',
  'PEPPER ST.',
  'THE FACTORY OUTLET',
];

const kPartnerBrands = [
  'NOLIMIT',
  'SIGNATURE',
  'COTTON COLLECTION',
  'KIN STUDIO',
  'EKKO',
  'PEPPER ST.',
  'THE FACTORY OUTLET',
];

// ─── Section titles (your wording) ────────────────────────────────────────────

const kQuickLinksTitle = 'BROWSE';
const kDepartmentsTitle = 'SHOP BY DEPARTMENT';
const kFlashDealsTitle = 'TOP DEALS';
const kNewProductsTitle = 'NEW ARRIVALS';
const kTrendingTitle = 'Shop the edit';
const kTrendingSubtitle = 'Men, women, kids & accessories from Sri Lankan brands';

// ─── Data models ──────────────────────────────────────────────────────────────

/// Use [assetPath] for reliable local images, or [networkUrl] for online photos.
class HomeVisual {
  const HomeVisual.asset(this.assetPath) : networkUrl = null;
  const HomeVisual.network(this.networkUrl) : assetPath = null;

  final String? assetPath;
  final String? networkUrl;

  bool get isAsset => assetPath != null && assetPath!.isNotEmpty;
}

class HomeBannerData {
  const HomeBannerData({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.visual,
    this.filterIndex = 0,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final String cta;
  final HomeVisual visual;
  final int filterIndex;
}

class HomeLinkData {
  const HomeLinkData({
    required this.label,
    required this.visual,
    this.filterIndex = 0,
  });

  final String label;
  final HomeVisual visual;
  final int filterIndex;
}

class HomeDepartmentData {
  const HomeDepartmentData({
    required this.title,
    required this.subtitle,
    required this.visual,
    this.filterIndex = 0,
  });

  final String title;
  final String subtitle;
  final HomeVisual visual;
  final int filterIndex;
}

class HomeDealData {
  const HomeDealData({
    required this.label,
    required this.priceHint,
    required this.visual,
  });

  final String label;
  final String priceHint;
  final HomeVisual visual;
}

class HomeDualPromoData {
  const HomeDualPromoData({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.visual,
    this.filterIndex = 0,
  });

  final String badge;
  final String title;
  final String subtitle;
  final HomeVisual visual;
  final int filterIndex;
}

// ─── Hero slides — edit text & images here ────────────────────────────────────

final kHomeBanners = [
  HomeBannerData(
    eyebrow: 'ATELIER · COLOMBO',
    title: 'Fashion for\neveryone',
    subtitle: 'Men, women, kids & accessories from Sri Lankan brands',
    cta: 'SHOP ALL',
    visual: HomeVisual.asset('assets/images/home_hero.png'),
  ),
  HomeBannerData(
    eyebrow: 'WOMEN',
    title: 'New season\nessentials',
    subtitle: 'Dresses, blouses & tailored pieces',
    cta: 'SHOP WOMEN',
    visual: HomeVisual.network(categoryImg(FashionPhotos.deptWomen)),
    filterIndex: 3,
  ),
  HomeBannerData(
    eyebrow: 'KIDS',
    title: 'Little\nstyles',
    subtitle: 'Comfortable everyday wear for children',
    cta: 'SHOP KIDS',
    visual: HomeVisual.network(categoryImg(FashionPhotos.deptKids)),
    filterIndex: 4,
  ),
];

// ─── Round quick links (under sale banner) ────────────────────────────────────

final kQuickLinks = [
  HomeLinkData(label: 'Men', visual: HomeVisual.network(RetailerStorefrontImages.men), filterIndex: 2),
  HomeLinkData(label: 'Women', visual: HomeVisual.network(RetailerStorefrontImages.women), filterIndex: 3),
  HomeLinkData(label: 'Kids', visual: HomeVisual.network(RetailerStorefrontImages.kids), filterIndex: 4),
  HomeLinkData(label: 'New In', visual: HomeVisual.asset('assets/images/wish_cashmere_trench.png'), filterIndex: 1),
  HomeLinkData(
    label: 'Accessories',
    visual: HomeVisual.asset(kAccessoriesDepartmentHeroAssetPath),
    filterIndex: 5,
  ),
];

// ─── Large department tiles ───────────────────────────────────────────────────

final kDepartments = [
  HomeDepartmentData(
    title: 'MEN',
    subtitle: 'Shirts · Polos · Formal',
    visual: HomeVisual.network(RetailerStorefrontImages.men),
    filterIndex: 2,
  ),
  HomeDepartmentData(
    title: 'WOMEN',
    subtitle: 'Dresses · Blouses',
    visual: HomeVisual.network(RetailerStorefrontImages.women),
    filterIndex: 3,
  ),
  HomeDepartmentData(
    title: 'KIDS',
    subtitle: 'Everyday wear',
    visual: HomeVisual.network(RetailerStorefrontImages.kids),
    filterIndex: 4,
  ),
];

// ─── Optional dual promos (enable with kShowDualPromos) ───────────────────────

final kDualPromos = [
  HomeDualPromoData(
    badge: 'WOMEN',
    title: 'Evening edit',
    subtitle: 'Dresses & occasion wear',
    visual: HomeVisual.network(RetailerStorefrontImages.women),
    filterIndex: 3,
  ),
  HomeDualPromoData(
    badge: 'KIDS',
    title: 'Back to school',
    subtitle: 'Comfort fits from LKR 1,990',
    visual: HomeVisual.network(RetailerStorefrontImages.kids),
    filterIndex: 4,
  ),
];

// ─── Horizontal deal cards ────────────────────────────────────────────────────

final kFlashDeals = [
  HomeDealData(
    label: 'Pique Polo',
    priceHint: 'From LKR 2,490',
    visual: HomeVisual.asset('assets/images/search_edit_quiet.png'),
  ),
  HomeDealData(
    label: 'Denim Jacket',
    priceHint: 'From LKR 5,490',
    visual: HomeVisual.asset('assets/images/wish_cashmere_trench.png'),
  ),
  HomeDealData(
    label: 'Linen Shirt',
    priceHint: 'From LKR 4,590',
    visual: HomeVisual.asset('assets/images/bag_item_shirt.png'),
  ),
  HomeDealData(
    label: 'Smart Chino',
    priceHint: 'From LKR 3,790',
    visual: HomeVisual.asset('assets/images/bag_item_necklace.png'),
  ),
  HomeDealData(
    label: 'Street Tee',
    priceHint: 'From LKR 3,290',
    visual: HomeVisual.asset('assets/images/search_edit_quiet.png'),
  ),
];

bool sectionEnabled(HomeSection section) {
  if (!kSectionOrder.contains(section)) return false;
  return switch (section) {
    HomeSection.search => kShowSearch,
    HomeSection.hero => kShowHeroCarousel,
    HomeSection.trustStrip => kShowTrustStrip,
    HomeSection.brandTicker => kShowBrandTicker,
    HomeSection.saleBanner => kShowSaleBanner,
    HomeSection.quickLinks => kShowQuickLinks,
    HomeSection.departments => kShowDepartments,
    HomeSection.dualPromos => kShowDualPromos,
    HomeSection.partnerBrands => kShowPartnerBrands,
    HomeSection.flashDeals => kShowFlashDeals,
    HomeSection.newProducts => kShowNewProductsRow,
    HomeSection.categoryChips => kShowCategoryChips,
    HomeSection.trendingGrid => kShowTrendingGrid,
  };
}

Iterable<HomeSection> get activeSections =>
    kSectionOrder.where(sectionEnabled);
