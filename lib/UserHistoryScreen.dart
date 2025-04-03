import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> history = [
    {'name': 'Emy', 'date': '20-10-2025', 'duration': '30 Seconds', 'difficulty': 'Hard', 'rightWords': '37', 'wrongWords': '7', 'image': 'assets/images/profile.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: CircleBorder(),
              padding: EdgeInsets.all(5), // Reduced size
              elevation: 3,
            ),
            child: Icon(Icons.arrow_back, color: Colors.purple, size: 20), // Smaller icon
          ),
        ),
        title: Center(
          child: Text(
            'Test History',
            style: GoogleFonts.pacifico(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(color: Colors.redAccent, blurRadius: 10)],
            ),
          ),
        ),
        backgroundColor: Colors.purple,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            shadowColor: Colors.teal.withOpacity(0.4),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(item['image']!),
                    ),
                    title: Text(
                      item['name']!,
                      style: GoogleFonts.lobster(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(item['date']!, style: GoogleFonts.roboto(fontSize: 14, color: Colors.black54)),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['difficulty']!,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(item['duration']!, style: GoogleFonts.roboto(fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  ),
                  Divider(),
                  _buildDetailRow('✅ Right Words', item['rightWords']!, Colors.green, 20, isNumber: true),
                  _buildDetailRow('❌ Wrong Words', item['wrongWords']!, Colors.red, 20, isNumber: true),
                  _buildDetailRow('📅 Date', item['date']!, Colors.black, 18),
                  _buildDetailRow('🎯 Test Mode', item['difficulty']!, Colors.black, 18),
                  _buildDetailRow('⏳ Test Duration', item['duration']!, Colors.black, 18),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor, double fontSize, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.lobster(  // Apply Lobster font to the labels
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: Colors.deepPurple,
            ),
          ),
          Container(
            decoration: isNumber
                ? BoxDecoration(
                    color: valueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  )
                : null,
            padding: isNumber ? EdgeInsets.symmetric(horizontal: 12, vertical: 6) : null,
            child: Text(
              value,
              style: GoogleFonts.lobster(  // Apply Lobster font to these values as well
                fontSize: isNumber ? 24 : fontSize,  // Larger size for numbers
                fontWeight: isNumber ? FontWeight.bold : FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserHistoryScreen(),
  ));
}
