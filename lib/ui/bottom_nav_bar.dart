import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 2;

  final List<IconData> _icons = [
    Icons.home,
    Icons.movie, // flicks
    Icons.receipt_long, // pay bill
    Icons.notifications, // bell
    Icons.person, // profile
  ];

  final List<String> _labels = [
    "Home",
    "Flicks",
    "Pay Bill",
    "Bell",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Page: ${_labels[_currentIndex]}")),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          // borderRadius: const BorderRadius.only(
          //   topLeft: Radius.circular(20),
          //   topRight: Radius.circular(20),
          // ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final isSelected = _currentIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red : Colors.transparent,
                      // borderRadius: BorderRadius.circular(16),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      // ),
                    )),
                    child: Icon(
                      _icons[index],
                      color: isSelected ? Colors.white : Colors.white70,
                      size: isSelected ? 28 : 24,
                    ),
                  ),
                  if (index == 4)
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/150?img=3",
                      ),
                    )
                  else
                    Text(
                      _labels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.red : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
