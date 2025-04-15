// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class UserHistoryScreen extends StatelessWidget {
//   final List<Map<String, String>> history = [
//     {'name': 'Johny', 'date': '06-04-2025', 'duration': '5 Seconds', 'difficulty': 'Hard', 'rightWords': '37', 'wrongWords': '7', 'image': 'assets/images/profile.jpg'},
//     {'name': 'Johny', 'date': '07-04-2025', 'duration': '4 Seconds', 'difficulty': 'Medium', 'rightWords': '28', 'wrongWords': '5', 'image': 'assets/images/profile.jpg'},
//     {'name': 'Johny', 'date': '08-04-2025', 'duration': '6 Seconds', 'difficulty': 'Easy', 'rightWords': '32', 'wrongWords': '4', 'image': 'assets/images/profile.jpg'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 10),
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               shape: CircleBorder(),
//               padding: EdgeInsets.all(5),
//               elevation: 3,
//             ),
//             child: Icon(Icons.arrow_back, color: Colors.purple, size: 20),
//           ),
//         ),
//         title: Center(
//           child: Text(
//             'Test History',
//             style: GoogleFonts.pacifico(
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               shadows: [Shadow(color: Colors.redAccent, blurRadius: 10)],
//             ),
//           ),
//         ),
//         backgroundColor: Colors.purple,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(Icons.exit_to_app, color: Colors.white),
//               label: Text(
//                 'Logout',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: history.length,
//         itemBuilder: (context, index) {
//           final item = history[index];
//           return Card(
//             margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             elevation: 5,
//             shadowColor: Colors.teal.withOpacity(0.4),
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ListTile(
//                     leading: CircleAvatar(
//                       radius: 30,
//                       backgroundImage: AssetImage(item['image']!),
//                     ),
//                     title: Text(
//                       item['name']!,
//                       style: GoogleFonts.lobster(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                     subtitle: Text(item['date']!, style: GoogleFonts.roboto(fontSize: 14, color: Colors.black54)),
//                     trailing: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           item['difficulty']!,
//                           style: GoogleFonts.roboto(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: item['difficulty'] == 'Medium'
//                                 ? Colors.orange
//                                 : item['difficulty'] == 'Easy'
//                                     ? Colors.green
//                                     : Colors.blueAccent,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(item['duration']!, style: GoogleFonts.roboto(fontSize: 14, color: Colors.black54)),
//                       ],
//                     ),
//                   ),
//                   Divider(),
//                   ExpansionTile(
//                     tilePadding: EdgeInsets.zero,
//                     childrenPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
//                     title: Row(
//                       children: [
//                         Icon(Icons.info_outline, size: 16, color: Colors.deepPurple),
//                         SizedBox(width: 6),
//                         Text(
//                           'Details',
//                           style: GoogleFonts.roboto(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.deepPurple,
//                           ),
//                         ),
//                       ],
//                     ),
//                     iconColor: Colors.purple,
//                     collapsedIconColor: Colors.grey,
//                     initiallyExpanded: false,
//                     children: [
//                       _buildDetailRow('✅ Right Words', item['rightWords']!, Colors.green, 18, isNumber: true),
//                       _buildDetailRow('❌ Wrong Words', item['wrongWords']!, Colors.red, 18, isNumber: true),
//                       _buildDetailRow('📅 Date', item['date']!, Colors.black, 16),
//                       _buildDetailRow('🎯 Test Mode', item['difficulty']!, Colors.black, 16),
//                       _buildDetailRow('⏳ Test Duration', item['duration']!, Colors.black, 16),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, Color valueColor, double fontSize, {bool isNumber = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.lobster(
//               fontWeight: FontWeight.bold,
//               fontSize: fontSize,
//               color: Colors.deepPurple,
//             ),
//           ),
//           Container(
//             decoration: isNumber
//                 ? BoxDecoration(
//                     color: valueColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   )
//                 : null,
//             padding: isNumber ? EdgeInsets.symmetric(horizontal: 12, vertical: 6) : null,
//             child: Text(
//               value,
//               style: GoogleFonts.lobster(
//                 fontSize: isNumber ? 22 : fontSize,
//                 fontWeight: isNumber ? FontWeight.bold : FontWeight.w500,
//                 color: valueColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: UserHistoryScreen(),
//   ));
// }
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() {
//   runApp(MaterialApp(home: UserHistoryScreen()));
// }

// class UserHistoryScreen extends StatelessWidget {
//   final List<Map<String, String>> history = [
//     {
//       'name': 'Johny',
//       'date': '06-04-2025',
//       'duration': '5 Seconds',
//       'difficulty': 'Hard',
//       'rightWords': '37',
//       'wrongWords': '7',
//       'image': 'assets/images/profile.jpg'
//     },
//     {
//       'name': 'Johny',
//       'date': '07-04-2025',
//       'duration': '4 Seconds',
//       'difficulty': 'Medium',
//       'rightWords': '28',
//       'wrongWords': '5',
//       'image': 'assets/images/profile.jpg'
//     },
//     {
//       'name': 'Johny',
//       'date': '08-04-2025',
//       'duration': '6 Seconds',
//       'difficulty': 'Easy',
//       'rightWords': '32',
//       'wrongWords': '4',
//       'image': 'assets/images/profile.jpg'
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 10),
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               shape: CircleBorder(),
//               padding: EdgeInsets.all(5),
//               elevation: 3,
//             ),
//             child: Icon(Icons.arrow_back, color: Colors.purple, size: 20),
//           ),
//         ),
//         title: Center(
//           child: Text(
//             'Test History',
//             style: GoogleFonts.pacifico(
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               shadows: [Shadow(color: Colors.redAccent, blurRadius: 10)],
//             ),
//           ),
//         ),
//         backgroundColor: Colors.purple,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(Icons.exit_to_app, color: Colors.white),
//               label: Text(
//                 'Logout',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: history.length,
//         itemBuilder: (context, index) {
//           final item = history[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => UserDetailsScreen(
//                     userName: item['name']!,
//                     allHistory: history,
//                   ),
//                 ),
//               );
//             },
//             child: Card(
//               margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               elevation: 5,
//               shadowColor: Colors.teal.withOpacity(0.4),
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ListTile(
//                       leading: CircleAvatar(
//                         radius: 30,
//                         backgroundImage: AssetImage(item['image']!),
//                       ),
//                       title: Text(
//                         item['name']!,
//                         style: GoogleFonts.lobster(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Colors.black,
//                         ),
//                       ),
//                       subtitle: Text(item['date']!, style: GoogleFonts.roboto(fontSize: 14, color: Colors.black54)),
//                       trailing: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             item['difficulty']!,
//                             style: GoogleFonts.roboto(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               color: item['difficulty'] == 'Medium'
//                                   ? Colors.orange
//                                   : item['difficulty'] == 'Easy'
//                                       ? Colors.green
//                                       : Colors.blueAccent,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(item['duration']!, style: GoogleFonts.roboto(fontSize: 14, color: Colors.black54)),
//                         ],
//                       ),
//                     ),
//                     Divider(),
//                     ExpansionTile(
//                       tilePadding: EdgeInsets.zero,
//                       childrenPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
//                       title: Row(
//                         children: [
//                           Icon(Icons.info_outline, size: 16, color: Colors.deepPurple),
//                           SizedBox(width: 6),
//                           Text(
//                             'Details',
//                             style: GoogleFonts.roboto(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.deepPurple,
//                             ),
//                           ),
//                         ],
//                       ),
//                       iconColor: Colors.purple,
//                       collapsedIconColor: Colors.grey,
//                       initiallyExpanded: false,
//                       children: [
//                         _buildDetailRow('✅ Right Words', item['rightWords']!, Colors.green, 18, isNumber: true),
//                         _buildDetailRow('❌ Wrong Words', item['wrongWords']!, Colors.red, 18, isNumber: true),
//                         _buildDetailRow('📅 Date', item['date']!, Colors.black, 16),
//                         _buildDetailRow('🎯 Test Mode', item['difficulty']!, Colors.black, 16),
//                         _buildDetailRow('⏳ Test Duration', item['duration']!, Colors.black, 16),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, Color valueColor, double fontSize, {bool isNumber = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.lobster(
//               fontWeight: FontWeight.bold,
//               fontSize: fontSize,
//               color: Colors.deepPurple,
//             ),
//           ),
//           Container(
//             decoration: isNumber
//                 ? BoxDecoration(
//                     color: valueColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   )
//                 : null,
//             padding: isNumber ? EdgeInsets.symmetric(horizontal: 12, vertical: 6) : null,
//             child: Text(
//               value,
//               style: GoogleFonts.lobster(
//                 fontSize: isNumber ? 22 : fontSize,
//                 fontWeight: isNumber ? FontWeight.bold : FontWeight.w500,
//                 color: valueColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class UserDetailsScreen extends StatelessWidget {
//   final String userName;
//   final List<Map<String, String>> allHistory;

//   UserDetailsScreen({required this.userName, required this.allHistory});

//   @override
//   Widget build(BuildContext context) {
//     final easy = allHistory.where((e) => e['name'] == userName && e['difficulty'] == 'Easy').toList();
//     final medium = allHistory.where((e) => e['name'] == userName && e['difficulty'] == 'Medium').toList();
//     final hard = allHistory.where((e) => e['name'] == userName && e['difficulty'] == 'Hard').toList();

//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('$userName\'s Tests', style: GoogleFonts.pacifico(fontSize: 24)),
//           backgroundColor: Colors.purple,
//           bottom: TabBar(
//             tabs: [
//               Tab(text: '🟢 Easy'),
//               Tab(text: '🟠 Medium'),
//               Tab(text: '🔵 Hard'),
//             ],
//             labelStyle: GoogleFonts.roboto(fontWeight: FontWeight.bold),
//             indicatorColor: Colors.white,
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildTabContent(easy, Colors.green),
//             _buildTabContent(medium, Colors.orange),
//             _buildTabContent(hard, Colors.blueAccent),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTabContent(List<Map<String, String>> list, Color color) {
//     if (list.isEmpty) {
//       return Center(
//         child: Text(
//           'No records found',
//           style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: list.length,
//       itemBuilder: (context, index) {
//         final item = list[index];
//         return Card(
//           margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//           elevation: 6,
//           shadowColor: color.withOpacity(0.3),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: CircleAvatar(
//                     radius: 28,
//                     backgroundImage: AssetImage(item['image']!),
//                   ),
//                   title: Text(
//                     item['name']!,
//                     style: GoogleFonts.lobster(fontSize: 20),
//                   ),
//                   subtitle: Text(item['date']!, style: TextStyle(color: Colors.grey[600])),
//                   trailing: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         item['difficulty']!,
//                         style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: color),
//                       ),
//                       SizedBox(height: 5),
//                       Text(item['duration']!, style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                 ),
//                 Divider(),
//                 _buildDetailRow('✅ Right Words', item['rightWords']!, Colors.green),
//                 _buildDetailRow('❌ Wrong Words', item['wrongWords']!, Colors.red),
//                 _buildDetailRow('📅 Date', item['date']!, Colors.black),
//                 _buildDetailRow('⏳ Duration', item['duration']!, Colors.black),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDetailRow(String label, String value, Color color) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.deepPurple)),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               value,
//               style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold, color: color),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(home: UserHistoryScreen()));
}

class UserHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> history = [
    {
      'name': 'Johny',
      'date': '06-04-2025',
      'duration': '5 Seconds',
      'difficulty': 'Hard',
      'rightWords': '37',
      'wrongWords': '7',
      'image': 'assets/images/profile.jpg'
    },
    {
      'name': 'Johny',
      'date': '07-04-2025',
      'duration': '4 Seconds',
      'difficulty': 'Medium',
      'rightWords': '28',
      'wrongWords': '5',
      'image': 'assets/images/profile.jpg'
    },
    {
      'name': 'Johny',
      'date': '08-04-2025',
      'duration': '6 Seconds',
      'difficulty': 'Easy',
      'rightWords': '32',
      'wrongWords': '4',
      'image': 'assets/images/profile.jpg'
    },
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
                              color: item['difficulty'] == 'Medium'
                                  ? Colors.orange
                                  : item['difficulty'] == 'Easy'
                                      ? Colors.green
                                      : Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(item['duration']!, style: GoogleFonts.roboto(fontSize: 14, color: Colors.black54)),
                        ],
                      ),
                    ),
                    Divider(),
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                      title: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.deepPurple),
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
                        _buildDetailRow('✅ Right Words', item['rightWords']!, Colors.green, 18, isNumber: true),
                        _buildDetailRow('❌ Wrong Words', item['wrongWords']!, Colors.red, 18, isNumber: true),
                        _buildDetailRow('📅 Date', item['date']!, Colors.black, 16),
                        _buildDetailRow('🎯 Test Mode', item['difficulty']!, Colors.black, 16),
                        _buildDetailRow('⏳ Test Duration', item['duration']!, Colors.black, 16),
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

  Widget _buildDetailRow(String label, String value, Color valueColor, double fontSize, {bool isNumber = false}) {
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
            padding: isNumber ? EdgeInsets.symmetric(horizontal: 12, vertical: 6) : null,
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
  final List<Map<String, String>> allHistory;

  UserDetailsScreen({required this.userName, required this.allHistory});

  @override
  Widget build(BuildContext context) {
    final easy = allHistory.where((e) => e['name'] == userName && e['difficulty'] == 'Easy').toList();
    final medium = allHistory.where((e) => e['name'] == userName && e['difficulty'] == 'Medium').toList();
    final hard = allHistory.where((e) => e['name'] == userName && e['difficulty'] == 'Hard').toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('$userName\'s Tests', style: GoogleFonts.pacifico(fontSize: 24)),
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

  Widget _buildTabContent(List<Map<String, String>> list, Color color) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                  subtitle: Text(item['date']!, style: TextStyle(color: Colors.grey[600])),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['difficulty']!,
                        style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: color),
                      ),
                      SizedBox(height: 5),
                      Text(item['duration']!, style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Divider(),
                _buildDetailRow('✅ Right Words', item['rightWords']!, Colors.green),
                _buildDetailRow('❌ Wrong Words', item['wrongWords']!, Colors.red),
                _buildDetailRow('📅 Date', item['date']!, Colors.black),
                _buildDetailRow('🎯 Test Mode', item['difficulty']!, Colors.black),
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
          Text(label, style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.deepPurple)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
