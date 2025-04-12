import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/services/api_services.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:grabto/view_model/different_location_view_model.dart';
import 'package:grabto/widget/rating.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/store_model.dart';
import '../model/user_model.dart';
import 'coupon_fullview_screen.dart';

class DifferentLocationScreen extends StatefulWidget {
  final String name;
  const DifferentLocationScreen({super.key,required this.name});

  @override
  State<DifferentLocationScreen> createState() => _DifferentLocationScreenState();
}

class _DifferentLocationScreenState extends State<DifferentLocationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final nearBy=Provider.of<DifferentLocationViewModel>(context,listen: false).nearByList;
    fetchStoresFullView(nearBy.data?.data![0].id.toString()??"");
  }
  @override
  Widget build(BuildContext context) {
    final nearBy=Provider.of<DifferentLocationViewModel>(context).nearByList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.backgroundBg,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(
          "${widget.name}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount:  nearBy.data?.data?.length??0,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final data = nearBy.data?.data?[index];
          return
            nearBy.data?.data?.length==0?Container(): InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CouponFullViewScreen(data?.id.toString()??"");
                }));
              },
              child: Container(
                margin: EdgeInsets.all(8),
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
                        // CarouselSlider(
                        //   items: ambienceList.map((json) {
                        //     return GestureDetector(
                        //       child: ClipRRect(
                        //         borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10),
                        //             topRight: Radius.circular(10)),
                        //         child: CachedNetworkImage(
                        //           imageUrl: json['image'],
                        //           fit: BoxFit.fill,
                        //           placeholder: (context, url) => Image.asset(
                        //             'assets/images/placeholder.png',
                        //             fit: BoxFit.cover,
                        //             width: double.infinity,
                        //             height: double.infinity,
                        //           ),
                        //           errorWidget: (context, url, error) =>
                        //           const Center(child: Icon(Icons.error)),
                        //         ),
                        //       ),
                        //     );
                        //   }).toList(),
                        //   options: CarouselOptions(
                        //     height: heights * 0.22,
                        //     enlargeCenterPage: true,
                        //     autoPlay: true,
                        //     reverse: true,
                        //     disableCenter: true,
                        //     aspectRatio: 1 / 9,
                        //     autoPlayCurve: Curves.fastOutSlowIn,
                        //     enableInfiniteScroll: true,
                        //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        //     viewportFraction: 1,
                        //   ),
                        // ),
                        CarouselSlider(
                          items: data?.images?.map((img) {
                            return GestureDetector(
                              child: ClipRRect(
                                borderRadius:  BorderRadius.circular(10
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: img.url.toString(),
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
                          }).toList() ?? [], // Use empty list if image is null
                          options: CarouselOptions(
                            height: heights * 0.22,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            reverse: true,
                            disableCenter: true,
                            aspectRatio: 1 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            viewportFraction: 1,
                          ),
                        ),
                        data?.availableSeat!=null?   Positioned(
                          top: 10,
                          left: 10,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color:int.parse(data?.availableSeat) <=5?MyColors.redBG:MyColors.green ,
                                  // color:MyColors.green ,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "${data?.availableSeat.toString()??""} seat left",
                                  style: TextStyle(
                                      color: MyColors.whiteBG,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
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
                                  "${data?.avgRating.toStringAsFixed(1)}/5",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                              CircleAvatar(
                                radius: 12,
                                backgroundColor: MyColors.whiteBG,
                                child:InkWell(
                                  onTap: (){
                                    wishlist( data?.id.toString()??"");
                                  },
                                  child: Icon(
                                    wishlist_status == 'true'
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 16,
                                    color:
                                    wishlist_status == 'true' ? Colors.red : Colors.black,
                                  ),
                                ),
                                // InkWell(
                                //   onTap: (){
                                //     setState(() {
                                //       selectedIndex=widget.index;
                                //     });
                                //   },
                                //   child: Icon(
                                //     selectedIndex!=widget.index? Icons.favorite_border:Icons.favorite,
                                //     color: selectedIndex!=widget.index? MyColors.blackBG:MyColors.redBG,
                                //     size: 16,
                                //   ),
                                // )
                              )
                              // Icon(Icons.favorite_border, color: Colors.white),
                            ],
                          ),
                        ):Container(),
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Row(
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
                                      data?.subCategoriesName??"",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: MyColors.whiteBG,
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Positioned(
                        //   top: 10,
                        //   left: 10,
                        //   child: Row(
                        //     children: [
                        //       Container(
                        //         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        //         decoration: BoxDecoration(
                        //           color: MyColors.redBG,
                        //           borderRadius: BorderRadius.circular(5),
                        //         ),
                        //         child: Text(
                        //           "${data?.availableSeat ?? ""} seat left",
                        //           style: TextStyle(
                        //               color: MyColors.whiteBG,
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 12),
                        //         ),
                        //       ),
                        //       // Spacer(),
                        //       SizedBox(width: widths*0.43,),
                        //       Container(
                        //         margin: EdgeInsets.only(right: 8),
                        //         padding: const EdgeInsets.fromLTRB(6, 4, 8, 4),
                        //         decoration: BoxDecoration(
                        //           color: Colors.green,
                        //           borderRadius: BorderRadius.circular(5),
                        //         ),
                        //         child: Text(
                        //           "${data?.avgRating.toStringAsFixed(1)}/5",
                        //           style: const TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 12,
                        //           ),
                        //         ),
                        //       ),
                        //       CircleAvatar(
                        //           radius: 12,
                        //           backgroundColor: MyColors.whiteBG,
                        //           child: Icon(Icons.favorite_border, color: MyColors.blackBG,size: 16,))
                        //       // Icon(Icons.favorite_border, color: Colors.white),
                        //     ],
                        //   ),
                        // ),
                        // Positioned(
                        //   top: 10,
                        //   right: 10,
                        //   child: CircleAvatar(
                        //       radius: 12,
                        //       child: Icon(Icons.favorite_border, color: Colors.white,size: 16,)),
                        // ),
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
                                // color: Colors.red,
                                child: Text(
                                  data?.storeName,
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3, vertical: 1),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3)),
                            // color: Color(0xff00bd62),
                            borderRadius: BorderRadius.circular(3)),
                        child:  StarRating(color: Colors.yellow,rating: double.parse(data?.avgRating.toStringAsFixed(1).toString()??""),size: 20,),
                      ),
                              // CircleAvatar(
                              //     radius: 9,
                              //     backgroundColor: MyColors.darkGreen,
                              //     child: Icon(Icons.star,
                              //         color: MyColors.whiteBG, size: 12)),
                              // SizedBox(width: 4),
                              // Text(
                              //   widget.restaurant.rating.toString(),
                              //   style: TextStyle(
                              //       fontSize: 20,
                              //       fontWeight: FontWeight.bold,
                              //       color: MyColors.blackBG),
                              // ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            data?.address,
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          // Text(
                          //   "${widget.restaurant.cuisine} • ${widget.restaurant.price}",
                          //   style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          // ),
                          SizedBox(height: 6),
                          // Row(
                          //   children: [
                          //     Container(
                          //         padding: EdgeInsets.all(3),
                          //         decoration: BoxDecoration(
                          //           color: Colors.grey.withOpacity(0.3),
                          //           borderRadius: BorderRadius.circular(10),
                          //         ),
                          //         child: Row(
                          //           children: [
                          //             Icon(
                          //               Icons.calendar_month_outlined,
                          //               color: Colors.grey[600],
                          //               size: 12,
                          //             ),
                          //             SizedBox(width: 6),
                          //             Text(
                          //               "Table Booking",
                          //               style: TextStyle(
                          //                   fontSize: 12,
                          //                   color: Colors.black.withOpacity(0.5)),
                          //             ),
                          //           ],
                          //         )),
                          //   ],
                          // ),
                          Divider(),
                        Container(
                        width: widths,
                        padding:
                        EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                        decoration: BoxDecoration(
                        color: Color(0xff00bd62),
                        borderRadius: BorderRadius.circular(3)),
                        child: Text(
                        data?.offers!=""? "% Flat ${data?.discountPercentage.toString()}% off on pre-booking       +${data?.offers.toString()} offers":
                        "% Flat ${data?.discountPercentage.toString()??""}% off on pre-booking",
                        style: TextStyle(
                        color: MyColors.whiteBG,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        )),
                        ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
  StoreModel? store;
  String wishlist_status = '';
  Future<void> fetchStoresFullView(String store_id,) async {
    try {
      UserModel n = await SharedPref.getUser();
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
        print("🫠🫠:$data");

        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {

          store = StoreModel.fromMap(data);

          setState(() {
            wishlist_status = store!.wishlistStatus;
          });

          print("storeA,man: ${store!.wishlistStatus}");
        } else {
          // Handle invalid response data format
          // showErrorMessage(context, message: 'Invalid response data format');
        }

      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
        // showErrorMessage(context, message: msg);
      }
    } catch (e) {
      //print('verify_otp error: $e');
      // Handle error
      //showErrorMessage(context, message: 'An error occurred: $e');
    } finally {}
  }
  Future<void> wishlist( String store_id) async {
    print("OOOOOOOOOOOO");
    print(store_id);
    UserModel n = await SharedPref.getUser();
    print( n.id);
    try {
      final body = {"user_id": n.id.toString(), "store_id": store_id};
      final response = await ApiServices.wishlist(body);

      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final msg = response['msg'] as String;

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
      print('verify_otp error: $e');
      // Handle error
      showErrorMessage(context, message: 'An error occurred: $e');
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }
}
