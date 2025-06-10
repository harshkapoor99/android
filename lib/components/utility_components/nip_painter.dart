import 'package:flutter/material.dart';

class BubbleNipPainter extends CustomPainter {
  final Color? color;
  final bool isMe;

  BubbleNipPainter({required this.color, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color ?? Colors.purple
          ..style = PaintingStyle.fill;

    final path = Path();
    if (isMe) {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
