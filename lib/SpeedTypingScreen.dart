import 'package:flutter/material.dart';
import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeedTypingScreen extends StatefulWidget {
  @override
  _SpeedTypingScreenState createState() => _SpeedTypingScreenState();
}

class _SpeedTypingScreenState extends State<SpeedTypingScreen> {
  Timer? _timer;
  int _timeLeft = 60;
  double _progress = 1.0;
  String sampleText = "January external away provide notes root included attributes by both allowed numbers around powered job header shall provided base total three processing management disabled find next channel date get central images title was district map page even guide rather follow understand her deprecated.";
  String typedText = "";
  int wpm = 0, errors = 0, accuracy = 0;
  TextEditingController _controller = TextEditingController();
  bool _isTypingEnabled = true; // Таймер дуусах хүртэл шивэхийг идэвхжүүлнэ

  void _startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
          _progress = _timeLeft / 60;
        } else {
          _timer?.cancel();
          _isTypingEnabled = false; // Таймер дуусахад шивэхийг зогсооно
        }
      });
    });
  }

  void _updateTyping(String value) {
    setState(() {
      typedText = value;
      List<String> sampleWords = sampleText.split(' ');
      List<String> typedWords = value.split(' ');

      int correctWords = 0;
      errors = 0;

      for (int i = 0; i < typedWords.length; i++) {
        if (i < sampleWords.length && typedWords[i] == sampleWords[i]) {
          correctWords++;
        } else {
          errors++;
        }
      }

      wpm = (_timeLeft < 60 && correctWords > 0) ? (correctWords * (60 ~/ (60 - _timeLeft))).clamp(0, 200) : 0;
      accuracy = (typedWords.isNotEmpty) ? ((correctWords / typedWords.length) * 100).toInt().clamp(0, 100) : 0;
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

 Widget buildCircularGauge(String label, double value, String displayValue, Color color) {
  return Column(
    children: [
      SizedBox(
        width: 100,
        height: 80,
        child: SfRadialGauge(
          axes: [
            RadialAxis(
              minimum: 0,
              maximum: 100,
              ranges: [
                GaugeRange(startValue: 0, endValue: 50, color: Colors.red),
                GaugeRange(startValue: 50, endValue: 80, color: Colors.yellow),
                GaugeRange(startValue: 80, endValue: 100, color: Colors.green),
              ],
              pointers: [NeedlePointer(value: value)],
              annotations: [
                GaugeAnnotation(
                  widget: Text(
                    displayValue,
                    style: GoogleFonts.pacifico().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  angle: 90,
                  positionFactor: 0.7,
                ),
              ],
            ),
          ],
        ),
      ),
      Text(
        label,
        style: GoogleFonts.pacifico().copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}

  /// **Текстийг өнгөөр ялгах (эхлээд хар, шивэхэд өнгө солигдоно)**
 Widget _buildHighlightedText() {
  List<TextSpan> spans = [];
  List<String> sampleWords = sampleText.split(' ');
  List<String> typedWords = typedText.isNotEmpty ? typedText.split(' ') : [];

  for (int i = 0; i < sampleWords.length; i++) {
    Color color = Colors.black; // Эхлээд бүх үг хар

    if (i < typedWords.length) {
      if (typedWords[i] == sampleWords[i]) {
        color = Colors.green; // Зөв үг ногоон
      } else {
        color = Colors.red; // Буруу үг улаан
      }
    }

    spans.add(TextSpan(
      text: sampleWords[i] + " ",
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
    ));
  }

  // Шивэхээс өмнө бүх үгсийг хар өнгөтэй болгоно.
  if (typedWords.length < sampleWords.length) {
    spans.add(TextSpan(
      text: sampleWords.sublist(typedWords.length).join(" ") + " ",
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
    ));
  }

  return RichText(
    text: TextSpan(
      children: spans,
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              buildCircularGauge("Accuracy", accuracy.toDouble(), "$accuracy%", Colors.orange),
              buildCircularGauge("WPM", wpm.toDouble(), "$wpm", Colors.blue),
              buildCircularGauge("Errors", errors.toDouble(), "$errors", Colors.red),
              ],
            ),
            SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 5,
                  color: Colors.blue,
                ),
                Text(
                  formatTime(_timeLeft),
                  style: GoogleFonts.pacifico().copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            /// **Анхны текст нь хар, дараа нь өнгө нь өөрчлөгдөнө**
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildHighlightedText(),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              enabled: _isTypingEnabled, // Таймер дуусах үед шивэхийг зогсооно
              onChanged: (text) {
                if (text.length == 1) _startTimer();
                _updateTyping(text);
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Start typing...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
