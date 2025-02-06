import 'package:flutter/material.dart';


class BlockPuzzleGame extends StatefulWidget {
  @override
  _BlockPuzzleGameState createState() => _BlockPuzzleGameState();
}

class _BlockPuzzleGameState extends State<BlockPuzzleGame> {
  // Grid size: 3 rows x 12 columns
  static const int rows = 4;
  static const int cols = 10;

  // Grid state: 0 = empty, 1 = filled
  List<List<int>> grid = List.generate(rows, (_) => List.filled(cols, 0));

  // Draggable blocks (each block is represented as a list of relative positions)
  final List<List<Offset>> blocks = [
    // L-shaped blocks
    [Offset(0, 0), Offset(1, 0), Offset(0, 1)], // L-shaped block
    [Offset(0, 0), Offset(1, 0), Offset(1, 1)], // Reverse L-shaped block
    [Offset(0, 0), Offset(0, 1), Offset(1, 1)], // L-shaped block (rotated)
    [Offset(0, 0), Offset(1, 0), Offset(1, -1)], // L-shaped block (rotated)

    // Square block
    [Offset(0, 0), Offset(1, 0), Offset(0, 1), Offset(1, 1)], // Square block

    // Line blocks
    [Offset(0, 0), Offset(1, 0), Offset(2, 0)], // Horizontal line
    [Offset(0, 0), Offset(0, 1), Offset(0, 2)], // Vertical line

    // T-shaped block
    [Offset(0, 0), Offset(1, 0), Offset(2, 0), Offset(1, 1)], // T-shaped block

    // Z-shaped blocks
    [Offset(0, 0), Offset(1, 0), Offset(1, 1), Offset(2, 1)], // Z-shaped block
    [Offset(0, 0), Offset(0, 1), Offset(1, 1), Offset(1, 2)], // Z-shaped block (rotated)

    // S-shaped blocks
    [Offset(0, 0), Offset(1, 0), Offset(1, -1), Offset(2, -1)], // S-shaped block
    [Offset(0, 0), Offset(0, 1), Offset(1, 1), Offset(1, 2)], // S-shaped block (rotated)

    // Cross-shaped block
    [Offset(0, 0), Offset(1, 0), Offset(0, 1), Offset(-1, 0), Offset(0, -1)], // Cross-shaped block

    // Single grid block
    [Offset(0, 0)], // Single block
  ];

  // Check if the grid is completely filled
  bool isGridFilled() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (grid[i][j] == 0) {
          return false;
        }
      }
    }
    return true;
  }

  // Check if a block can be placed at a specific position
  bool canPlaceBlock(List<Offset> block, int startRow, int startCol) {
    for (Offset offset in block) {
      int row = startRow + offset.dy.toInt();
      int col = startCol + offset.dx.toInt();
      if (row < 0 || row >= rows || col < 0 || col >= cols || grid[row][col] != 0) {
        return false;
      }
    }
    return true;
  }

  // Place a block on the grid
  void placeBlock(List<Offset> block, int startRow, int startCol) {
    setState(() {
      for (Offset offset in block) {
        int row = startRow + offset.dy.toInt();
        int col = startCol + offset.dx.toInt();
        grid[row][col] = 1;
      }
    });

    // Check if the grid is filled
    if (isGridFilled()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have filled the grid!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Block Puzzle Game'),
      ),
      body: Column(
        children: [
          // Draggable blocks at the top
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: blocks.map((block) {
                return Draggable<List<Offset>>(
                  data: block,
                  feedback: Material(
                    child: Container(
                      color: Colors.transparent,
                      child: CustomPaint(
                        size: Size(50, 50),
                        painter: BlockPainter(block),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(),
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CustomPaint(
                      painter: BlockPainter(block),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Grid at the bottom
          Expanded(
            flex: 3,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
              ),
              itemCount: rows * cols,
              itemBuilder: (context, index) {
                int row = index ~/ cols;
                int col = index % cols;
                return DragTarget<List<Offset>>(
                  onAccept: (block) {
                    if (canPlaceBlock(block, row, col)) {
                      placeBlock(block, row, col);
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: grid[row][col] == 1 ? Colors.blue : Colors.white,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter to draw the blocks
class BlockPainter extends CustomPainter {
  final List<Offset> block;

  BlockPainter(this.block);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.red;
    final double padding = 2.0; // Add a small gap between blocks

    for (Offset offset in block) {
      canvas.drawRect(
        Rect.fromLTWH(
          offset.dx * (size.width / 2) + padding,
          offset.dy * (size.height / 2) + padding,
          (size.width / 2) - 2 * padding,
          (size.height / 2) - 2 * padding,
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