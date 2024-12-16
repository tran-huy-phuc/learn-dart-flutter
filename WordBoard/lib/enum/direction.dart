enum Direction {
  up,
  down,
  left,
  right;

  // Get the row and column delta for each direction
  List<int> get delta {
    switch (this) {
      case Direction.up:
        return [-1, 0];
      case Direction.down:
        return [1, 0];
      case Direction.left:
        return [0, -1];
      case Direction.right:
        return [0, 1];
    }
  }
}