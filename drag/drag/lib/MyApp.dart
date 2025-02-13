import 'dart:convert';
import 'package:drag/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'block_model.dart';
import 'dropbox_model.dart';
import 'draggable_block.dart';
import 'dropbox_widget.dart';

void main() {
  runApp(WelcomePage());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Block> blocks = [];
  List<DropBox> dropBoxes = [];
  String outputMessage = "Drop a block to see the message!";

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String blockData = await rootBundle.loadString('assets/blocks.json');
    String dropBoxData = await rootBundle.loadString('assets/dropboxes.json');

    setState(() {
      blocks = (json.decode(blockData) as List).map((e) => Block.fromJson(e)).toList();
      dropBoxes = (json.decode(dropBoxData) as List).map((e) => DropBox.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Block Puzzle Game")),
        body: Column(
          children: [
            Wrap(children: blocks.map((block) => DraggableBlock(block: block)).toList()),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: dropBoxes.map((dropBox) => DropBoxWidget(dropBox: dropBox, onBlockDropped: (msg) {
                setState(() { outputMessage = msg; });
              })).toList(),
            ),
            SizedBox(height: 20),
            Text(outputMessage, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
