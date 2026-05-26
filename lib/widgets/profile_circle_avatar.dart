import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Circular profile image with network loading/error fallback and neutral placeholder.
class ProfileCircleAvatar extends StatelessWidget {
  const ProfileCircleAvatar({super.key, required this.url, required this.size, this.fit = BoxFit.cover});

  final String? url;
  final double size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final raw = url?.trim();
    if (raw != null && raw.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: raw,
          width: size,
          height: size,
          fit: fit,
          placeholder: (context, url) => _Loading(size),
          errorWidget: (context, url, error) => _Placeholder(size),
        ),
      );
    }
    return _Placeholder(size);
  }
}

class _Loading extends StatelessWidget {
  const _Loading(this.size);
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const ColoredBox(
        color: Color(0xFF1A1816),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFB8963E)),
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.size);
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: const Color(0xFF1A1816),
      alignment: Alignment.center,
      child: Icon(Icons.person_rounded, size: size * 0.48, color: const Color(0xFF8A8278)),
    );
  }
}
