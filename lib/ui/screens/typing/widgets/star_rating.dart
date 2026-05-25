import 'package:flutter/material.dart';

/// Animated star rating widget.
/// Shows [maxStars] stars, with [earnedStars] filled (amber) and the rest outlined.
/// Each earned star animates with a bounce scale effect.
class StarRating extends StatefulWidget {
  final int maxStars;
  final int earnedStars;

  const StarRating({
    super.key,
    this.maxStars = 3,
    this.earnedStars = 0,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _controllers = List.generate(widget.maxStars, (i) {
      return AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
    });
    _animations = _controllers.map((c) {
      return TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 40),
        TweenSequenceItem(tween: Tween(begin: 1.4, end: 0.9), weight: 30),
        TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
      ]).animate(CurvedAnimation(parent: c, curve: Curves.easeOut));
    }).toList();
  }

  @override
  void didUpdateWidget(StarRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.earnedStars != widget.earnedStars && widget.earnedStars > 0) {
      // Animate newly earned stars with stagger
      for (int i = 0; i < widget.earnedStars && i < _controllers.length; i++) {
        Future.delayed(Duration(milliseconds: i * 100), () {
          if (mounted) _controllers[i].forward(from: 0);
        });
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxStars, (index) {
        final earned = index < widget.earnedStars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Transform.scale(
                scale: earned ? _animations[index].value : 1.0,
                child: child,
              );
            },
            child: Icon(
              earned ? Icons.star_rounded : Icons.star_outline_rounded,
              color: earned ? const Color(0xFFFFC107) : Colors.grey.shade300,
              size: 32,
            ),
          ),
        );
      }),
    );
  }
}
