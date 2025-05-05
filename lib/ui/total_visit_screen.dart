import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';

class MapProfileUI extends StatelessWidget {
  final List<Map<String, dynamic>> profiles = [
    {'offset': Offset(30, 80), 'status': false},
    {'offset': Offset(140, 53), 'status': true},
    {'offset': Offset(260, 80), 'status': false},
    {'offset': Offset(40, 193), 'status': true},
    {'offset': Offset(150, 180), 'status': false},
    {'offset': Offset(260, 193), 'status': true},
    {'offset': Offset(100, 310), 'status': true},
    {'offset': Offset(200, 310), 'status': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: MyColors.whiteBG,
        title: Text("See Who's Going",style: TextStyle(fontSize: 18),),
      ),
      body: Stack(
        children: [
          // Background map dots (could be an image)
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/images/map.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Profile bubbles
          ...profiles.map((profile) {
            return Positioned(
              left: profile['offset'].dx,
              top: profile['offset'].dy,
              child: _buildProfileBubble(profile['status']),
            );
          }).toList(),

          // Bottom profile
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 33),
              height: 160,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // color: Color(0xfffffaf9),
                color:  Colors.white60,
                // borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  _buildProfileBubble(true, radius: 35),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Michelle Dam',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.verified, color: Colors.blue, size: 18),
                          ],
                        ),
                        Text(
                          '@michelle_dam1234',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Container(
                          width: widths*0.5,
                          decoration: BoxDecoration(
                            color: MyColors.whiteBG,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: MyColors.textColorTwo.withAlpha(20)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.yellow,
                                child: Text("👑",style: TextStyle(color: Colors.white,fontSize: 10),),
                              ),
                              Text("Unlock Profile"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ElevatedButton.icon(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.lock_open),
                  //   label: const Text("Unlock Profile"),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.amber[600],
                  //     foregroundColor: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        height: heights*0.08,
        width: widths,
        color: Colors.black,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: widths*0.8,
            height: heights*0.05,
            padding: EdgeInsets.symmetric(horizontal: 24,vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color:Colors.white10
            ),
            child: Text("1,080 people visited this month",style: TextStyle(color: MyColors.whiteBG),),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileBubble(bool isOnline, {double radius = 30}) {
    return badges.Badge(
      position: badges.BadgePosition.bottomEnd(bottom: 0, end: 0),
      badgeStyle: badges.BadgeStyle(
        badgeColor: isOnline ? Colors.green : Colors.red,
        shape: badges.BadgeShape.circle,
        padding: EdgeInsets.all(6),
      ),
      child: ClipOval(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust blur level
          child: Image.asset(
            'assets/images/grabto_logo_with_text.png',
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

}
