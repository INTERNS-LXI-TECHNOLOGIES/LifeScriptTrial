import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int _currentQuestionIndex = 0;
  final List<String> _questions = [
    "What is one thing that truly makes you happy?",
    "If you could achieve anything this year, what would it be?",
    "What is one habit you want to improve in your daily life?",
    "Who or what inspires you to be your best self?",
    "What is a small step you can take today toward your biggest goal?",
  ];
  TextEditingController _answerController = TextEditingController();

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answerController.clear();
      });
    }
  }

  void _goToNextPage() {
    // Navigate to the next screen (Replace with actual navigation logic)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NextScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildBackgroundAnimation(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMotivationalIcons(),
              SizedBox(height: 40),
              _buildGlassmorphicCard(),
              SizedBox(height: 20),
              _buildNextButton(),
              SizedBox(height: 10),
              _buildNextPageButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundAnimation() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildMotivationalIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.star, color: Colors.blueAccent, size: 30),
        SizedBox(width: 20),
        Icon(Icons.favorite, color: Colors.redAccent, size: 30),
        SizedBox(width: 20),
        Icon(Icons.lightbulb, color: Colors.yellowAccent, size: 30),
      ],
    );
  }

  Widget _buildGlassmorphicCard() {
    return GlassmorphicContainer(
      width: 350,
      height: 250, // Increased height to fit both question and input
      borderRadius: 20,
      blur: 10,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.blueAccent.withOpacity(0.5),
          Colors.blueAccent.withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              transitionBuilder: (widget, animation) {
                return FadeTransition(opacity: animation, child: widget);
              },
              child: Text(
                _questions[_currentQuestionIndex],
                key: ValueKey<int>(_currentQuestionIndex),
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildAnswerInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: 250, // Adjust the width to your preference
        child: TextField(
          controller: _answerController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Type your answer here...",
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.white.withOpacity(0.1),
            filled: true,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: _nextQuestion,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        elevation: 10,
      ),
      child: Text(
        "Next Question",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildNextPageButton() {
    return GlassmorphicContainer(
      width: 180,
      height: 50,
      borderRadius: 20,
      blur: 10,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [Colors.blueAccent.withOpacity(0.2), Colors.blue.withOpacity(0.1)],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.blueAccent.withOpacity(0.5), Colors.blueAccent.withOpacity(0.1)],
      ),
      child: TextButton(
        onPressed: _goToNextPage,
        child: Text(
          "Go to Next Page",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Next Page Content",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
