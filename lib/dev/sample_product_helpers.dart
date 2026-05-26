import '../data/fashion_image_urls.dart';

/// Builds one Firestore seed document for the sample catalogue.
Map<String, dynamic> sampleProduct({
  required String id,
  required String name,
  required String brand,
  required String categoryId,
  required String subCategoryId,
  required int price,
  required int photoId,
  String currency = 'LKR',
  bool isFeatured = false,
  String? retailerUrl,
  String? description,
  String? assetImage,
  /// Full image URL (https…) for this SKU — overrides [assetImage] and [photoId] when set.
  String? catalogImageUrl,
}) {
  final image = (catalogImageUrl != null && catalogImageUrl.trim().isNotEmpty)
      ? catalogImageUrl.trim()
      : (assetImage ?? productImg(photoId));
  return {
    'id': id,
    'name': name,
    'brand': brand,
    'categoryId': categoryId,
    'subCategoryId': subCategoryId,
    'price': price,
    'currency': currency,
    if (retailerUrl != null && retailerUrl.trim().isNotEmpty) 'retailerUrl': retailerUrl.trim(),
    'description': description ?? '$name from $brand — available at ATELIER.',
    'isFeatured': isFeatured,
    'imageUrls': [image],
    'colors': [
      {
        'name': 'Default',
        'hex': '#333333',
        'imageUrls': [image],
      },
    ],
  };
}

const kNolimit = 'https://www.nolimit.lk/';
const kOdel = 'https://www.odel.lk/';
const kCotton = 'https://cottoncollection.lk/';
const kSignature = 'https://www.signature.lk/';
const kFashionBug = 'https://fashionbug.lk/';
const kShoesLk = 'https://shoes.lk/';
const kDecathlon = 'https://www.decathlon.com/';
const kNextUk = 'https://www.next.co.uk/';
