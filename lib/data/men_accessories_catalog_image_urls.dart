/// **Men → Accessories** — product tile images.
///
/// Runtime uses **bundled** files so grids work on Flutter Web (NOLIMIT CDN URLs often fail in the
/// browser). The originals are these NOLIMIT `_next/image` links (same order as [list]):
/// 1. `https://www.nolimit.lk/_next/image?url=https%3A%2F%2Fcdn.greencloudpos.com%2Fnolimit.lk%2Fproduct%2FFOSSILGRANTCHRONOGRAPHBLACKDIALBLACKLEATHERSTRAPWATCHFORMEN-2-1775282118210-3.jpg%3Fwidth%3D600&w=1080&q=75`
/// 2. `https://www.nolimit.lk/_next/image?url=https%3A%2F%2Fcdn.greencloudpos.com%2Fnolimit.lk%2Fproduct%2FFOSSILEVERETTCHRONOGRAPHSTAINLESSSTEELWATCHFORMEN-1-1775023469976-2.jpg%3Fwidth%3D600&w=1080&q=75`
/// 3. `https://www.nolimit.lk/_next/image?url=https%3A%2F%2Fcdn.greencloudpos.com%2Fnolimit.lk%2Fproduct%2FDEEDATHyperSlipperBlack-4-1770878969194-Photo1156X146626.jpg%3Fwidth%3D600&w=1080&q=75`
/// 4. `https://www.nolimit.lk/_next/image?url=https%3A%2F%2Fcdn.greencloudpos.com%2Fnolimit.lk%2Fproduct%2FMBRKMen%27sInvisibleLengthSocksBlack-0-1755508176625-2_0000_0Y7A5098.png%3Fwidth%3D600&w=1080&q=75`
/// 5. `https://www.nolimit.lk/_next/image?url=https%3A%2F%2Fcdn.greencloudpos.com%2Fnolimit.lk%2Fproduct%2FNOLIMITMen%27sReversibleSyntheticFormalBeltBlack-0-1755509788430-0Y7A1031_0003_0Y7A5138.png%3Fwidth%3D600&w=1080&q=75`
/// 6. `https://www.nolimit.lk/_next/image?url=https%3A%2F%2Fcdn.greencloudpos.com%2Fnolimit.lk%2Fproduct%2FDEEDATMen%27sSportsShoeWhite%25E2%2580%25A240-1-1750858996030-Photo1536X204932.jpg%3Fwidth%3D600&w=1080&q=75`
///
/// Refresh files: `dart run tool/download_men_accessory_assets.dart`
abstract final class MenAccessoriesCatalogImageUrls {
  /// Order: Grant watch, Everett chrono steel, DEEDAT slipper black, MBRK socks, belt, DEEDAT shoe.
  static const list = <String>[
    'assets/images/men_accessories/fossil_grant_chrono.jpg',
    'assets/images/men_accessories/fossil_everett_chrono_steel.jpg',
    'assets/images/men_accessories/deedat_hyper_slipper_black.jpg',
    'assets/images/men_accessories/mbrk_socks_black.png',
    'assets/images/men_accessories/nolimit_belt_black.png',
    'assets/images/men_accessories/deedat_sports_shoe_white.jpg',
  ];
}
