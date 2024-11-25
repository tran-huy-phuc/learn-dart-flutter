import 'package:flutter/material.dart';
import 'package:yuka_demo/constants.dart';

import 'lift_animation_type.dart';

class LiftAnimatedBuilder extends StatefulWidget {
  final Widget child;
  final LiftAnimationDirection liftType;
  final double liftOffset;
  final int animationDuration;

  const LiftAnimatedBuilder(
      {super.key,
      required this.child,
      this.liftType = LiftAnimationDirection.up,
      this.liftOffset = liftAnimationOffset,
      this.animationDuration = liftAnimationDuration});

  @override
  State<LiftAnimatedBuilder> createState() => _LiftAnimatedBuilderState();
}

class _LiftAnimatedBuilderState extends State<LiftAnimatedBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.animationDuration));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (_, __) {
          final double offsetY = (widget.liftType == LiftAnimationDirection.up)
              ? (1 - _animation.value) * widget.liftOffset
              : (_animation.value - 1) * widget.liftOffset;
          return Transform.translate(
            offset: Offset(
              0,
              offsetY,
            ),
            child: Opacity(
              opacity: _animation.value,
              child: widget.child,
            ),
          );
        });
  }
}
