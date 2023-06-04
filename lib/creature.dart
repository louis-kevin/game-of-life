import 'package:flutter/cupertino.dart';
import 'package:game_of_life/position.dart';

class Creature extends ChangeNotifier {
  final Position position;
  bool alive = false;
  bool willBeAlive = false;
  bool willBeDead = false;
  List<Position> neighbors = [];

  Creature(this.position, int rowsCount, int columnsCount) {
    var list = [
      position.up,
      position.down(rowsCount),
      position.left,
      position.right(columnsCount),
      position.leftUp,
      position.leftDown(rowsCount),
      position.rightDown(rowsCount, columnsCount),
      position.rightUp(columnsCount),
    ];

    neighbors = list.whereType<Position>().toList();
  }

  calculateDestiny(List<List<Creature>> grid) {
    var countNeighborsAlive = 0;
    willBeDead = false;
    willBeAlive = false;

    if (alive) {
      for (var neighbor in neighbors) {
        if (grid[neighbor.row][neighbor.column].alive) {
          countNeighborsAlive++;
        }
        if (countNeighborsAlive > 3) {
          willBeDead = true;
          break;
        }
      }
      if (!willBeDead && countNeighborsAlive < 2) {
        willBeDead = true;
      }
    } else {
      for (var neighbor in neighbors) {
        if (grid[neighbor.row][neighbor.column].alive) {
          countNeighborsAlive++;
        }
      }
      if (!alive && countNeighborsAlive == 3) {
        willBeAlive = true;
      }
    }

    return willBeDead || willBeAlive;
  }

  void fullFillDestiny() {
    if (alive && willBeDead) return kill();
    if (!alive && willBeAlive) return bringAlive();
  }

  void bringAlive() {
    alive = true;
    notifyListeners();
  }

  void kill() {
    alive = false;
    notifyListeners();
  }
}
