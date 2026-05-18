import 'package:flutter/material.dart';
import '../../domain/entities/mood_entry.dart';
import '../painters/mood_face_painter.dart';

class AnimatedMoodFace extends StatefulWidget {
  final MoodType moodType;
  final Color color;
  final double size;
  final bool isAnimating;
  final VoidCallback? onAnimationComplete;

  const AnimatedMoodFace({
    super.key,
    required this.moodType,
    required this.color,
    this.size = 100,
    this.isAnimating = false,
    this.onAnimationComplete,
  });

  @override
  State<AnimatedMoodFace> createState() => _AnimatedMoodFaceState();
}

class _AnimatedMoodFaceState extends State<AnimatedMoodFace> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        widget.onAnimationComplete?.call();
      }
    });

    if (widget.isAnimating) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedMoodFace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: MoodFacePainter(
            moodType: widget.moodType,
            color: widget.color,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }
}

