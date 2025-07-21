import 'package:flutter/material.dart';

class AnimatedReveal extends StatefulWidget {
  final Widget child; // Now accepts any Widget
  final Duration delay;
  final Duration animationDuration;

  const AnimatedReveal({
    super.key,
    required this.child, // 'child' is now required
    this.delay = const Duration(milliseconds: 0),
    this.animationDuration = const Duration(seconds: 1),
  });

  @override
  State<AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startRevealAnimation();
  }

  void _startRevealAnimation() async {
    await Future.delayed(widget.delay);
    if (mounted) {
      setState(() {
        _opacity = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: widget.animationDuration,
      curve: Curves.easeIn,
      child: widget.child, // The generic child widget is rendered here
    );
  }
}
