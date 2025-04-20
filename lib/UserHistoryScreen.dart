import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/challenge_service.dart';
import 'services/auth_service.dart';
import 'AuthScreen.dart';

class UserHistoryScreen extends StatefulWidget {
  @override
  _UserHistoryScreenState createState() => _UserHistoryScreenState();
}

class _UserHistoryScreenState extends State<UserHistoryScreen> {
  final ChallengeService _challengeService = ChallengeService();
  List<Map<String, dynamic>> history = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadChallengeHistory();
  }

  Future<void> _loadChallengeHistory() async {
    try {
      final data = await _challengeService.getUserChallengeHistory();
      setState(() {
        history = data
            .map((attempt) => {
                  'name': attempt['username'] ?? 'Unknown',
                  'date': _formatDate(attempt['created_at']),
                  'duration':
                      '${(attempt['duration_seconds'] / 60).round()} Minutes',
                  'difficulty': attempt['challenge_difficulty'] ?? 'Unknown',
                  'rightWords': attempt['correct_word_count'].toString(),
                  'wrongWords': attempt['wrong_word_count'].toString(),
                  'image': 'assets/images/profile.jpg', // Default image
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown Date';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Future<void> _handleLogout() async {
    try {
      await AuthService.logout();
      // Navigate to login screen and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
  }

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
              padding: EdgeInsets.all(5),
              elevation: 3,
            ),
            child: Icon(Icons.arrow_back, color: Colors.purple, size: 20),
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
              onPressed: _handleLogout,
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              label: Text(
                'Logout',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Алдаа гарлаа',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadChallengeHistory,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : history.isEmpty
                  ? Center(
                      child: Text(
                        'Түүх олдсонгүй',
                        style: GoogleFonts.roboto(
                            fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final item = history[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserDetailsScreen(
                                  userName: item['name']!,
                                  allHistory: history,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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
                                      backgroundImage:
                                          AssetImage(item['image']!),
                                    ),
                                    title: Text(
                                      item['name']!,
                                      style: GoogleFonts.lobster(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(item['date']!,
                                        style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            color: Colors.black54)),
                                    trailing: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item['difficulty']!,
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: item['difficulty'] ==
                                                    'MEDIUM'
                                                ? Colors.orange
                                                : item['difficulty'] == 'EASY'
                                                    ? Colors.green
                                                    : Colors.blueAccent,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(item['duration']!,
                                            style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                color: Colors.black54)),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    childrenPadding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 6),
                                    title: Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            size: 16, color: Colors.deepPurple),
                                        SizedBox(width: 6),
                                        Text(
                                          'Details',
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ],
                                    ),
                                    iconColor: Colors.purple,
                                    collapsedIconColor: Colors.grey,
                                    initiallyExpanded: false,
                                    children: [
                                      _buildDetailRow('✅ Right Words',
                                          item['rightWords']!, Colors.green, 18,
                                          isNumber: true),
                                      _buildDetailRow('❌ Wrong Words',
                                          item['wrongWords']!, Colors.red, 18,
                                          isNumber: true),
                                      _buildDetailRow('📅 Date', item['date']!,
                                          Colors.black, 16),
                                      _buildDetailRow(
                                          '🎯 Test Mode',
                                          item['difficulty']!,
                                          Colors.black,
                                          16),
                                      _buildDetailRow('⏳ Test Duration',
                                          item['duration']!, Colors.black, 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, Color valueColor, double fontSize,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.lobster(
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
            padding: isNumber
                ? EdgeInsets.symmetric(horizontal: 12, vertical: 6)
                : null,
            child: Text(
              value,
              style: GoogleFonts.lobster(
                fontSize: isNumber ? 22 : fontSize,
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

class UserDetailsScreen extends StatelessWidget {
  final String userName;
  final List<Map<String, dynamic>> allHistory;

  UserDetailsScreen({required this.userName, required this.allHistory});

  @override
  Widget build(BuildContext context) {
    final easy = allHistory
        .where((e) => e['name'] == userName && e['difficulty'] == 'EASY')
        .toList();
    final medium = allHistory
        .where((e) => e['name'] == userName && e['difficulty'] == 'MEDIUM')
        .toList();
    final hard = allHistory
        .where((e) => e['name'] == userName && e['difficulty'] == 'HARD')
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('$userName\'s Tests',
              style: GoogleFonts.pacifico(fontSize: 24)),
          backgroundColor: Colors.purple,
          bottom: TabBar(
            tabs: [
              Tab(text: '🟢 Easy'),
              Tab(text: '🟠 Medium'),
              Tab(text: '🔵 Hard'),
            ],
            labelStyle: GoogleFonts.roboto(fontWeight: FontWeight.bold),
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(easy, Colors.green),
            _buildTabContent(medium, Colors.orange),
            _buildTabContent(hard, Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(List<Map<String, dynamic>> list, Color color) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          'No records found',
          style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 6,
          shadowColor: color.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(item['image']!),
                  ),
                  title: Text(
                    item['name']!,
                    style: GoogleFonts.lobster(fontSize: 20),
                  ),
                  subtitle: Text(item['date']!,
                      style: TextStyle(color: Colors.grey[600])),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['difficulty']!,
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold, color: color),
                      ),
                      SizedBox(height: 5),
                      Text(item['duration']!,
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Divider(),
                _buildDetailRow(
                    '✅ Right Words', item['rightWords']!, Colors.green),
                _buildDetailRow(
                    '❌ Wrong Words', item['wrongWords']!, Colors.red),
                _buildDetailRow('📅 Date', item['date']!, Colors.black),
                _buildDetailRow('⏳ Duration', item['duration']!, Colors.black),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: GoogleFonts.roboto(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
