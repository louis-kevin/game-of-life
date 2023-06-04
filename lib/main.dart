import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'creature.dart';
import 'grid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Grid? grid;
  final double boxSize = 25.0;
  bool paused = true;

  generateGrid() {
    if (grid != null) return;

    var size = MediaQuery.of(context).size;
    var rowsCount = (size.height / boxSize) - 1;
    var columnsCount = (size.width / boxSize) - 1;

    grid = Grid(rowsCount.toInt(), columnsCount.toInt());

    Future.delayed(const Duration(milliseconds: 100), calculateGrid);
  }

  calculateGrid() {
    if (paused) return;
    Stopwatch stopwatch = Stopwatch()..start();
    grid?.checkCreatures();
    print('${stopwatch.elapsed.inMicroseconds}');
    Future.delayed(const Duration(milliseconds: 1), calculateGrid);
  }

  togglePause() {
    setState(() => paused = !paused);

    if (!paused) {
      calculateGrid();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    generateGrid();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: togglePause,
        child: Icon(paused ? Icons.play_arrow_rounded : Icons.pause),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: buildGrid(),
      ),
    );
  }

  buildGrid() {
    return Column(
      children: grid?.grid.map(buildRow).toList() ?? [],
    );
  }

  Widget buildRow(List<Creature> columns) {
    return Row(
      children: columns.map(buildItem).toList(),
    );
  }

  Widget buildItem(Creature creature) {
    return ChangeNotifierProvider.value(
      value: creature,
      child: CreatureBox(
        boxSize: boxSize,
      ),
    );
  }
}

class CreatureBox extends StatelessWidget {
  final double boxSize;

  const CreatureBox({Key? key, required this.boxSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var creature = context.watch<Creature>();

    return GestureDetector(
      onTap: () => creature.bringAlive(),
      child: Container(
        height: boxSize,
        width: boxSize,
        decoration: BoxDecoration(
          color: creature.alive ? Colors.white : Colors.black,
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
