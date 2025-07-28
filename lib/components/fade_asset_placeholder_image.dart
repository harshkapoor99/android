import 'dart:io'; // Required for File class

import 'package:flutter/material.dart';
// Removed: import 'package:cached_network_image/cached_network_image.dart';
// Removed: import 'package:guftagu_mobile/utils/context_less_nav.dart';

/// A widget that displays an image from a local file path.
///
/// It provides customizable placeholder and error widgets, similar to
/// CachedNetworkImage, but for local files.
class AssetImageWithPlaceholder extends StatelessWidget {
  /// The local file path of the image to display.
  /// If null or empty, the [placeholder] widget will be shown.
  final String? imagePath;

  /// The widget to display while the image is loading or if [imagePath] is null/empty.
  /// Defaults to a gray container with an image icon.
  final Widget placeholder;

  /// The widget to display if there's an error loading the image from the file path.
  /// Defaults to a gray container with a broken image icon.
  final Widget errorWidget;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit? fit;

  /// The width of the widget.
  final double? width;

  /// The height of the widget.
  final double? height;

  const AssetImageWithPlaceholder({
    super.key,
    required this.imagePath, // Changed from imageUrl to imagePath
    this.placeholder = const _DefaultPlaceholder(),
    this.errorWidget = const _DefaultErrorWidget(),
    this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // If the imagePath is null or empty, display the placeholder widget.
    if (imagePath == null || imagePath!.isEmpty) {
      return SizedBox(width: width, height: height, child: placeholder);
    }

    // Otherwise, attempt to load the image from the file path.
    return Image.file(
      File(imagePath!), // Use File(path) to load from local storage
      width: width,
      height: height,
      fit: fit,
      // The errorBuilder is called if the image fails to load (e.g., file not found).
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(width: width, height: height, child: errorWidget);
      },
    );
  }
}

/// Default placeholder widget displayed when the image path is null/empty.
class _DefaultPlaceholder extends StatelessWidget {
  const _DefaultPlaceholder();

  @override
  Widget build(BuildContext context) {
    // Using Theme.of(context).colorScheme for standard color access,
    // as context.colorExt was a custom extension.
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Icon(
          Icons.image,
          color:
              Theme.of(
                context,
              ).colorScheme.onSurface, // Icon color for contrast
        ),
      ),
    );
  }
}

/// Default error widget displayed when the image fails to load from the file path.
class _DefaultErrorWidget extends StatelessWidget {
  const _DefaultErrorWidget();

  @override
  Widget build(BuildContext context) {
    // Using Theme.of(context).colorScheme for standard color access.
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Icon(
          Icons.broken_image,
          color:
              Theme.of(
                context,
              ).colorScheme.onSurface, // Icon color for contrast
        ),
      ),
    );
  }
}
