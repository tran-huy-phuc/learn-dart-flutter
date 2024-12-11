import 'package:flutter/material.dart';
import 'package:wordboard/constants.dart';
import 'package:wordboard/utils.dart';

class WordBoard extends StatefulWidget {
  const WordBoard({Key? key}) : super(key: key);

  @override
  State<WordBoard> createState() => _WordBoardState();
}

class _WordBoardState extends State<WordBoard> {
  late List<String> letters;

  @override
  void initState() {
    super.initState();
    letters = List.filled(wordBoardRow * wordBoardColumn, "A");
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = getScreenWidth(context);
    final boardWidth = (screenWidth - wordBoardMargin * 2);
    final double cellWidth = boardWidth / wordBoardColumn;
    final double boardHeight = cellWidth * wordBoardRow;
    return CustomPaint(
      size: Size(boardWidth, boardHeight),
      painter: WordBoardPainter(
          boardWidth: boardWidth,
          boardHeight: boardHeight,
          letters: letters,
          highlightedCells: {},
          path: []),
    );
  }
}

class WordBoardPainter extends CustomPainter {
  final double boardWidth;
  final double boardHeight;
  final List<String> letters;
  final Set<int> highlightedCells;
  final List<Offset> path;

  WordBoardPainter(
      {required this.boardWidth,
      required this.boardHeight,
      required this.letters,
      required this.highlightedCells,
      required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    Paint cellPaint = Paint()..color = Colors.white;
    Paint cellBorderPaint = Paint()
      ..color = Colors.black45
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    Paint highlightedCellPaint = Paint()..color = Colors.yellow;
    Paint connectPathPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final cellSize = size.width / wordBoardColumn;

    // Draw the board's cells
    for (int row = 0; row < wordBoardRow; row++) {
      for (int column = 0; column < wordBoardColumn; column++) {
        int index = row * wordBoardColumn + column;

        Rect cellRect = Rect.fromLTWH(
            column * cellSize, row * cellSize, cellSize, cellSize);

        // Highlight cell if the cell is in highlightedCells
        if (highlightedCells.contains(index)) {
          canvas.drawRect(cellRect, highlightedCellPaint);
        } else {
          canvas.drawRect(cellRect, cellPaint);
        }
        canvas.drawRect(cellRect, cellBorderPaint);

        // Draw the letter
        TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: letters[index],
              style: TextStyle(
                color: Colors.black,
                fontSize: cellSize * 0.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        textPainter.layout();
        Offset textOffset = Offset(
          cellRect.center.dx - textPainter.width / 2,
          cellRect.center.dy - textPainter.height / 2,
        );
        textPainter.paint(canvas, textOffset);
      }
    }

    // Draw connect path
    if (path.isNotEmpty) {
      Path pathLine = Path()..moveTo(path[0].dx, path[0].dy);
      for (int i = 1; i < path.length; i++) {
        pathLine.lineTo(path[i].dx, path[i].dy);
      }

      canvas.drawPath(pathLine, connectPathPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
