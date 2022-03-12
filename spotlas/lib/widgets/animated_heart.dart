//---
// Copyright (c) 2022 Jonathan Bradley Whited.
//---

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotlas/consts.dart' as consts;

/// Animated heart at center when double tap image.
///
/// Scales heart from small to big & back to small.
class AnimatedHeart extends StatefulWidget {
  final bool doAnimate;
  final void Function() onEnd;

  const AnimatedHeart({
    Key? key,
    required this.doAnimate,
    required this.onEnd,
  }) : super(key: key);

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0.50, end: 1.50).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedHeart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.doAnimate) animate();
  }

  Future<void> animate() async {
    // Animating or completed animation?
    if (animationController.status != AnimationStatus.dismissed) {
      return;
    }

    await animationController.forward();
    await animationController.reverse();
    widget.onEnd();
  }

  @override
  Widget build(BuildContext context) {
    // Must have Container for Expanded/Flex (not Spacer).
    if (!widget.doAnimate) return Container();

    return ScaleTransition(
      scale: animation,
      child: SvgPicture.asset(
        'assets/images/Heart.svg',
        color: consts.heartColor,
      ),
    );
  }
}
