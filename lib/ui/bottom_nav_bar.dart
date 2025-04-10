import 'package:flutter/material.dart';
import 'package:grabto/theme/theme.dart';

class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 2;

  final List<String> _image = [
    "assets/images/home_app_logo.png",
    "assets/images/Menu Icons.png",
    "assets/images/add_card.png",
    "assets/images/travel_explore.png",
    "assets/images/home_app_logo.png",
  ];

  final List<String> _labels = [
    "Home",
    "Explore",
    "Pay Bill",
    "Flicks",
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
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_image.length, (index) {
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
                    child: Image(image: AssetImage(_image[index],),color:  isSelected ? MyColors.redBG : Colors.white70,)
                    // Icon(
                    //   _icons[index],
                    //   color: isSelected ? Colors.white : Colors.white70,
                    //   size: isSelected ? 28 : 24,
                    // ),
                  ),
                  // if (index == 4)
                  //   CircleAvatar(
                  //     radius: 12,
                  //     backgroundImage: NetworkImage(
                  //       "https://i.pravatar.cc/150?img=3",
                  //     ),
                  //   )
                  // else
                    Text(
                      _labels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.red : Colors.white70,
                        fontSize: 12,
                      ),)
                  //   ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
