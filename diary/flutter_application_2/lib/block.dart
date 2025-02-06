import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> droppedShapes = []; // Stores dropped shapes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Draggable Shapes Section
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDraggableShape(_buildSquare(Colors.blue), "Square"),
                _buildDraggableShape(_buildCircle(Colors.red), "Circle"),
                _buildDraggableShape(_buildTriangle(Colors.green), "Triangle"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Drag Target (Drop Area)
          Expanded(
            child: DragTarget<Widget>(
              onAccept: (shape) {
                setState(() {
                  droppedShapes.add(shape); // Add shape to the list
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Drag shapes here",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: droppedShapes, // Display dropped shapes
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Draggable Shape Wrapper
  Widget _buildDraggableShape(Widget shape, String shapeType) {
    return Draggable<Widget>(
      data: shape,
      feedback: Opacity(opacity: 0.7, child: shape),
      childWhenDragging: Opacity(opacity: 0.3, child: shape),
      child: shape,
    );
  }

  // Square Shape Widget
  Widget _buildSquare(Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
      ),
    );
  }

  // Circle Shape Widget
  Widget _buildCircle(Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
    );
  }

  // Triangle Shape Widget
  Widget _buildTriangle(Color color) {
    return CustomPaint(
      size: const Size(50, 50),
      painter: TrianglePainter(color),
    );
  }
}

// Custom Painter for Triangle
class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width / 2, 0); // Top point
    path.lineTo(0, size.height); // Bottom-left
    path.lineTo(size.width, size.height); // Bottom-right
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = 2); // Border
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
