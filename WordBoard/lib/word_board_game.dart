import 'package:flutter/material.dart';
import 'package:wordboard/word_board.dart';

class WordBoardGame extends StatelessWidget {
  const WordBoardGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WordBoard()
        ],
      )
    );
  }
}
