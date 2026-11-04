import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'color_typography.dart';

class ProductImageView extends StatelessWidget {
  final String? localImagePath;
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const ProductImageView({
    super.key,
    this.localImagePath,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: AppColors.slate100,
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined,
            size: 22, color: AppColors.slate400),
      );

  Widget _wrap(Widget child) => borderRadius == null
      ? child
      : ClipRRect(borderRadius: borderRadius!, child: child);

  @override
  Widget build(BuildContext context) {
    if (localImagePath != null &&
        localImagePath!.isNotEmpty &&
        File(localImagePath!).existsSync()) {
      return _wrap(Image.file(
        File(localImagePath!),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(),
      ));
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return _wrap(CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => Container(
          width: width,
          height: height,
          color: AppColors.slate100,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (_, __, ___) => _placeholder(),
      ));
    }

    return _wrap(_placeholder());
  }
}