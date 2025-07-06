import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:apsl_sun_calc/apsl_sun_calc.dart';
import 'dart:ui';

// Data model for sun position
class SunPosition {
  final double azimuth; // angle in degrees (0-360)
  final double altitude; // angle above horizon (-90 to 90)
  final DateTime time;

  SunPosition({
    required this.azimuth,
    required this.altitude,
    required this.time,
  });
}

class SunPathPainter extends CustomPainter {
  final List<SunPosition> sunPathPoints;
  final SunPosition currentSunPosition;

  SunPathPainter({
    required this.sunPathPoints,
    required this.currentSunPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dashedPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final Paint sunDotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final Paint baselinePaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 1;

    // Define horizontal baseline
    final baselineY = size.height * 0.9;
    canvas.drawLine(
      Offset(0, baselineY),
      Offset(size.width, baselineY),
      baselinePaint,
    );

    if (sunPathPoints.length < 2) return;

    // Scale sun path to a nice arc shape
    final path = Path();
    final stepX = size.width / (sunPathPoints.length - 1);

    for (int i = 0; i < sunPathPoints.length; i++) {
      final x = stepX * i;
      final y = baselineY - (sunPathPoints[i].altitude * 2); // altitude scale

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw dashed sun path
    _drawDashedPath(canvas, path, dashedPaint, dashWidth: 4, gapWidth: 4);

    // Draw current sun dot
    final closest = _findClosestPoint(currentSunPosition.time);
    final cx = stepX * closest.index;
    final cy = baselineY - (closest.position.altitude * 2);
    canvas.drawCircle(Offset(cx, cy), 5, sunDotPaint);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashWidth,
    required double gapWidth,
  }) {
    final PathMetrics pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + dashWidth, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + gapWidth;
      }
    }
  }

  // Find closest sun path point to now
  _ClosestPoint _findClosestPoint(DateTime now) {
    int index = 0;
    Duration minDiff = Duration(days: 1);
    for (int i = 0; i < sunPathPoints.length; i++) {
      final diff = sunPathPoints[i].time.difference(now).abs();
      if (diff < minDiff) {
        minDiff = diff;
        index = i;
      }
    }
    return _ClosestPoint(index, sunPathPoints[index]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ClosestPoint {
  final int index;
  final SunPosition position;

  _ClosestPoint(this.index, this.position);
}
