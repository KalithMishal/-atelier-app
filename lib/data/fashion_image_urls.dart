/// Fashion photography via Pexels CDN.
/// Department IDs verified on pexels.com (lifestyle / editorial style).
String pexelsImg(
  int photoId, {
  int w = 800,
  int h = 1000,
}) =>
    'https://images.pexels.com/photos/$photoId/pexels-photo-$photoId.jpeg'
    '?auto=compress&cs=tinysrgb&w=$w&h=$h&fit=crop';

/// Verified Pexels IDs — titles checked on pexels.com.
abstract final class FashionPhotos {
  // --- Polos (man in polo shirt) ---
  static const poloNavy1 = 614810; // Man in Brown Polo Shirt
  static const poloNavy2 = 1232459; // Man in Blue Polo + Watch
  static const poloNavy3 = 7270145; // Man in Long Sleeves Polo Posing
  static const poloBlack1 = 159844; // Man in Black and White Polo
  static const poloBlack2 = 4046304; // Man portrait (dark shirt)
  static const poloBlack3 = 8192050; // Man in Suit
  static const poloWhite1 = 3587145; // Man in White Polo (grayscale)
  static const poloWhite2 = 614810;
  static const poloWhite3 = 7270145;

  // --- Formal shirts (man in dress shirt / suit) ---
  static const shirtWhite1 = 1043473; // Man blue shirt + black formal suit
  static const shirtWhite2 = 10411933; // Man in black suit
  static const shirtWhite3 = 17311569; // Man in suit, studio
  static const shirtBlue1 = 1043473;
  static const shirtBlue2 = 8192050;
  static const shirtBlue3 = 1232459;
  static const shirtCharcoal1 = 10411933;
  static const shirtCharcoal2 = 8192050;
  static const shirtCharcoal3 = 6116878; // Man in suit at store

  // --- Blazers / formal jackets ---
  static const blazerNavy1 = 1043473;
  static const blazerNavy2 = 10411933;
  static const blazerCharcoal1 = 8192050;
  static const blazerCharcoal2 = 17311569;

  // --- Linen / casual shirts ---
  static const linenBeige1 = 3587145;
  static const linenBeige2 = 614810;
  static const linenOlive1 = 7270145;
  static const linenOlive2 = 1232459;

  // --- Street tees ---
  static const teeBlack1 = 1653877; // Plain tee product (flat lay)
  static const teeBlack2 = 4066293;
  static const teeSand1 = 3587145;
  static const teeSand2 = 614810;

  // --- Chinos / trousers ---
  static const chinoKhaki1 = 1598507;
  static const chinoKhaki2 = 1884581;
  static const chinoNavy1 = 1884584;
  static const chinoNavy2 = 849825;

  // --- Denim jackets ---
  static const denimIndigo1 = 1124468;
  static const denimIndigo2 = 6311392;
  static const denimBlack1 = 949670;
  static const denimBlack2 = 1751117;

  // --- Crew neck tees ---
  static const crewGrey1 = 4066293;
  static const crewGrey2 = 1653877;
  static const crewForest1 = 7270145;
  static const crewForest2 = 614810;

  // --- Home banners ---
  static const bannerStore = 6116878; // Man in suit at store
  static const bannerMens = 614810; // Man in polo
  static const bannerFormal = 1043473; // Man formal suit
  static const bannerSale = 996329; // Clothing store interior
  static const bannerStreet = 7270145; // Man casual polo outdoors

  // --- Shop by department (lifestyle tiles — like ODEL / department stores) ---
  static const deptMen = 1043473; // Man in blue shirt & black formal suit
  static const deptWomen = 1462637; // Woman in blue striped dress, studio
  static const deptKids = 8613086; // Children in classroom (kids wear)
  /// Pexels id for **seeded dev products** in the accessories category; the live department tile uses
  /// [kNextLuxuryAccessoriesHeroImageUrl] via [accessoriesDepartmentImage].
  static const deptAccessories = 4975645;
  static const deptFormal = 1043473;
  static const deptCasual = 614810;

  // --- Women (verified on pexels.com) ---
  static const womanDress1 = 1462637; // Woman in striped dress
  static const womanCasual2 = 985635; // Woman in black tank top
  static const womanFormal3 = 1040945; // Woman in white dress
  static const womanSport4 = 1183266; // Woman standing by wall
  static const womanCoat5 = 1926769; // Woman in coat (editorial)

  // --- Kids & family ---
  static const kidsGroup1 = 8613086; // Children learning
  static const kidsPlay2 = 8612999; // Kids activity (classroom)

  // --- Accessories & lifestyle ---
  static const watchClose = 1232459; // Man with watch + polo
  static const handbag1 = 1152077; // Fashion accessories flat
  static const jewelrySet = 1454227; // Gold necklace
  static const storeInterior = 996329; // Fashion store (toys/home vibe)

  // --- Sport & swim ---
  static const sportRun = 936094; // Man in athletic shorts, track (verified pexels.com)
  /// Turquoise ocean / shore — verified (replaces 1261429, which was a castle photo).
  static const swimBeach = 4321802;
  /// Woman in sun hat on beach (pexels.com — matches beach / hat accessories).
  static const beachSunHat = 8760640;
  /// Reserved for future use; 4077508 is a video id on Pexels, not a still photo.
  static const fitnessMan = 936094;
}

