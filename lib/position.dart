class Position {
  final int row;
  final int column;

  Position(this.row, this.column);

  Position? get up {
    if (row - 1 < 0) {
      return null;
    }
    return Position(row - 1, column);
  }

  Position? get left {
    if (column - 1 < 0) {
      return null;
    }
    return Position(row, column - 1);
  }

  Position? down(int rowsCount) {
    if (row + 1 >= rowsCount) {
      return null;
    }
    return Position(row + 1, column);
  }

  Position? right(int columnsCount) {
    if (column + 1 >= columnsCount) {
      return null;
    }
    return Position(row, column + 1);
  }

  Position? get leftUp {
    var up = this.up;
    var left = this.left;

    if (up == null || left == null) {
      return null;
    }

    return Position(up.row, left.column);
  }

  Position? leftDown(int rowsCount) {
    var down = this.down(rowsCount);
    var left = this.left;

    if (down == null || left == null) {
      return null;
    }

    return Position(down.row, left.column);
  }

  Position? rightUp(int columnsCount) {
    var up = this.up;
    var right = this.right(columnsCount);

    if (up == null || right == null) {
      return null;
    }

    return Position(up.row, right.column);
  }

  Position? rightDown(int rowsCount, int columnsCount) {
    var down = this.down(rowsCount);
    var right = this.right(columnsCount);

    if (down == null || right == null) {
      return null;
    }

    return Position(down.row, right.column);
  }
}
