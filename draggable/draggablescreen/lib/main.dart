import 'package:draggablescreen/widget/ShapeDisplay.dart';
import 'package:draggablescreen/widget/drag_drop_screen.dart';
import 'package:draggablescreen/widget/questionnairescreen.dart';
import 'package:draggablescreen/widget/welcomepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final Color darkBlue = const Color(0xFF00008B);

     return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,

      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: darkBlue,
        hintColor: darkBlue,
      ),
      home:DragDropScreen(),
      routes: {
        '/home': (context) => WelcomePage(),
    '/questionnaire': (context) => QuestionnaireScreen(),
      },
    );
  }
}







/*import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Dynamic Shape Display')),
        body: Center(
          child: ShapeDisplayList(jsonData: '''
          [
            {
              "shape": "amoeba",
              "color": "blue",
              "points": [
                {"x": 0.2, "y": 0.2},
                {"x": 0.4, "y": 0.1},
                {"x": 0.6, "y": 0.3},
                {"x": 0.8, "y": 0.2},
                {"x": 0.9, "y": 0.3},
                {"x": 0.8, "y": 0.5},
                {"x": 0.9, "y": 0.7},
                {"x": 0.8, "y": 0.9},
                {"x": 0.6, "y": 0.8},
                {"x": 0.4, "y": 0.9},
                {"x": 0.2, "y": 0.8},
                {"x": 0.1, "y": 0.6},
                {"x": 0.2, "y": 0.4}
              ]
            },
            {
              "shape": "star",
              "color": "yellow",
              "points": [
                {"x": 0.5, "y": 0.1},
                {"x": 0.6, "y": 0.4},
                {"x": 0.9, "y": 0.4},
                {"x": 0.7, "y": 0.6},
                {"x": 0.8, "y": 0.9},
                {"x": 0.5, "y": 0.7},
                {"x": 0.2, "y": 0.9},
                {"x": 0.3, "y": 0.6},
                {"x": 0.1, "y": 0.4},
                {"x": 0.4, "y": 0.4}
              ]
            },
            {
              "shape": "triangle",
              "color": "red",
              "points": [
                {"x": 0.5, "y": 0.1},
                {"x": 0.9, "y": 0.9},
                {"x": 0.1, "y": 0.9}
              ]
            }
          ]
          '''),
        ),
      ),
    );
  }
}

class ShapeDisplayList extends StatelessWidget {
  final String jsonData;

  ShapeDisplayList({required this.jsonData});

  @override
  Widget build(BuildContext context) {
    List<dynamic> shapesData = jsonDecode(jsonData);

    return ListView.builder(
      itemCount: shapesData.length,
      itemBuilder: (context, index) {
        String shapeJson = jsonEncode(shapesData[index]);
        return ShapeDisplay(jsonData: shapeJson);
      },
    );
  }
}

class ShapeDisplay extends StatelessWidget {
  final String jsonData;

  ShapeDisplay({required this.jsonData});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = jsonDecode(jsonData);
    String shape = data['shape'];
    Color color = _parseColor(data['color']);
    List<Offset> points = _parsePoints(data['points']);

    return CustomPaint(
      size: Size(200, 200),
      painter: ShapePainter(shape: shape, color: color, points: points),
    );
  }

  Color _parseColor(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      // Add more colors here
      default:
        return Colors.black;
    }
  }

  List<Offset> _parsePoints(List<dynamic> pointsData) {
    return pointsData.map<Offset>((point) {
      return Offset(point['x'], point['y']);
    }).toList();
  }
}

class ShapePainter extends CustomPainter {
  final String shape;
  final Color color;
  final List<Offset> points;

  ShapePainter({required this.shape, required this.color, required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (points.isNotEmpty) {
      path.moveTo(points[0].dx * size.width, points[0].dy * size.height);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx * size.width, points[i].dy * size.height);
      }
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
*/