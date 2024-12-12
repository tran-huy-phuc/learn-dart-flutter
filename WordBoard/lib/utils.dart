import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wordboard/constants.dart';

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

String getRandomLetter() {
  final Random random = Random();
  return alphabet[random.nextInt(alphabet.length)];
}

void onWidgetBuildDone(Function function) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    function();
  });
}