import 'package:flutter/material.dart';
import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'include.dart';

class SpeedTypingScreen extends StatefulWidget {
  final String langCode;
  final String level;
  final int minutes;

  const SpeedTypingScreen({
    Key? key,
    required this.langCode,
    required this.level,
    required this.minutes,
  }) : super(key: key);

  @override
  _SpeedTypingScreenState createState() => _SpeedTypingScreenState();
}

class _SpeedTypingScreenState extends State<SpeedTypingScreen> {
  Timer? _timer;
  int _timeLeft = 60;
  double _progress = 1.0;
  String sampleText = "Loading..."; // Default text while loading
  String typedText = "";
  int wpm = 0, errors = 0, accuracy = 0;
  final TextEditingController _controller = TextEditingController();
  bool _isTypingEnabled = true; // Таймер дуусах хүртэл шивэхийг идэвхжүүлнэ
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.minutes * 60; // Convert minutes to seconds
    _progress = 1.0;
    _fetchChallenge();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchChallenge() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${baseurl}text/challenge/?lang_code=${widget.langCode}&level=${widget.level}&minutes=${widget.minutes}'),
        headers: {
          'Accept-Charset': 'utf-8',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(
            utf8.decode(response.bodyBytes)); // Properly decode UTF-8 response
        setState(() {
          sampleText = data['content'];
          _isLoading = false;
        });
      } else {
        setState(() {
          sampleText = "Error loading challenge. Please try again.";
          _isLoading = false;
        });
        print('Failed to load challenge: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        sampleText = "Error loading challenge. Please check your connection.";
        _isLoading = false;
      });
      print('Error fetching challenge: $e');
    }
  }

  void _startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return; // Check if widget is still mounted
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

      wpm = (_timeLeft < 60 && correctWords > 0)
          ? (correctWords * (60 ~/ (60 - _timeLeft))).clamp(0, 200)
          : 0;
      accuracy = (typedWords.isNotEmpty)
          ? ((correctWords / typedWords.length) * 100).toInt().clamp(0, 100)
          : 0;
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  Widget buildCircularGauge(
      String label, double value, String displayValue, Color color) {
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
                  GaugeRange(
                      startValue: 50, endValue: 80, color: Colors.yellow),
                  GaugeRange(
                      startValue: 80, endValue: 100, color: Colors.green),
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
      Color color = Colors.black;

      if (i < typedWords.length) {
        if (typedWords[i] == sampleWords[i]) {
          color = Colors.green;
        } else {
          color = Colors.red;
        }
      }

      spans.add(TextSpan(
        text: sampleWords[i] + " ",
        style: GoogleFonts.roboto(
          // Changed to Roboto which has good Cyrillic support
          color: color,
          fontWeight: FontWeight.normal,
          fontSize: 18,
          height: 1.5,
        ),
      ));
    }

    return SelectableText.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.left,
      style: GoogleFonts.roboto(
        // Consistent font
        fontSize: 18,
        height: 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Speed Typing Challenge',
          style: GoogleFonts.pacifico(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              ),
              child: Column(
                children: [
                  if (_isLoading)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Loading challenge...',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildCircularGauge("Accuracy", accuracy.toDouble(),
                                "$accuracy%", Colors.orange),
                            buildCircularGauge(
                                "WPM", wpm.toDouble(), "$wpm", Colors.blue),
                            buildCircularGauge("Errors", errors.toDouble(),
                                "$errors", Colors.red),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: _buildHighlightedText(),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _controller,
                          enabled: _isTypingEnabled && !_isLoading,
                          onChanged: (value) {
                            _startTimer();
                            _updateTyping(value);
                          },
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Start typing here...',
                            hintStyle: GoogleFonts.roboto(
                              color: Colors.grey[400],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
