import 'dart:math';

import 'package:game_of_life/position.dart';

import 'creature.dart';

class Grid {
  final int rowsCount;
  final int columnsCount;
  List<List<Creature>> grid = [];

  Grid(this.rowsCount, this.columnsCount) {
    var rng = Random();
    for (var row = 0; row < rowsCount; row++) {
      var items = <Creature>[];

      for (var column = 0; column < columnsCount; column++) {
        var i = rng.nextInt(100);
        var creature = Creature(Position(row, column), rowsCount, columnsCount);
        creature.alive = i > 80;
        items.add(creature);
      }

      grid.add(items);
    }
  }

  checkCreatures() {
    var changedCreatures = [];

    for (var row in grid) {
      for (var creature in row) {
        var changed = creature.calculateDestiny(grid);
        if (changed) {
          changedCreatures.add(creature);
        }
      }
    }

    for (var creature in changedCreatures) {
      creature.fullFillDestiny();
    }
  }

  bringToLive(Position position) {
    grid[position.row][position.column].alive = true;
  }
}
