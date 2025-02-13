import 'package:flutter/material.dart';
import 'block_model.dart';

class DraggableBlock extends StatelessWidget {
  final Block block;

  const DraggableBlock({Key? key, required this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<Block>(
      data: block,
      feedback: _buildBlock(),
      childWhenDragging: Opacity(opacity: 0.3, child: _buildBlock()),
      child: _buildBlock(),
    );
  }

  Widget _buildBlock() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: _getColor(block.color),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        block.shape.toUpperCase(),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getColor(String color) {
    switch (color) {
      case "red": return Colors.red;
      case "blue": return Colors.blue;
      case "green": return Colors.green;
      case "yellow": return Colors.yellow;
      case "purple": return Colors.purple;
      default: return Colors.grey;
    }
  }
}
