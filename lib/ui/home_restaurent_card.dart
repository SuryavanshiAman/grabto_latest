



import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grabto/services/api_services.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/total_visit_screen.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../helper/shared_pref.dart';
import '../main.dart';
import '../model/filtered_data_model.dart';
import '../model/store_model.dart';
import '../model/user_model.dart';
import '../widget/rating.dart';
import 'coupon_fullview_screen.dart';

class HomeScreenRestaurantCard extends StatefulWidget {
  // final Restaurant restaurant;
  final int index;
  final String name;
  final Data filter;

  HomeScreenRestaurantCard(
      {required this.index, required this.name, required this.filter});

  @override
  State<HomeScreenRestaurantCard> createState() => _HomeScreenRestaurantCardState();
}

class _HomeScreenRestaurantCardState extends State<HomeScreenRestaurantCard> {
  List ambienceList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGalleryImagesAmbience("177", "ambience");
  }

  final CarouselSliderController _carouselController =
  CarouselSliderController();
  int _currentIndex = 0;
  int selectedIndex = -1;
  final List<String> avatars = [
    'assets/images/grabto_logo_with_text.png',
    'assets/images/grabto_logo.png',
    'assets/images/grabto_logo_with_text.png',
    'assets/images/grabto_logo_with_text.png',
    'assets/images/grabto_logo_with_text.png',
    'assets/images/grabto_logo_with_text.png',
  ];
  final int maxVisibleAvatars = 5;
  @override
  Widget build(BuildContext context) {
    final imageList = widget.filter.image ?? [];
    // List<dynamic> dishList = widget.filter.dish.split(',').where((e) => e.trim().isNotEmpty).map((e) => e.trim()).toList();
    // List<dynamic> dishList = (widget.filter.dish.toString()).split(',').map((e) => e.trim())
    //     .where((e) => e.isNotEmpty).toList();
    List<String> dishList = [];

    String? rawDish = widget.filter.dish?.toString();

    if (rawDish != null &&
        rawDish.trim().isNotEmpty &&
        rawDish.trim().toLowerCase() != 'null') {
      dishList = rawDish
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return widget.filter != "null"
        ? InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CouponFullViewScreen(widget.filter.id.toString());
        }));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          // color: MyColors.whiteBG,
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(10),
          // color: Colors.red
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with overlay
            Stack(
              children: [
                CarouselSlider(
                  items: widget.filter.image?.map((img) {
                    return GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: img.url??"",
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/placeholder.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.error)),
                        ),
                      ),
                    );
                  }).toList() ??
                      [],
                  carouselController:
                  _carouselController, // Use empty list if image is null
                  options: CarouselOptions(
                    height: heights * 0.27,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    reverse: true,
                    disableCenter: true,
                    aspectRatio: 1 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                    const Duration(milliseconds: 800),
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    children: [
                      widget.filter.availableSeat != null
                          ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: int.parse(widget
                              .filter.availableSeat) <=
                              5
                              ? MyColors.redBG
                              : MyColors.green,
                          // color:MyColors.green ,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "${widget.filter.availableSeat.toString() ?? ""} seat left",
                          style: TextStyle(
                              color: MyColors.whiteBG,
                              fontFamily: 'wix',fontWeight: FontWeight.w600,
                              fontSize: 11),
                        ),
                      )
                          : Container(),
                      // Spacer(),
                      SizedBox(
                        width: widths * 0.43,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        padding: const EdgeInsets.fromLTRB(6, 4, 8, 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "${widget.filter.avgRating.toStringAsFixed(1)}/5",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'wix',fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: MyColors.whiteBG,
                        child: InkWell(
                          onTap: () {
                            fetchStoresFullView(
                                widget.filter.id.toString());
                            wishlist(widget.filter.id.toString());
                          },
                          child: Icon(
                            wishlist_status == 'true'
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: wishlist_status == 'true'
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: _currentIndex,
                      count: imageList.length,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 6,
                        dotWidth: 6,
                        spacing: 6,
                        expansionFactor: 3,
                        activeDotColor: MyColors.whiteBG,
                        dotColor: Colors.white70,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // width: widths*0.3,

                        decoration: BoxDecoration(
                            color: MyColors.blackBG.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/local_cafe.png"),
                            const SizedBox(width: 5),
                            Text(
                              widget.filter.subCategoriesName,
                              style: const TextStyle(
                                fontFamily: 'wix',fontWeight: FontWeight.w600,
                                color: MyColors.whiteBG,
                                fontSize: 11,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          // Center align the text
                          text: TextSpan(
                            text:
                            "₹${widget.filter.amount}",
                            style: TextStyle(
                                fontFamily: 'wix',fontWeight: FontWeight.w600,
                                color: MyColors.whiteBG
                            ),
                            children: [
                              TextSpan(
                                text: "\n for two",
                                style: TextStyle(
                                    color: MyColors.whiteBG,
                                  fontSize: 11,
                                    fontFamily: 'wix',fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: widths * 0.58,
                        child: Text(
                          widget.filter.storeName.toString(),
                          style: TextStyle(
                              fontSize: 14,   fontFamily: 'wix',fontWeight: FontWeight.w600),
                        ),
                      ),
                      Spacer(),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 3, vertical: 1),
                      //   decoration: BoxDecoration(
                      //       border: Border.all(
                      //           color: Colors.grey.withOpacity(0.3)),
                      //       // color: Color(0xff00bd62),
                      //       borderRadius: BorderRadius.circular(3)),
                      //   child: StarRating(
                      //     color: Colors.yellow,
                      //     rating: double.parse(widget.filter.avgRating
                      //         .toStringAsFixed(1)
                      //         .toString()),
                      //     size: 14,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.filter.address.toString(),
                    style: TextStyle(
                        color: MyColors.textColorTwo, fontSize: 10,  fontFamily: 'wix',fontWeight: FontWeight.w600),
                  ),
                  Divider(
                    color: MyColors.textColorTwo.withAlpha(20),
                  ),
                  // widget.filter.dish != null
                  //     ? Text(
                  //   widget.filter.dish.toString(),
                  //   style: TextStyle(
                  //       color: MyColors.textColorTwo, fontSize: 14),
                  // )
                  //     : Container(),
                  dishList.isNotEmpty?SizedBox(
                      width: widths*0.8,
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: dishList.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          mainAxisExtent: 25,
                          // childAspectRatio:1.9
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final data = dishList[index];
                          return data=="null"?Container():Container(
                            padding:EdgeInsets.all(5),
                            // margin:EdgeInsets.all(5),
                            color:MyColors.textColorTwo.withAlpha(10),
                            child: Center(
                              child: Text(
                                data=="null"?"":data,
                                style: TextStyle(
                                    fontSize: 12,  fontFamily: 'wix',fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        },
                      )
                  ):Container(),
                  widget.filter.dish != null
                      ? Divider(
                    color: MyColors.textColorTwo.withAlpha(20),
                  )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 58.0),
                        child: Row(
                          children: <Widget>[
                            Stack(
                              children: [
                                // Show up to maxVisibleAvatars - 1 avatars
                                ...avatars.asMap().entries.map((entry) {
                                  int idx = entry.key;
                                  String avatar = entry.value;

                                  if (idx < maxVisibleAvatars - 1) {
                                    return Transform.translate(
                                      offset: Offset(idx * -20.0, 0),
                                      child: Container(
                                        width: widths * 0.06,
                                        height: heights * 0.05,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(avatar),
                                            fit: BoxFit.cover,
                                          ),
                                          border: Border.all(color: MyColors.whiteBG, width: 1),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                }).toList(),
                                if (avatars.length > maxVisibleAvatars)
                                  Transform.translate(
                                    offset: Offset((maxVisibleAvatars -5) * -12.0, 0),
                                    child: Container(
                                      width: widths * 0.06,
                                      height: heights * 0.05,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[400],
                                        border: Border.all(color: MyColors.whiteBG, width: 1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+${avatars.length - (maxVisibleAvatars - 1)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                              fontFamily: 'wix',fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                // // Optional: show the last visible avatars before `+remaining`
                                // if (avatars.length <= maxVisibleAvatars)
                                //   Transform.translate(
                                //     offset: Offset((avatars.length - 1) * -12.0, 0),
                                //     child: Container(
                                //       width: widths * 0.06,
                                //       height: heights * 0.05,
                                //       decoration: BoxDecoration(
                                //         shape: BoxShape.circle,
                                //         image: DecorationImage(
                                //           image: AssetImage(avatars.last),
                                //           fit: BoxFit.cover,
                                //         ),
                                //         border: Border.all(color: MyColors.whiteBG, width: 1),
                                //       ),
                                //     ),
                                //   ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MapProfileUI()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 2,horizontal: 5),

                              decoration: BoxDecoration(
                                  color:  MyColors.redBG.withAlpha(10),
                                borderRadius: BorderRadius.circular(2)
                              ),
                              child: Text("View >",style:TextStyle(color: MyColors.redBG,fontSize: 12),)))
                    ],
                  ),
                  Container(
                    width: widths,
                    padding:
                    EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    decoration: BoxDecoration(
                        color: Color(0xff00bd62),
                        borderRadius: BorderRadius.circular(3)),
                    child: Text(
                        widget.filter.offers != ""
                            ? "% Flat ${widget.filter.discountPercentage.toString()}% off on pre-booking       +${widget.filter.offers.toString()} offers"
                            : "% Flat ${widget.filter.discountPercentage.toString() ?? ""}% off on pre-booking",
                        style: TextStyle(
                          color: MyColors.whiteBG,
                          fontFamily: 'wix',fontWeight: FontWeight.w600,
                          fontSize: 12,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : Text("Nodata");
  }

  bool isLoading = true;

  Future<void> fetchGalleryImagesAmbience(
      String store_id, String food_type) async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = {"store_id": "$store_id", "food_type": "$food_type"};
      final response = await ApiServices.store_multiple_galleryJson(body);
      print("object: $response");
      if (response != null) {
        setState(() {
          ambienceList = response;

          print('fetchGalleryImagesAmbience: $response');
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('fetchGalleryImagesAmbience: $e');
    } finally {
      isLoading = false;
    }
  }

  String wishlist_status = '';
  StoreModel? store;

  Future<void> wishlist(String store_id) async {
    print("☕");
    try {
      UserModel n = await SharedPref.getUser();
      final body = {"user_id": n.id.toString(), "store_id": store_id};
      final response = await ApiServices.wishlist(body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final msg = response['msg'] as String;
        print("☕");
        setState(() {
          wishlist_status = response['wishlist_status'] as String;
          wishlist_status == "true"
              ? showSuccessMessage(context, message: msg)
              : showErrorMessage(context, message: msg);
        });
      } else if (response != null) {
        String msg = response['msg'];

        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      //print('verify_otp error: $e');
      // Handle error
      //showErrorMessage(context, message: 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchStoresFullView(String store_id) async {
    print("strollll:${store_id}");
    UserModel n = await SharedPref.getUser();
    try {
      final body = {
        "store_id": "$store_id",
        "user_id": "${n.id}",
      };
      final response = await ApiServices.api_store_fullview(body);

      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        print("Aman:$data");

        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          store = StoreModel.fromMap(data);
          setState(() {
            wishlist_status = store!.wishlistStatus;
          });

        } else {
        }
      } else if (response != null) {
        String msg = response['msg'];
      }
    } catch (e) {
    } finally {}
  }
}