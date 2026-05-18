import 'package:flutter/material.dart';

class MoodLoader extends StatefulWidget {
  final double size;
  final Color? color;

  const MoodLoader({
    super.key,
    this.size = 120,
    this.color,
  });

  @override
  State<MoodLoader> createState() => _MoodLoaderState();
}

class _MoodLoaderState extends State<MoodLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.color ?? Theme.of(context).primaryColor;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Progress Indicator
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(themeColor.withValues(alpha: 0.3)),
            ),
          ),
          // Rotating Outer Ring (Optional but looks premium)
          RotationTransition(
            turns: _controller,
            child: SizedBox(
              width: widget.size + 10,
              height: widget.size + 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
            ),
          ),
          // Pulsing Logo
          ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                width: widget.size * 0.6,
                height: widget.size * 0.6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

