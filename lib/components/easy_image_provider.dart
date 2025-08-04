import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class ProgressWidgetProvider extends EasyImageProvider {
  @override
  final int initialIndex = 0;
  final ImageProvider<Object> provider;

  ProgressWidgetProvider(this.provider) : super();

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    return provider;
  }

  @override
  Widget progressIndicatorWidgetBuilder(
    BuildContext context,
    int index, {
    double? value,
  }) {
    // Create a custom linear progress indicator
    // with a label showing the progress value
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(value: value),
        Text(
          "${(value ?? 0) * 100}%",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  @override
  int get imageCount => 1;
}
