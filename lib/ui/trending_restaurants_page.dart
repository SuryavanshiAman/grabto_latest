


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grabto/main.dart';

import '../model/store_model.dart';
import '../theme/theme.dart';
import 'coupon_fullview_screen.dart';

class TrendingRestruantWidget extends StatelessWidget {
  final List<StoreModel> restaurantsItems;

  TrendingRestruantWidget(this.restaurantsItems, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 290,
      height: heights*0.38,
      margin: EdgeInsets.symmetric(horizontal: 10),
      // color: Colors.red,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final store = restaurantsItems[index];
          return buildRestaurantsWidget(
              context,
              index,
              store.id,
              store.banner,
              // Use the logo property from StoreModel
              store.storeName,
              // Use the store_name property from StoreModel
              store.address,
              // Use the address property from StoreModel
              store.distance,
              // Use the distance property from StoreModel
              store.offers);
        },
        itemCount: restaurantsItems.length, // Use the length of the list
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget buildRestaurantsWidget(BuildContext context,int index, int id, String imgUrl,
      String restaurantName, String location, String distance, String offers) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1, vertical: 0),
      // Margins ko responsive banane ke liye adjust kiya gaya hai
      width: MediaQuery.of(context).size.width * 0.55,
      // width: 110,
      // Container ki width ko screen ke 90% par set kiya gaya hai
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CouponFullViewScreen("$id");
          }));
        },
        child: Card(
          color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: double.infinity,
                height: heights*0.38,
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
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
              SizedBox(height: 10),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    decoration: BoxDecoration(

                        image: DecorationImage(image: AssetImage("assets/images/book_mark.png"),fit: BoxFit.fill)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(17, 5, 17, 17),
                      child: Text((index+1).toString(),textAlign: TextAlign.center,style: TextStyle(color: MyColors.whiteBG),),
                    )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage("assets/images/grabto_logo_without_text.png"),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child:
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                        Colors.black
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: heights * 0.1,
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.fromLTRB(10, 0, 3, 25),
                child: Text(
                  restaurantName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: MyColors.whiteBG,
                    fontSize: 18,
                    fontFamily: 'wix',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 3, 3),
                  child: Text(
                    offers,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: MyColors.redBG,
                      fontSize: 18,
                      fontFamily: 'wix',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

}