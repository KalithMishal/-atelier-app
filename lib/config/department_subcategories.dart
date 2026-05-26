import '../data/fashion_image_urls.dart';
import '../data/kids_boys_catalog_image_urls.dart';
import '../data/kids_girls_catalog_image_urls.dart';
import '../data/retailer_storefront_images.dart';
import '../data/women_casual_wear_catalog_image_urls.dart';
import 'shop_categories.dart';

/// One tile on a department landing page (e.g. Men → Casual Wear).
class DepartmentSubcategory {
  const DepartmentSubcategory({
    required this.id,
    required this.label,
    required this.imageUrl,
    this.fallbackAsset = 'assets/images/search_edit_quiet.png',
  });

  final String id;
  final String label;
  final String imageUrl;
  final String fallbackAsset;
}

class DepartmentLandingData {
  const DepartmentLandingData({
    required this.id,
    required this.title,
    required this.heroImageUrl,
    required this.heroFallbackAsset,
    required this.seasonLabel,
    required this.subcategories,
  });

  final String id;
  final String title;
  final String heroImageUrl;
  final String heroFallbackAsset;
  final String seasonLabel;
  final List<DepartmentSubcategory> subcategories;
}

String _img(int photoId) => categoryImg(photoId);

final Map<String, DepartmentLandingData> kDepartmentLandings = {
  ShopCategoryId.men: DepartmentLandingData(
    id: ShopCategoryId.men,
    title: 'MEN',
    heroImageUrl: DepartmentCategoryAssets.men,
    heroFallbackAsset: 'assets/images/search_edit_quiet.png',
    seasonLabel: 'NEW SEASON',
    subcategories: [
      DepartmentSubcategory(
        id: 'casual-wear',
        label: 'Casual Wear',
        imageUrl: DepartmentCategoryAssets.menCasualWearCategory,
        fallbackAsset: 'assets/images/search_edit_quiet.png',
      ),
      DepartmentSubcategory(
        id: 'formal-wear',
        label: 'Formal Wear',
        imageUrl: DepartmentCategoryAssets.menFormalWearCategory,
        fallbackAsset: 'assets/images/search_edit_classic.png',
      ),
      DepartmentSubcategory(
        id: 'accessories',
        label: 'Accessories',
        imageUrl: accessoriesDepartmentImage(w: 600, h: 720),
        fallbackAsset: 'assets/images/search_edit_quiet.png',
      ),
    ],
  ),
  ShopCategoryId.women: DepartmentLandingData(
    id: ShopCategoryId.women,
    title: 'WOMEN',
    heroImageUrl: _img(FashionPhotos.deptWomen),
    heroFallbackAsset: 'assets/images/wish_silk_slip_dress.png',
    seasonLabel: 'SPRING SUMMER 2026',
    subcategories: [
      DepartmentSubcategory(
        id: 'casual-wear',
        label: 'Casual Wear',
        imageUrl: WomenCasualWearCatalogImageUrls.list[0],
        fallbackAsset: WomenCasualWearCatalogImageUrls.list[0],
      ),
      DepartmentSubcategory(
        id: 'saree',
        label: 'Saree',
        imageUrl: 'assets/images/women_saree_georgette_assorted_category.jpg',
        fallbackAsset: 'assets/images/women_saree_georgette_assorted_category.jpg',
      ),
    ],
  ),
  ShopCategoryId.children: DepartmentLandingData(
    id: ShopCategoryId.children,
    title: 'KIDS',
    heroImageUrl: _img(FashionPhotos.deptKids),
    heroFallbackAsset: 'assets/images/search_edit_quiet.png',
    seasonLabel: 'KIDS COLLECTION',
    subcategories: [
      DepartmentSubcategory(
        id: 'boys',
        label: 'Boys',
        imageUrl: KidsBoysCatalogImageUrls.list[0],
        fallbackAsset: 'assets/images/kids_boys_oversized_tee_brown_category.jpg',
      ),
      DepartmentSubcategory(
        id: 'girls',
        label: 'Girls',
        imageUrl: KidsGirlsCatalogImageUrls.list[0],
        fallbackAsset: KidsGirlsCatalogImageUrls.list[0],
      ),
    ],
  ),
  ShopCategoryId.accessories: DepartmentLandingData(
    id: ShopCategoryId.accessories,
    title: 'ACCESSORIES',
    heroImageUrl: accessoriesDepartmentImage(w: 600, h: 720),
    heroFallbackAsset: 'assets/images/search_edit_quiet.png',
    seasonLabel: 'FINISH THE LOOK',
    subcategories: [
      DepartmentSubcategory(
        id: 'jewelry',
        label: 'Jewelry',
        imageUrl: 'assets/images/pl_gold_jewelry.png',
        fallbackAsset: 'assets/images/search_edit_quiet.png',
      ),
      DepartmentSubcategory(
        id: 'bags',
        label: 'Bags',
        imageUrl: 'assets/images/search_recent_tote.png',
        fallbackAsset: 'assets/images/search_recent_tote.png',
      ),
      DepartmentSubcategory(
        id: 'watches',
        label: 'Watches',
        imageUrl: accessoriesDepartmentImage(w: 600, h: 720),
        fallbackAsset: 'assets/images/search_edit_quiet.png',
      ),
      DepartmentSubcategory(
        id: 'belts',
        label: 'Belts',
        imageUrl: 'assets/images/search_edit_classic.png',
        fallbackAsset: 'assets/images/search_edit_classic.png',
      ),
    ],
  ),
};

DepartmentLandingData? landingForDepartment(String departmentId) =>
    kDepartmentLandings[departmentId];

/// Home/search chip index → department id (MEN, WOMEN, KIDS, ACCESSORIES tiles).
String? departmentIdFromChipIndex(int chipIndex) => switch (chipIndex) {
      2 => ShopCategoryId.men,
      3 => ShopCategoryId.women,
      4 => ShopCategoryId.children,
      5 => ShopCategoryId.accessories,
      _ => null,
    };
