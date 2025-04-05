import 'package:cached_network_image/cached_network_image.dart';
import 'package:grabto/main.dart';
import 'package:grabto/model/menu_model.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/full_screen_gallery.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final List<MenuModel> menuList;

  MenuWidget(this.menuList);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8,0,8,12),
      height: 210,
      color: Color(0xff1e1f16),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final menu = menuList[index];
          return GestureDetector(
            onTap: () {
              _showImageFullScreen(context, index);
            },
            child: Container(
              width: widths*0.45,
              margin: EdgeInsets.only(left: 10),
              child: buildMenuWidget(context,
                  menu.image), // Access 'image' property from MenuModel
            ),
          );
        },
        itemCount: menuList.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget buildMenuWidget(BuildContext context, String menuUrl) {
    final width = MediaQuery.of(context).size.width * 0.33;
    final height = width * 25; // Adjust as needed
    return Container(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        // Rounded corners with radius 10
        child: CachedNetworkImage(
          imageUrl: menuUrl,
          fit: BoxFit.fill,
          placeholder: (context, url) => Image.asset(
            'assets/images/vertical_placeholder.jpg',
            // Path to your placeholder image asset
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          errorWidget: (context, url, error) =>
              Center(child: Icon(Icons.error)),
        ),
      ),
    );
  }

  void _showImageFullScreen(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenGallery(
          images: menuList.map((menu) => menu.image).toList(),
          // Access 'image' property from MenuModel
          initialIndex: index,
        ),
      ),
    );
  }
}
