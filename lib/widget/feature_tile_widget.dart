import 'package:flutter/material.dart';

class FeatureTile extends StatelessWidget {
  final String title;
  final String image;

  FeatureTile({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.yellow,
      height: 100, // Set a fixed height for consistent grid items
      child: Column(
        children: [
          SizedBox(
            width: 22.22,
            height: 20,
            // color: Colors.red,
            child: Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                // Show error image if network image loading fails
                return Icon(Icons.error,size: 18,);
              },
            ),
          ),
          // SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}