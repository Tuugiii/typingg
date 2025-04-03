import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Google Fonts импортлох

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StatisticsScreen(),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // Буцах товчийг нуух
        title: Text(
          'Statistics',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
            shadows: [
              Shadow(color: Colors.purpleAccent, blurRadius: 10), // Тень нэмсэн
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              _buildHighScoreCard(),
              const SizedBox(height: 16),
              _buildStatsCard('WPM', '51', [51, 50, 52], Colors.deepPurple),
              const SizedBox(height: 16),
              _buildStatsCard('Accuracy', '94%', [93, 100, 89], Colors.blue),
              const SizedBox(height: 16),
              _buildStatsCard('Correct Keystrokes', '295', [310, 250, 295], Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighScoreCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 8),
                Text('High Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Text('52 WPM', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, List<int> values, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Last 3 tests', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 8),
            ...values.map((v) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                width: double.infinity,
                height: 10,
                child: LinearProgressIndicator(
                  value: v / 100,
                  backgroundColor: color.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            )),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
