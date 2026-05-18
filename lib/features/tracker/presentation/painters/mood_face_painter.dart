import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mood_tracker/features/tracker/domain/entities/mood_entry.dart';

class MoodFacePainter extends CustomPainter {
  final MoodType moodType;
  final double animationValue; // 0.0 - 1.0
  final Color color;

  MoodFacePainter({
    super.repaint,
    required this.moodType,
    this.animationValue = 0.0,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    // Draw background circle
    canvas.drawCircle(center, radius, paint);

    final strokePaint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = radius * 0.1
    ..strokeCap = StrokeCap.round;

    // Draw eyes
    final eyeOffset = radius * 0.40;
    final eyeRadius = radius * 0.15;

    // left eye
    canvas.drawCircle(
      Offset(center.dx - eyeOffset, center.dy - eyeOffset * 0.5),
        eyeRadius,
      strokePaint..style = PaintingStyle.fill,
    );

    // right eye
    canvas.drawCircle(
      Offset(center.dx + eyeOffset, center.dy - eyeOffset * 0.5),
      eyeRadius,
      strokePaint..style = PaintingStyle.fill,
    );

    // reset stroke paint for mouth and brows
    strokePaint.style = PaintingStyle.stroke;

    switch (moodType) {
      case MoodType.happy:
        _drawHappy(canvas, center, radius, strokePaint);
        break;
      case MoodType.neutral:
        _drawNeutral(canvas, center, radius, strokePaint);
        break;
      case MoodType.sad:
        _drawSad(canvas, center, radius, strokePaint);
        break;
    }
  }

  void _drawHappy(Canvas canvas, Offset center, double radius, Paint paint) {
    // smile expansion animation
    final expansion = animationValue * 10;
    final rect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * 0.1),
      width: radius * 1.2 + expansion,
      height: radius * 0.8
    );
    canvas.drawArc(rect, 0.2, pi - 0.4, false, paint);

    // Relaxed eyebrows
    final browOffset = radius * 0.4;
    final browWidth = radius * 0.3;

    // Left brow
    canvas.drawLine(
      Offset(center.dx - browOffset - browWidth/2, center.dy - browOffset - 5),
      Offset(center.dx - browOffset + browWidth/2, center.dy - browOffset - 5),
      paint
    );

    canvas.drawLine(
      Offset(center.dx + browOffset - browWidth/2, center.dy - browOffset - 5),
      Offset(center.dx + browOffset + browWidth/2, center.dy - browOffset - 5),
      paint,
    );
  }

  void _drawNeutral(Canvas canvas, Offset center, double radius, Paint paint) {
    // Straight line mouth
    final mouthWidth = radius * 0.8;
    //Blink animation
    final blinkOffset = animationValue * 5;

    canvas.drawLine(
        Offset(center.dx - mouthWidth/2, center.dy + radius * 0.3 + blinkOffset),
        Offset(center.dx + mouthWidth/2, center.dy + radius * 0.3 + blinkOffset),
        paint
    );

    // Relaxed eyebrows
    final browOffset = radius * 0.4;
    final browWidth = radius * 0.3;

    // Left brow
    canvas.drawLine(
        Offset(center.dx - browOffset - browWidth/2, center.dy - browOffset),
        Offset(center.dx - browOffset + browWidth/2, center.dy - browOffset),
        paint
    );
    // right brow
    canvas.drawLine(
      Offset(center.dx + browOffset - browWidth/2, center.dy - browOffset),
      Offset(center.dx + browOffset + browWidth/2, center.dy - browOffset),
      paint,
    );
  }

  void _drawSad(Canvas canvas, Offset center, double radius, Paint paint) {
    final downwardMovement = animationValue * 8;
    final rect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.6 + downwardMovement),
        width: radius * 1.0,
        height: radius * 0.8
    );
    canvas.drawArc(rect, pi + 0.4, pi - 0.8, false, paint);

    // Relaxed eyebrows
    final browOffset = radius * 0.4;
    final browWidth = radius * 0.3;

    // Left brow
    canvas.drawLine(
        Offset(center.dx - browOffset - browWidth/2, center.dy - browOffset + 5),
        Offset(center.dx - browOffset + browWidth/2, center.dy - browOffset - 5),
        paint
    );

    canvas.drawLine(
      Offset(center.dx + browOffset - browWidth/2, center.dy - browOffset - 5),
      Offset(center.dx + browOffset + browWidth/2, center.dy - browOffset + 5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant MoodFacePainter oldDelegate) {
    return oldDelegate.moodType != moodType ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color;
  }
}
