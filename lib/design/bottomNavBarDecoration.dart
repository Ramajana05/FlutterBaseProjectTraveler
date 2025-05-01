import 'package:flutter/material.dart';

class GradientBorder extends CustomPainter {
  final double width;
  final Gradient gradient;

  GradientBorder({
    required this.gradient,
    this.width = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final gradientRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final Paint paint = Paint()
      ..shader = gradient
          .createShader(gradientRect) 
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
