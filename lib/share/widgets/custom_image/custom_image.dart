import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ImageType { png, svg }

class CustomImage extends StatelessWidget {
  final String imageSrc;
  final Color? imageColor;
  final double? height;
  final double? width;
  final double? scale;
  final double? sizeWidth;
  final ImageType imageType;
  final BoxFit fit;
  final double horizontal;
  final double vertical;

  const CustomImage({
    super.key,
    required this.imageSrc,
    this.imageColor,
    this.height,
    this.width,
    this.scale,
    this.sizeWidth,
    this.imageType = ImageType.png,
    this.fit = BoxFit.cover,
    this.horizontal = 0.0,
    this.vertical = 0.0,
  });

  bool get isSvg =>
      imageType == ImageType.svg || imageSrc.toLowerCase().endsWith(".svg");

  bool get isPng =>
      imageType == ImageType.png || imageSrc.toLowerCase().endsWith(".png");

  @override
  Widget build(BuildContext context) {
    if (imageSrc.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget child;

    if (isSvg) {
      child = SvgPicture.asset(
        imageSrc,
        colorFilter: imageColor != null
            ? ColorFilter.mode(imageColor!, BlendMode.srcIn)
            : null,
        height: height,
        width: width,
        fit: fit,
      );
    } else if (isPng) {
      child = Image.asset(
        imageSrc,
        color: imageColor,
        height: height,
        width: width,
        fit: fit,
        scale: scale ?? 1,
        errorBuilder: (_, _, _) {
          return const Icon(Icons.broken_image);
        },
      );
    } else {
      child = const Icon(Icons.image_not_supported);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      width: sizeWidth,
      child: child,
    );
  }
}
