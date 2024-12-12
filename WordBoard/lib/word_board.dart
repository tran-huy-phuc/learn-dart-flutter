import 'package:flutter/material.dart';
import 'package:wordboard/confetti.dart';
import 'package:wordboard/constants.dart';
import 'package:wordboard/utils.dart';
import 'package:wordboard/word_board_cell.dart';
import 'package:wordboard/word_board_view_model.dart';

class WordBoard extends StatefulWidget {
  const WordBoard({Key? key}) : super(key: key);

  @override
  State<WordBoard> createState() => _WordBoardState();
}

class _WordBoardState extends State<WordBoard> {
  // late List<String> letters;
  WordBoardViewModel workBoardViewModel = WordBoardViewModel();
  TextEditingController controller =
      TextEditingController(text: defaultHiddenWord);
  double scale = 0;

  @override
  void initState() {
    super.initState();
    onWidgetBuildDone(() {
      _generateWordBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: workBoardViewModel,
        builder: (BuildContext context, Widget? widget) {
          if (workBoardViewModel.cells.isEmpty) {
            return const CircularProgressIndicator();
          }

          final double screenWidth = getScreenWidth(context);
          final boardWidth = (screenWidth - wordBoardMargin * 2);
          final double cellWidth = boardWidth / wordBoardColumn;
          final double boardHeight = cellWidth * wordBoardRow;

          return Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              // const SizedBox(height: 20,),
              AnimatedScale(
                scale: scale,
                duration: const Duration(seconds: 1),
                child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: CustomPaint(
                      size: Size(boardWidth, boardHeight),
                      painter: WordBoardPainter(
                        boardWidth: boardWidth,
                        boardHeight: boardHeight,
                        wordBoardViewModel: workBoardViewModel,
                        // highlightedCells: {},
                        // path: []
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: controller,
                  onChanged: (text) {},
                  enabled: true,
                  decoration:
                      const InputDecoration(hintText: 'Enter a hidden word...'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    onPressed: () {
                      _generateWordBoard(hiddenWord: controller.text);
                    },
                    child: const Text('Generate Board')),
              )
            ],
          );
        });
  }

  void _onPanStart(DragStartDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);

    workBoardViewModel.updateSelectedCells(localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);

    workBoardViewModel.updateSelectedCells(localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    // RenderBox box = context.findRenderObject() as RenderBox;
    // Offset localPosition = box.globalToLocal(details.globalPosition);

    // User releases the touch/drag -> Check the selected word
    bool isCorrect = workBoardViewModel.checkWord();
    if (isCorrect) {
      showConfettiEffect(context);
    }
  }

  Future<void> _generateWordBoard(
      {String hiddenWord = defaultHiddenWord}) async {
    setState(() {
      scale = 0;
    });
    final double screenWidth = getScreenWidth(context);
    final double boardWidth = (screenWidth - wordBoardMargin * 2);
    final double cellSize = boardWidth / wordBoardColumn;
    await Future.delayed(const Duration(milliseconds: 300));
    workBoardViewModel.init(
        boardRow: wordBoardRow,
        boardColumn: wordBoardColumn,
        cellSize: cellSize,
        hiddenWord: hiddenWord.toUpperCase());
    setState(() {
      scale = 1;
    });
  }
}

class WordBoardPainter extends CustomPainter {
  final double boardWidth;
  final double boardHeight;

  // final List<WordBoardCell> cells;
  // final Set<int> highlightedCells;
  // final List<Offset> path;
  final WordBoardViewModel wordBoardViewModel;

  WordBoardPainter({
    required this.boardWidth,
    required this.boardHeight,
    required this.wordBoardViewModel,
    // required this.cells,
    // required this.highlightedCells,
    // required this.path
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint cellPaint = Paint()..color = Colors.white;
    Paint cellBorderPaint = Paint()
      ..color = Colors.black45
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    Paint highlightedCellPaint = Paint()..color = Colors.yellow;
    Paint connectPathPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = connectedPathWidth
      ..style = PaintingStyle.stroke;

    Paint connectCirclePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final cellSize = size.width / wordBoardColumn;

    // Draw the board's cells
    for (int row = 0; row < wordBoardRow; row++) {
      for (int column = 0; column < wordBoardColumn; column++) {
        int index = row * wordBoardColumn + column;
        final String letter = wordBoardViewModel.cells[index].letter ?? '';
        final WordBoardCell currentCell =
            WordBoardCell(row: row, column: column)..letter = letter;

        Rect cellRect = Rect.fromLTWH(
            column * cellSize + cellMargin,
            row * cellSize + cellMargin,
            cellSize - cellMargin * 2,
            cellSize - cellMargin * 2);
        RRect cellRRect = RRect.fromRectAndRadius(
            cellRect, const Radius.circular(cellBorderRadius));

        // Highlight cell if the cell is in highlightedCells
        if (wordBoardViewModel.selectedCells.contains(currentCell)) {
          canvas.drawRRect(cellRRect, highlightedCellPaint);
        } else {
          // canvas.drawRect(cellRect, cellPaint);
          canvas.drawRRect(cellRRect, cellPaint);
        }
        canvas.drawRRect(cellRRect, cellBorderPaint);

        // Draw the letter
        TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: letter,
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
    if (wordBoardViewModel.selectedCells.isNotEmpty) {
      double cellCenterX =
          wordBoardViewModel.selectedCells[0].column * cellSize + cellSize / 2;
      double cellCenterY =
          wordBoardViewModel.selectedCells[0].row * cellSize + cellSize / 2;
      // Draw a circle at the center of the cell
      canvas.drawCircle(Offset(cellCenterX, cellCenterY), connectedDotRadius,
          connectCirclePaint);
      Path pathLine = Path()..moveTo(cellCenterX, cellCenterY);
      for (int i = 1; i < wordBoardViewModel.selectedCells.length; i++) {
        cellCenterX = wordBoardViewModel.selectedCells[i].column * cellSize +
            cellSize / 2;
        cellCenterY =
            wordBoardViewModel.selectedCells[i].row * cellSize + cellSize / 2;
        // Draw a circle at the center of the cell
        canvas.drawCircle(Offset(cellCenterX, cellCenterY), connectedDotRadius,
            connectCirclePaint);
        pathLine.lineTo(cellCenterX, cellCenterY);
      }

      canvas.drawPath(pathLine, connectPathPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
