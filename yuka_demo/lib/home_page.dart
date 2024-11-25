import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:yuka_demo/constants.dart';
import 'package:yuka_demo/dietary_horizontal_list.dart';
import 'package:yuka_demo/header.dart';
import 'package:yuka_demo/next_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _scale = 0;

  @override
  void initState() {
    super.initState();

    // Wait for 1s then scale the list
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
          const Duration(milliseconds: scaleAnimationDuration));
      setState(() {
        _scale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Header(),
            AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: scaleAnimationDuration),
                child: const DietaryHorizontalList()),
            const NextButton()
          ],
        ),
      ),
    );
  }
}
