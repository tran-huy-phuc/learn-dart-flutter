import 'package:flutter/material.dart';
import 'package:yuka_demo/constants.dart';
import 'package:yuka_demo/lift_animated_builder.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return LiftAnimatedBuilder(
        animationDuration: (liftAnimationDuration * 1.3).toInt(),
        child: FilledButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Continue',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
            )));
  }
}
