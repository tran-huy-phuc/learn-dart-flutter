import 'package:flutter/material.dart';
import 'package:yuka_demo/constants.dart';

class DietaryHorizontalList extends StatelessWidget {
  const DietaryHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dietaryOptions.map((e) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DietaryButton(text: e));
        }).toList(),
      ),
    );
  }
}

class DietaryButton extends StatelessWidget {
  final String text;

  const DietaryButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge,
        ));
  }
}
