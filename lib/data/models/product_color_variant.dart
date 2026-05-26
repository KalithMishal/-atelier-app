class ProductColorVariant {
  const ProductColorVariant({
    required this.name,
    required this.hex,
    required this.imageUrls,
  });

  final String name;
  final String hex;
  final List<String> imageUrls;
}
