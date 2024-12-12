import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordboard/constants.dart';
import 'package:wordboard/direction.dart';
import 'package:wordboard/utils.dart';
import 'package:wordboard/word_board_cell.dart';
import 'package:wordboard/stack.dart' as stack;

class WordBoardViewModel extends ChangeNotifier {
  final List<WordBoardCell> _wordBoardCells = [];

  List<WordBoardCell> get wordBoardCells => _wordBoardCells;

  void init(
      {required int boardRow,
      required int boardColumn,
      required String hiddenWord}) {
    _createWordBoardCells(
        boardRow: boardRow, boardColumn: boardColumn, hiddenWord: hiddenWord);
  }

  void _createWordBoardCells(
      {required int boardRow,
      required int boardColumn,
      required String hiddenWord}) {
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
        _wordBoardCells.add(WordBoardCell(row: r, column: c));
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
      print('Letter ---> $letter');
      do {
        WordBoardCell? randomCell =
            getRandomNonVisitedCell(boardRow, boardColumn, currentCell);
        if (randomCell != null) {
          int index = randomCell.row * boardColumn + randomCell.column;
          _wordBoardCells[index].letter = letter;

          visitedCells.push(randomCell);
          currentCell = randomCell;

          // Stop do...while loop when a cell is determined
          break;
        }
      } while (visitedCells.length < hiddenWord.length);
      print('Visited count: ${visitedCells.length}');
    });
  }

  /// Fill all remaining cells with random letters
  void _fillRemainingCells({
    required int boardRow,
    required int boardColumn,
  }) {
    Random random = Random();
    for (int i = 0; i < wordBoardCells.length; i++) {
      if (wordBoardCells[i].letter == null) {
        wordBoardCells[i] = WordBoardCell(
          row: wordBoardCells[i].row,
          column: wordBoardCells[i].column,
        )..letter = getRandomLetter();
      }
    }
  }

  bool _doesWordFit(int rows, int cols, int startRow, int startCol, int dx,
      int dy, int wordLength) {
    int endRow = startRow + (wordLength - 1) * dx;
    int endCol = startCol + (wordLength - 1) * dy;

    if (endRow < 0 || endRow >= rows || endCol < 0 || endCol >= cols) {
      return false;
    }

    return true;
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
      return _wordBoardCells[randomRow * boardColumn + randomColumn];
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
          adjacentCellIndex < _wordBoardCells.length &&
          _wordBoardCells[adjacentCellIndex].letter == null) {
        adjacentCell = WordBoardCell(
          column: _wordBoardCells[adjacentCellIndex].column,
          row: _wordBoardCells[adjacentCellIndex].row
        );

        return adjacentCell;
      }
      // Remove the direction so next time we only try with other directions
      // else {
      //   directions.remove(randomDirection);
      //   print(directions);
      // }
      currentTry++;
    } while (currentTry < maxTry && adjacentCell == null);

    // There is no available adjacent cell -> Should try another path
    return null;
  }
}
