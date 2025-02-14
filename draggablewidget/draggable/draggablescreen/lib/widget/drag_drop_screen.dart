import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DragDropScreen(),
    );
  }
}

class DragDropScreen extends StatefulWidget {
  const DragDropScreen({Key? key}) : super(key: key);

  @override
  _DragDropScreenState createState() => _DragDropScreenState();
}

class _DragDropScreenState extends State<DragDropScreen> {
  List<Map<String, dynamic>> bucket1Tasks = [];
  List<Map<String, dynamic>> bucket2Tasks = [];
  List<Map<String, dynamic>> bucket3Tasks = [];

  List<Map<String, dynamic>> availableTasks = [
    {"title": "Complete UI Design", "description": "Design the app's main interface.", "shape": "circle"},
    {"title": "API Integration", "description": "Connect the backend APIs.", "shape": "square"},
    {"title": "Testing & Debugging", "description": "Fix bugs and improve performance.", "shape": "triangle"},
  ];

  Future<void> loadJsonData() async {
    final String jsonString = await rootBundle.loadString('assets/jsons/data.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);

    setState(() {
      availableTasks = jsonData.cast<Map<String, dynamic>>();
    });
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    final Color darkBlue = const Color(0xFF00008B);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dark Drag & Drop UI"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: BackgroundPainter(),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildBucket("Bucket 1", bucket1Tasks, 1),
                    buildBucket("Bucket 2", bucket2Tasks, 2),
                    buildBucket("Bucket 3", bucket3Tasks, 3),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _showDoneDialog,
                  child: const Text(
                    "Done",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Available Tasks:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: availableTasks.map((task) {
                      return Draggable<Map<String, dynamic>>(
                        data: task,
                        feedback: Material(
                          color: Colors.transparent,
                          child: buildTaskCard(task, isDragging: true),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.5,
                          child: buildTaskCard(task),
                        ),
                        child: buildTaskCard(task),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBucket(String title, List<Map<String, dynamic>> taskList, int bucketIndex) {
    final Color darkBlue = const Color(0xFF00008B);
    CustomPainter painter;
    switch (bucketIndex) {
      case 1:
        painter = Bucket1Painter();
        break;
      case 2:
        painter = Bucket2Painter();
        break;
      case 3:
        painter = Bucket3Painter();
        break;
      default:
        painter = Bucket1Painter();
    }
    return SizedBox(
      width: 120,
      height: 220,
      child: CustomPaint(
        painter: painter,
        child: GlassmorphismContainer(
          borderRadius: 15,
          child: DragTarget<Map<String, dynamic>>(
            onWillAccept: (data) => true,
            onAccept: (task) {
              setState(() {
                taskList.add(Map<String, dynamic>.from(task));
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: darkBlue),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: taskList.isEmpty
                          ? const Center(
                              child: Text(
                                "Drop Here",
                                style: TextStyle(color: Colors.white54),
                              ),
                            )
                          : ListView.builder(
                              itemCount: taskList.length,
                              itemBuilder: (context, index) {
                                final task = taskList[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: buildTaskCard(task),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildTaskCard(Map<String, dynamic> task, {bool isDragging = false}) {
    return Card(
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: isDragging ? 10 : 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task["title"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (!isDragging)
              Text(
                task["description"],
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            SizedBox(
              width: 50,
              height: 50,
              child: CustomPaint(
                painter: ShapePainter(shape: task["shape"]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDoneDialog() {
    String formatTask(Map<String, dynamic> task) {
      String shapeSymbol;
      switch (task["shape"]) {
        case "circle":
          shapeSymbol = "⚪";
          break;
        case "square":
          shapeSymbol = "⬛";
          break;
        case "triangle":
          shapeSymbol = "🔺";
          break;
        default:
          shapeSymbol = "❓";
      }
      return "$shapeSymbol ${task["title"]}";
    }

    String bucket1Content = bucket1Tasks.isEmpty
        ? "No tasks"
        : bucket1Tasks.map((task) => formatTask(task)).join("\n");
    String bucket2Content = bucket2Tasks.isEmpty
        ? "No tasks"
        : bucket2Tasks.map((task) => formatTask(task)).join("\n");
    String bucket3Content = bucket3Tasks.isEmpty
        ? "No tasks"
        : bucket3Tasks.map((task) => formatTask(task)).join("\n");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Task Summary"),
          backgroundColor: Colors.black87,
          content: Text(
            "Bucket 1:\n$bucket1Content\n\n"
            "Bucket 2:\n$bucket2Content\n\n"
            "Bucket 3:\n$bucket3Content",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: TextStyle(color: const Color(0xFF00008B))),
            ),
          ],
        );
      },
    );
  }
}

class GlassmorphismContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const GlassmorphismContainer({Key? key, required this.child, this.borderRadius = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class Bucket1Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00008B).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Bucket2Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00008B).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Bucket3Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00008B).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = const Color(0xFF00008B).withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 100, circlePaint);

    final rectPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.save();
    canvas.translate(size.width * 0.3, size.height * 0.7);
    canvas.rotate(-0.3);
    canvas.drawRect(Rect.fromLTWH(0, 0, 120, 60), rectPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ShapePainter extends CustomPainter {
  final String shape;

  ShapePainter({required this.shape});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    switch (shape) {
      case "circle":
        final center = Offset(size.width / 2, size.height / 2);
        final radius = size.width / 2;
        canvas.drawCircle(center, radius, paint);
        break;
      case "square":
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        canvas.drawRect(rect, paint);
        break;
      case "triangle":
        final path = Path();
        path.moveTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.close();
        canvas.drawPath(path, paint);
        break;
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
