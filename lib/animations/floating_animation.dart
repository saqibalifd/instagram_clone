import 'package:flutter/material.dart';

class FloatingAnimation extends StatefulWidget {
  final Widget child;
  final double height;
  final Duration duration;
  final Duration reverseDuration;
  final Offset beginOffset;
  final Offset endOffset;

  const FloatingAnimation({
    super.key,
    required this.child,
    this.height = 150,
    this.duration = const Duration(seconds: 3),
    this.reverseDuration = const Duration(milliseconds: 2300),
    this.beginOffset = const Offset(0, -0.1),
    this.endOffset = const Offset(0, 0.24),
  });

  @override
  State<FloatingAnimation> createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(
          vsync: this,
          duration: widget.duration,
          reverseDuration: widget.reverseDuration,
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _controller.forward();
          }
        });

    _animation = Tween<Offset>(
      begin: widget.beginOffset,
      end: widget.endOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: SlideTransition(position: _animation, child: widget.child),
    );
  }
}
