import 'package:draggable/BlockPuzzleGame.dart';
import 'package:flutter/material.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Puzzle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlockPuzzleGame(),
    );
  }
}