// ignore_for_file: avoid_print
//
// Downloads NOLIMIT greencloudpos product images into `assets/images/men_accessories/`
// so [MenAccessoriesCatalogImageUrls] paths always resolve after a fresh clone.
//
// Usage (from project root — folder that contains `pubspec.yaml`):
//   dart run tool/download_men_accessory_assets.dart

import 'dart:io';
import 'dart:typed_data';

const _userAgent =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36';

/// CDN URLs (same files as `nolimit.lk/_next/image?url=…`) → paths under [MenAccessoriesCatalogImageUrls.list].
const _items = <({String url, String relativePath})>[
  (
    url:
        'https://cdn.greencloudpos.com/nolimit.lk/product/FOSSILGRANTCHRONOGRAPHBLACKDIALBLACKLEATHERSTRAPWATCHFORMEN-2-1775282118210-3.jpg?width=600',
    relativePath: 'assets/images/men_accessories/fossil_grant_chrono.jpg',
  ),
  (
    url:
        'https://cdn.greencloudpos.com/nolimit.lk/product/FOSSILEVERETTCHRONOGRAPHSTAINLESSSTEELWATCHFORMEN-1-1775023469976-2.jpg?width=600',
    relativePath: 'assets/images/men_accessories/fossil_everett_chrono_steel.jpg',
  ),
  (
    url:
        'https://cdn.greencloudpos.com/nolimit.lk/product/DEEDATHyperSlipperBlack-4-1770878969194-Photo1156X146626.jpg?width=600',
    relativePath: 'assets/images/men_accessories/deedat_hyper_slipper_black.jpg',
  ),
  (
    url:
        'https://cdn.greencloudpos.com/nolimit.lk/product/MBRKMen%27sInvisibleLengthSocksBlack-0-1755508176625-2_0000_0Y7A5098.png?width=600',
    relativePath: 'assets/images/men_accessories/mbrk_socks_black.png',
  ),
  (
    url:
        'https://cdn.greencloudpos.com/nolimit.lk/product/NOLIMITMen%27sReversibleSyntheticFormalBeltBlack-0-1755509788430-0Y7A1031_0003_0Y7A5138.png?width=600',
    relativePath: 'assets/images/men_accessories/nolimit_belt_black.png',
  ),
  (
    url:
        'https://cdn.greencloudpos.com/nolimit.lk/product/DEEDATMen%27sSportsShoeWhite%E2%80%A240-1-1750858996030-Photo1536X204932.jpg?width=600',
    relativePath: 'assets/images/men_accessories/deedat_sports_shoe_white.jpg',
  ),
];

Future<void> main() async {
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln('Error: run from project root (directory containing pubspec.yaml).');
    exitCode = 64;
    return;
  }

  final client = HttpClient();
  var ok = 0;
  try {
    for (final item in _items) {
      final out = File(item.relativePath);
      await out.parent.create(recursive: true);
      final uri = Uri.parse(item.url);
      final req = await client.getUrl(uri);
      req.headers.set(HttpHeaders.userAgentHeader, _userAgent);
      req.headers.set(HttpHeaders.refererHeader, 'https://www.nolimit.lk/');
      req.headers.set('origin', 'https://www.nolimit.lk');
      req.headers.set(HttpHeaders.acceptHeader, 'image/avif,image/webp,image/apng,image/*,*/*;q=0.8');
      final res = await req.close();
      if (res.statusCode != HttpStatus.ok) {
        stderr.writeln('FAIL ${res.statusCode} ${item.relativePath}');
        continue;
      }
      final builder = BytesBuilder(copy: false);
      await for (final chunk in res) {
        builder.add(chunk);
      }
      final bytes = builder.takeBytes();
      if (bytes.length < 512) {
        stderr.writeln('FAIL too small (${bytes.length} B) ${item.relativePath}');
        continue;
      }
      await out.writeAsBytes(bytes, flush: true);
      print('OK ${item.relativePath} (${bytes.length} B)');
      ok++;
    }
  } finally {
    client.close(force: true);
  }

  if (ok != _items.length) {
    stderr.writeln('Downloaded $ok / ${_items.length}. Fix network or URLs and retry.');
    exitCode = 1;
  } else {
    print('Done. All ${_items.length} images saved. Rebuild the app (flutter run).');
  }
}
