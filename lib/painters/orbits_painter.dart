
import 'package:flutter/material.dart';
import 'package:planet_system/models/planet.dart';

class OrbitsPainter extends CustomPainter {
  final List<Planet> planets;

  OrbitsPainter(this.planets);

  final Paint customPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    for (Planet planet in planets) {
      path.addOval(Rect.fromCircle(center: const Offset(0, 0), radius: planet.distanceFromSun));
    }

    canvas.drawPath(path, customPaint);
  }

  @override
  bool shouldRepaint(CustomPainter customPainter) {
    return true;
  }
}