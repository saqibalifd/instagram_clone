import 'dart:math';
import 'package:flutter/material.dart';

/// A wrapper that adds an animated Instagram-style gradient border
/// around any child widget.
///
/// Usage:
/// ```dart
/// StoryBorderWrapper(
///   isActive: true,
///   child: CircleAvatar(
///     radius: 35,
///     backgroundImage: NetworkImage(url),
///   ),
/// )
/// ```
class StoryBorderWrapper extends StatefulWidget {
  /// The widget to wrap with the animated border.
  final Widget child;

  /// Whether to show the animated gradient border.
  /// Defaults to true.
  final bool isActive;

  /// Border stroke width. Defaults to 3.5.
  final double strokeWidth;

  /// Gap between the border and the child. Defaults to 3.0.
  final double gap;

  /// Duration of one full rotation. Defaults to 3 seconds.
  final Duration duration;

  /// Custom gradient colors. Defaults to Instagram palette.
  final List<Color>? colors;

  const StoryBorderWrapper({
    super.key,
    required this.child,
    this.isActive = true,
    this.strokeWidth = 3.5,
    this.gap = 3.0,
    this.duration = const Duration(seconds: 3),
    this.colors,
  });

  @override
  State<StoryBorderWrapper> createState() => _StoryBorderWrapperState();
}

class _StoryBorderWrapperState extends State<StoryBorderWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const _instagramColors = [
    Color(0xFFf09433),
    Color(0xFFe6683c),
    Color(0xFFdc2743),
    Color(0xFFcc2366),
    Color(0xFFbc1888),
    Color(0xFF833ab4),
    Color(0xFF5851db),
    Color(0xFF405de6),
    Color(0xFFf09433),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isActive) _controller.repeat();
  }

  @override
  void didUpdateWidget(StoryBorderWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
      if (widget.isActive) _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _StoryBorderPainter(
            progress: _controller.value,
            strokeWidth: widget.strokeWidth,
            colors: widget.colors ?? _instagramColors,
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.gap + widget.strokeWidth),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _StoryBorderPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> colors;

  _StoryBorderPainter({
    required this.progress,
    required this.strokeWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    final paint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        transform: GradientRotation(progress * 2 * pi),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_StoryBorderPainter old) =>
      old.progress != progress ||
      old.strokeWidth != strokeWidth ||
      old.colors != colors;
}
