import 'package:flutter/material.dart';
import 'package:yuka_demo/lift_animated_builder.dart';
import 'package:yuka_demo/lift_animation_type.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return LiftAnimatedBuilder(
      liftType: LiftAnimationDirection.down,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Filter recipes by diet and preference!',
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
