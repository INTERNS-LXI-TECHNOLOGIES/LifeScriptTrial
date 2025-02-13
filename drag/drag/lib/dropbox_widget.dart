import 'package:flutter/material.dart';
import 'block_model.dart';
import 'dropbox_model.dart';

class DropBoxWidget extends StatefulWidget {
  final DropBox dropBox;
  final Function(String) onBlockDropped;

  const DropBoxWidget({Key? key, required this.dropBox, required this.onBlockDropped}) : super(key: key);

  @override
  _DropBoxWidgetState createState() => _DropBoxWidgetState();
}

class _DropBoxWidgetState extends State<DropBoxWidget> {
  bool isDropped = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Block>(
      onWillAccept: (block) => block?.shape == widget.dropBox.accepts,
      onAccept: (block) {
        widget.onBlockDropped(block.message);
        setState(() {
          isDropped = true;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: isDropped ? Colors.greenAccent : Colors.grey[300],
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(widget.dropBox.accepts.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}
