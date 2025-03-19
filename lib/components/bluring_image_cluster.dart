import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BluringImageCluster extends StatefulWidget {
  const BluringImageCluster({super.key, required this.focusNodes});

  final List<FocusNode> focusNodes;

  @override
  State<BluringImageCluster> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BluringImageCluster> {
  double _blurValue = 0.0;

  @override
  void initState() {
    super.initState();
    for (var focusNode in widget.focusNodes) {
      focusNode.addListener(_updateBlur);
    }
  }

  void _updateBlur() {
    setState(() {
      _blurValue = widget.focusNodes.any((node) => node.hasFocus) ? 6.r : 0.0;
    });
  }

  @override
  void dispose() {
    for (var focusNode in widget.focusNodes) {
      focusNode.removeListener(_updateBlur);
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: _blurValue),
      duration: Duration(milliseconds: 300), // Adjust animation duration
      builder: (context, blur, child) {
        return ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: child,
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 10.h,
        ),
        child: Image.asset(
          "assets/images/bg_img.png",
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
