import 'package:flutter/cupertino.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

void showConfettiEffect(BuildContext context) {
  Confetti.launch(
    context,
    options: const ConfettiOptions(
        particleCount: 300, spread: 70, y: 0.6),
  );
}
