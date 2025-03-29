import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class NetworkImageWithPlaceholder extends StatelessWidget {
  final String imageUrl;
  final Widget placeholder;
  final Widget errorWidget;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const NetworkImageWithPlaceholder({
    super.key,
    required this.imageUrl,
    this.placeholder = const _DefaultPlaceholder(),
    this.errorWidget = const _DefaultErrorWidget(),
    this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => errorWidget,
    );
  }
}

// Default placeholder widget (can be customized)
class _DefaultPlaceholder extends StatelessWidget {
  const _DefaultPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorExt.border,
      child: Center(
        child: Icon(Icons.image, color: context.colorExt.textPrimary),
      ),
    );
  }
}

// Default error widget (can be customized)
class _DefaultErrorWidget extends StatelessWidget {
  const _DefaultErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorExt.border,
      child: Center(
        child: Icon(Icons.broken_image, color: context.colorExt.textPrimary),
      ),
    );
  }
}
