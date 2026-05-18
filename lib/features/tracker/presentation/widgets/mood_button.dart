
import 'package:flutter/material.dart';
import 'package:mood_tracker/features/tracker/domain/entities/mood_entry.dart';
import 'package:mood_tracker/features/tracker/presentation/painters/mood_face_painter.dart';

class MoodButton extends StatefulWidget {
  final MoodType moodType;
  final VoidCallback onPressed;
  final bool isSelected;

  const MoodButton({
    super.key,
    required this.moodType,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  State<MoodButton> createState() => _MoodButtonState();
}

class _MoodButtonState extends State<MoodButton> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.moodType.accentColor;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? color.withValues(alpha: 0.1)
                    : (_isHovered ? color.withValues(alpha: 0.05) : Colors.transparent),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: (widget.isSelected || _isHovered) ? color : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  if (_isHovered || widget.isSelected)
                    BoxShadow(
                      color: color.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomPaint(
                    size: const Size(80, 80),
                    painter: MoodFacePainter(
                      moodType: widget.moodType,
                      color: color,
                      animationValue: _animation.value,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.moodType.displayName,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