/// Same editorial topic as the **Accessories** department tile
/// ([The Modern Man's Guide to Must-Have Fashion Accessories](https://nextluxury.com/mens-style-and-fashion/top-15-fashion-accessories-for-men/)).
///
/// This value is an **HTML page**, not an image file. Do **not** pass it to [CachedNetworkImage] or
/// [Image.network] as `imageUrl`. The in-app hero is [kAccessoriesDepartmentHeroAssetPath] (vendored from [kNextLuxuryAccessoriesHeroImageUrl]).
const kNextLuxuryMensAccessoriesArticleUrl =
    'https://nextluxury.com/mens-style-and-fashion/top-15-fashion-accessories-for-men/';

/// Original source URL (for updates / attribution). The app loads a **bundled copy** at
/// [kAccessoriesDepartmentHeroAssetPath] so Flutter Web is not blocked by CDN CORS.
const kNextLuxuryAccessoriesHeroImageUrl =
    'https://nextluxury.com/wp-content/uploads/Top-15-Fashion-Accessories-For-Men-1.jpg';

/// Vendored flat lay (men's boots, hat, bag, watch, bow tie, etc.) — copied from [kNextLuxuryAccessoriesHeroImageUrl].
const kAccessoriesDepartmentHeroAssetPath =
    'assets/images/accessories_nextluxury_flatlay.jpg';

/// Direct image URL for every **Accessories** tile (search, home, department landing).
///
/// [w] and [h] are ignored; parameters are kept so call sites stay stable.
String accessoriesDepartmentImage({int w = 960, int h = 1200}) => kAccessoriesDepartmentHeroAssetPath;

String productImg(int photoId) => pexelsImg(photoId);

String bannerImg(int photoId) => pexelsImg(photoId, w: 1200, h: 640);

String promoImg(int photoId) => pexelsImg(photoId, w: 400, h: 520);

String categoryImg(int photoId) => pexelsImg(photoId, w: 600, h: 720);

/// Local placeholder when a product image URL fails. Prefer passing [categoryId]
/// from the product so women’s NOLIMIT SKUs are not misclassified as men’s.
String fallbackForProduct(String productId, [String? categoryId]) {
  if (categoryId != null && categoryId.isNotEmpty) {
    switch (categoryId) {
      case 'women':
        return 'assets/images/wish_silk_slip_dress.png';
      case 'men':
        return 'assets/images/search_edit_quiet.png';
      case 'children':
        return 'assets/images/search_edit_quiet.png';
      case 'accessories':
        return 'assets/images/pl_gold_jewelry.png';
    }
  }

  if (productId.contains('kids') || productId.contains('boys') || productId.contains('girls')) {
    return 'assets/images/search_edit_quiet.png';
  }
  if (productId.contains('women') ||
      productId.contains('dress') ||
      productId.contains('blouse') ||
      productId.contains('saree') ||
      productId.contains('pyjama') ||
      productId.contains('night') ||
      productId.contains('leggings') ||
      productId.contains('frock') ||
      productId.contains('lingerie') ||
      productId.contains('ethnic') ||
      (productId.contains('swim') && productId.contains('one-piece'))) {
    return 'assets/images/wish_silk_slip_dress.png';
  }
  if (productId.contains('jewelry') ||
      productId.contains('chain') ||
      productId.contains('earring') ||
      productId.contains('watch')) {
    return 'assets/images/pl_gold_jewelry.png';
  }
  if (productId.contains('bag') ||
      productId.contains('tote') ||
      productId.contains('backpack') ||
      productId.contains('clutch') ||
      productId.contains('crossbody')) {
    return 'assets/images/search_recent_tote.png';
  }
  // Do not treat every `nolimit-*` id as men’s — many SKUs are women’s or kids’.
  if (productId.startsWith('ekko-') ||
      productId.startsWith('tfo-') ||
      productId.startsWith('kin-street') ||
      productId.contains('polo') ||
      productId.contains('chino') ||
      productId.contains('blazer') ||
      productId.contains('formal-trouser') ||
      productId.contains('formal-shirt')) {
    return 'assets/images/search_edit_quiet.png';
  }
  return 'assets/images/search_edit_quiet.png';
}

/// Fallback when a department network image fails.
String fallbackForDepartment(String title) {
  switch (title.toUpperCase()) {
    case 'MEN':
      return 'assets/images/search_edit_quiet.png';
    case 'WOMEN':
      return 'assets/images/wish_silk_slip_dress.png';
    case 'KIDS':
    case 'CHILDREN':
      return 'assets/images/search_edit_quiet.png';
    case 'ACCESSORIES':
      // Neutral fallback — not pl_gold (reads as women's jewelry) for top-level Accessories tiles.
      return 'assets/images/search_edit_quiet.png';
    case 'FORMAL':
      return 'assets/images/search_edit_classic.png';
    case 'CASUAL':
      return 'assets/images/search_edit_quiet.png';
    default:
      return 'assets/images/home_hero.png';
  }
}
