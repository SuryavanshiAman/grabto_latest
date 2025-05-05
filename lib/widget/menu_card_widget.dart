import 'package:cached_network_image/cached_network_image.dart';
import 'package:grabto/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:grabto/view_model/menu_type_view_model.dart';
import 'package:provider/provider.dart';

import '../model/menu_data_model.dart';

class MenuWidget extends StatelessWidget {
  final MenuDataModel? menuData;
  final int storeId;

  MenuWidget(this.menuData,this.storeId);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8,0,8,12),
      height: 210,
      color: Color(0xff1e1f16),
      child: ListView.builder(
        itemCount: menuData?.data?.length??0,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final menu = menuData?.data?[index];
          return GestureDetector(
            onTap: () {
              index==0?Provider.of<MenuTypeViewModel>(context,listen: false).menuTypeApi(context, storeId,"1"):
              Provider.of<MenuTypeViewModel>(context,listen: false).menuTypeApi(context, storeId,"2");
            },
            child: buildMenuWidget(context,menu),
          );
        },

      ),
    );
  }

  Widget buildMenuWidget(BuildContext context,Data? menuUrl) {
    final width = MediaQuery.of(context).size.width * 0.33;
    final height = width * 25; // Adjust as needed
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [

        Container(
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            // Rounded corners with radius 10
            child: CachedNetworkImage(
              imageUrl: menuUrl?.image??"",
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
        ),
        Container( width: width,
          height: height,
          color: Colors.black26,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Text(menuUrl?.menuType??"",style: TextStyle(color: MyColors.whiteBG,fontWeight: FontWeight.w500),),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text("${menuUrl?.status??" "} pages",style: TextStyle(color: MyColors.whiteBG,fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  // void _showImageFullScreen(BuildContext context, int index) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => FullScreenGallery(
  //         images: menuData?.map((menu) => menu.image).toList(),
  //         // Access 'image' property from MenuModel
  //         initialIndex: index,
  //       ),
  //     ),
  //   );
  // }
}
