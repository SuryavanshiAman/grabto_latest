import 'package:flutter/material.dart';

class FeatureTile extends StatelessWidget {
  final String title;
  final String image;
  FeatureTile({required this.title, required this.image});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Container(
            width: 22.22,
            height: 23,
            child: Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Icon(Icons.error,size: 18,);
              },
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12,fontFamily: 'wix',fontWeight: FontWeight.w600,),
          ),
        ],
      ),
    );
  }
}