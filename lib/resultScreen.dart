import 'package:diplooajil/ButtonScreen.dart';
// import 'package:diplooajil/SpeedTypingScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: ResultScreen(),
    );
  }
}

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String _selectedLanguage = "English (en)";
  int _selectedTime = 60;
  List<bool> _isSelectedGameMode = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Lottie.asset(
            'assets/lottie/2.json',
            width: 200,
            height: 400,
          ),
        ),
      ),
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Speed Typing! 🎉',
                    style: GoogleFonts.pacifico(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.purpleAccent, blurRadius: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  _glassmorphicCard(),
                  SizedBox(height: 20),
                  Text(
                    'Next Game Mode',
                    style: GoogleFonts.merriweather(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.purpleAccent, blurRadius: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  _gameModeSelection(),
                  SizedBox(height: 40),
                  _actionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade900, Colors.indigo.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        ...List.generate(10, (index) => _staticBubble(index)),
      ],
    );
  }

  Widget _staticBubble(int index) {
    final random = Random(index);
    double size = random.nextDouble() * 100 + 50;
    double top = random.nextDouble() * 600;
    double left = random.nextDouble() * 400;
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
          gradient: RadialGradient(
            // ignore: deprecated_member_use
            colors: [Colors.white.withOpacity(0.4), Colors.transparent],
            center: Alignment.center,
            radius: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _glassmorphicCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        // ignore: deprecated_member_use
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Language",
              style: GoogleFonts.pacifico(fontSize: 22, color: Colors.white),
            ),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              dropdownColor: Colors.grey[900],
              style: TextStyle(color: Colors.white),
              items: ["English (en)", "Монгол (mn)"].map((String lang) {
                return DropdownMenuItem(value: lang, child: Text(lang));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text(
              "Game Time",
              style: GoogleFonts.pacifico(fontSize: 22, color: Colors.white),
            ),
            trailing: DropdownButton<int>(
              value: _selectedTime,
              items: [60, 180, 300, 600].map((int time) {
                return DropdownMenuItem(
                    value: time, child: Text("${time ~/ 60} min"));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTime = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _gameModeSelection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade600, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(32),
        isSelected: _isSelectedGameMode,
        selectedColor: Colors.white,
        fillColor: Colors.blueAccent,
        color: Colors.white,
        renderBorder: false,
        children: [
          _gameModeButton('Easy'),
          _gameModeButton('Medium'),
          _gameModeButton('Hard'),
        ],
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < _isSelectedGameMode.length; i++) {
              _isSelectedGameMode[i] = i == index;
            }
          });
        },
      ),
    );
  }

  Widget _gameModeButton(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Text(
        text,
        style: GoogleFonts.pacifico(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Column(
      children: [
        ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.greenAccent,
    minimumSize: Size(double.infinity, 60),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  onPressed: () {
    // Navigate to ButtonScreen first to keep the bottom navigation bar
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ButtonScreen()),
    );
  },
  child: Text(
    'Play Again',
    style: GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
)
      ],
    );
  }
}
