import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordboard/direction.dart';
import 'package:wordboard/stack.dart' as stack;
import 'package:wordboard/utils.dart';
import 'package:wordboard/word_board_cell.dart';

class WordBoardViewModel extends ChangeNotifier {
  final List<WordBoardCell> _cells = [];
  late double cellSize;
  late int boardRow;
  late int boardColumn;
  late String hiddenWord;

  List<WordBoardCell> get cells => _cells;
  List<WordBoardCell> selectedCells = [];

  void init(
      {required int boardRow,
      required int boardColumn,
      required double cellSize,
      required String hiddenWord}) {
    this.cellSize = cellSize;
    this.boardRow = boardRow;
    this.boardColumn = boardColumn;
    this.hiddenWord = hiddenWord;
    _createWordBoardCells(
        boardRow: boardRow, boardColumn: boardColumn, hiddenWord: hiddenWord);
    notifyListeners();
  }

  void updateSelectedCells(Offset touchPosition) {
    // Determine which row and column the touch pointer is
    int row = (touchPosition.dy / cellSize).floor();
    int column = (touchPosition.dx / cellSize).floor();
    int index = row * boardColumn + column;

    // Only check when the index is invalid
    if (index >= 0 || index < row * column) {
      if (index < boardRow * boardColumn) {
        WordBoardCell currentCell = WordBoardCell(
          row: row,
          column: column,
        )..letter = _cells[index].letter;

        // TODO: If User moves the pointer backward -> Update selected cells

        // Add the current cell to selected list if it has not been added yet
        if (!selectedCells.contains(currentCell)) {
          selectedCells.add(currentCell);
        }

        notifyListeners();
      }
    }
    print('Selected cells count: ${selectedCells.length}');
  }

  bool checkWord() {
    final String selectedWord = selectedCells
        .map((cell) {
          return cell.letter;
        })
        .toList()
        .join('');

    print(selectedWord == hiddenWord);
    if (selectedWord != hiddenWord) {
      selectedCells.clear();
      notifyListeners();
    }
    return selectedWord == hiddenWord;
  }

  void _createWordBoardCells(
      {required int boardRow,
      required int boardColumn,
      required String hiddenWord}) {
    _cells.clear();
    selectedCells.clear();
    _createEmptyBoardCells(boardRow: boardRow, boardColumn: boardColumn);
    _placeTheHiddenWord(
        boardRow: boardRow, boardColumn: boardColumn, hiddenWord: hiddenWord);
    _fillRemainingCells(boardRow: boardRow, boardColumn: boardColumn);
  }

  void _createEmptyBoardCells({
    required int boardRow,
    required int boardColumn,
  }) {
    for (int r = 0; r < boardRow; r++) {
      for (int c = 0; c < boardColumn; c++) {
        _cells.add(WordBoardCell(row: r, column: c));
      }
    }
  }

  /// Place all the letters of the hidden word onto the board
  void _placeTheHiddenWord(
      {required int boardRow,
      required int boardColumn,
      required String hiddenWord}) {
    stack.Stack<WordBoardCell> visitedCells = stack.Stack<WordBoardCell>();
    WordBoardCell? currentCell;

    hiddenWord.split('').forEach((letter) {
      do {
        WordBoardCell? randomCell =
            getRandomNonVisitedCell(boardRow, boardColumn, currentCell);
        if (randomCell != null) {
          int index = randomCell.row * boardColumn + randomCell.column;
          _cells[index].letter = letter;

          visitedCells.push(randomCell);
          currentCell = randomCell;

          // Stop do...while loop when a cell is determined
          break;
        }
      } while (visitedCells.length < hiddenWord.length);
    });
  }

  /// Fill all remaining cells with random letters
  void _fillRemainingCells({
    required int boardRow,
    required int boardColumn,
  }) {
    for (int i = 0; i < _cells.length; i++) {
      if (_cells[i].letter == null) {
        _cells[i] = WordBoardCell(
          row: _cells[i].row,
          column: _cells[i].column,
        )..letter = getRandomLetter();
      }
    }
  }

  /// Get random & non-visited cell (to fill next letter)
  WordBoardCell? getRandomNonVisitedCell(
      int boardRow, int boardColumn, WordBoardCell? currentCell) {
    Random random = Random();
    // If currentCell is null -> Find a random cell and return it (Don't need to
    // check the availability because all cells are non-visited now)
    if (currentCell == null) {
      int randomRow = random.nextInt(boardRow);
      int randomColumn = random.nextInt(boardColumn);
      return _cells[randomRow * boardColumn + randomColumn];
    }

    // If currentCell is not null -> Find adjacent available cell
    List<Direction> directions = Direction.values;
    int maxTry = directions.length;
    int currentTry = 0;
    WordBoardCell? adjacentCell;
    do {
      adjacentCell = null;
      // Generate a random direction (up or down or left or right)
      Direction randomDirection = directions[random.nextInt(directions.length)];
      int currentCellRow = currentCell.row;
      int currentCellColumn = currentCell.column;
      int adjacentCellRow = currentCellRow + randomDirection.delta[0];
      int adjacentCellColumn = currentCellColumn + randomDirection.delta[1];
      // The row or column is invalid (out of the board)
      // -> Continue to try another direction
      if (adjacentCellRow < 0 ||
          adjacentCellRow >= boardRow ||
          adjacentCellColumn < 0 ||
          adjacentCellColumn >= boardColumn) {
        currentTry++;
        continue;
      }

      int adjacentCellIndex =
          adjacentCellRow * boardColumn + adjacentCellColumn;

      // Check the adjacent cell if it was filled by a letter. If not, we can
      // use it. Otherwise, we need to try another
      if (adjacentCellIndex >= 0 &&
          adjacentCellIndex < _cells.length &&
          _cells[adjacentCellIndex].letter == null) {
        adjacentCell = WordBoardCell(
            column: _cells[adjacentCellIndex].column,
            row: _cells[adjacentCellIndex].row);

        return adjacentCell;
      }
      currentTry++;
    } while (currentTry < maxTry && adjacentCell == null);

    // There is no available adjacent cell -> Should try another path
    // throw 'There is no available adjacent cell -> Should try another path';
    return null;
  }
}
