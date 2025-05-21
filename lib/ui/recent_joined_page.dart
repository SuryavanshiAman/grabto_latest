



import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grabto/main.dart';

import '../model/store_model.dart';
import '../theme/theme.dart';
import 'coupon_fullview_screen.dart';

class RecentJoinedWidget extends StatelessWidget {
  final List<StoreModel> stores; // Renamed from restaurantsItems
  final String cityId;
  RecentJoinedWidget(this.stores, this.cityId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: heights * 0.4,
      color: Color(0xff1e1f16),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 15),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: heights * 0.02,
                  width: 2,
                  color: MyColors.redBG,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Recent Joinees",
                  style: TextStyle(
                      color: MyColors.whiteBG,
                      fontSize: 14,
                      fontFamily: 'wix',fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            height: heights * 0.33,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildStoreWidget(
                  context,
                  stores[index].id,
                  stores[index].banner,
                  // Accessing the logo field of StoreModel
                  stores[index].storeName,
                  // Accessing the store_name field of StoreModel
                  stores[index].address,
                  // Accessing the address field of StoreModel
                  stores[index].distance,
                  // Accessing the distance field of StoreModel
                  stores[index].offers,
                  stores[index].subcategoryName,
                );
              },
              itemCount: stores.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }


  Widget buildStoreWidget(
      BuildContext context,
      int id,
      String imgUrl,
      String storeName,
      String location,
      String distance,
      String offers,
      String categoryName) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CouponFullViewScreen("$id");
        }));
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.53,
            margin: EdgeInsets.fromLTRB(8, 8, 5, 8),
            // Adjust the height according to your requirement
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                topLeft: Radius.circular(100),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                topLeft: Radius.circular(100),
                // bottomRight: Radius.circular(15),
                // bottomLeft: Radius.circular(15),
              ),
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset(
                  'assets/images/vertical_placeholder.jpg',
                  // Path to your placeholder image asset
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                width: double.infinity,
                height: double.infinity,
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(bottom:heights*0.08),
            child: Text(
              categoryName,
              style: TextStyle(
                fontFamily: 'wix',fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(bottom:heights*0.043),
            child: Container(
              alignment: Alignment.center,
              height: heights * 0.03,
              width: widths * 0.4,
              decoration: BoxDecoration(
                  color: MyColors.whiteBG,
                  borderRadius: BorderRadius.circular(25)),
              child: Text(
                "Book Table",
                style: TextStyle(fontSize: 12,  fontFamily: 'wix',fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: MediaQuery.of(context).size.width * 0.53,
                height: heights * 0.03,
                // Adjust the width according to your requirement
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                      Colors.black
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    // bottomRight: Radius.circular(15),
                    // bottomLeft: Radius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 15),
            child: Text(
              offers,
              style: TextStyle(
                fontFamily: 'wix',fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}