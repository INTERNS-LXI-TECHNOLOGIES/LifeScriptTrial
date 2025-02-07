import 'package:flutter/material.dart';


class Block {
  final String name;
  final List<Offset> shape;
  final Color color;
  int usageCount;

  Block(this.name, this.shape, this.color, {this.usageCount = 0});
}

class BlockPuzzleGame extends StatefulWidget {
  @override
  _BlockPuzzleGameState createState() => _BlockPuzzleGameState();
}

class _BlockPuzzleGameState extends State<BlockPuzzleGame> {
  static const int rows = 4;
  static const int cols = 10;

  List<List<Color?>> grid = List.generate(rows, (_) => List.filled(cols, null));

  List<Block> blocks = [
    Block('L-shaped 1', [Offset(0, 0), Offset(1, 0), Offset(0, 1)], Colors.red),
    Block('L-shaped 2', [Offset(0, 0), Offset(1, 0), Offset(1, 1)], Colors.green),
    Block('L-shaped 3', [Offset(0, 0), Offset(0, 1), Offset(1, 1)], Colors.blue),
    Block('L-shaped 4', [Offset(0, 0), Offset(1, 0), Offset(1, -1)], Colors.yellow),
    Block('Square', [Offset(0, 0), Offset(1, 0), Offset(0, 1), Offset(1, 1)], Colors.orange),
    Block('Horizontal Line', [Offset(0, 0), Offset(1, 0), Offset(2, 0)], Colors.purple),
    Block('Vertical Line', [Offset(0, 0), Offset(0, 1), Offset(0, 2)], Colors.cyan),
    Block('T-shaped', [Offset(0, 0), Offset(1, 0), Offset(2, 0), Offset(1, 1)], Colors.pink),
    Block('Z-shaped 1', [Offset(0, 0), Offset(1, 0), Offset(1, 1), Offset(2, 1)], Colors.brown),
    Block('Z-shaped 2', [Offset(0, 0), Offset(0, 1), Offset(1, 1), Offset(1, 2)], Colors.teal),
    Block('Cross-shaped', [Offset(0, 0), Offset(1, 0), Offset(0, 1), Offset(-1, 0), Offset(0, -1)], Colors.indigo),
    Block('Single Block', [Offset(0, 0)], Colors.grey),
  ];

  bool canPlaceBlock(Block block, int row, int col) {
    for (var offset in block.shape) {
      int newRow = row + offset.dy.toInt();
      int newCol = col + offset.dx.toInt();
      if (newRow < 0 || newRow >= rows || newCol < 0 || newCol >= cols || grid[newRow][newCol] != null) {
        return false;
      }
    }
    return true;
  }

  void placeBlock(Block block, int row, int col) {
    setState(() {
      for (var offset in block.shape) {
        int newRow = row + offset.dy.toInt();
        int newCol = col + offset.dx.toInt();
        grid[newRow][newCol] = block.color;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drag And Drop'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                grid = List.generate(rows, (_) => List.filled(cols, null));
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: blocks.map((block) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Draggable<Block>(
                    data: block,
                    feedback: Material(
                      color: Colors.transparent,
                      child: CustomPaint(
                        size: Size(50, 50),
                        painter: BlockPainter(block.shape, block.color),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.5,
                      child: CustomPaint(
                        size: Size(50, 50),
                        painter: BlockPainter(block.shape, block.color),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: block.color.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 3,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: CustomPaint(
                            size: Size(50, 50),
                            painter: BlockPainter(block.shape, block.color),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          block.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8), // Change background color for better visibility
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  childAspectRatio: 1.0, // Ensure square cells
                ),
                itemCount: rows * cols,
                itemBuilder: (context, index) {
                  int row = index ~/ cols;
                  int col = index % cols;
                  return DragTarget<Block>(
                    onWillAccept: (block) {
                      return block != null && canPlaceBlock(block, row, col);
                    },
                    onAccept: (block) {
                      placeBlock(block, row, col);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black.withOpacity(0.3)),
                          color: grid[row][col] ?? Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlockPainter extends CustomPainter {
  final List<Offset> shape;
  final Color color;

  BlockPainter(this.shape, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final double blockSize = size.width / 2;

    for (Offset offset in shape) {
      canvas.drawRect(
        Rect.fromLTWH(
          offset.dx * blockSize,
          offset.dy * blockSize,
          blockSize,
          blockSize,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}