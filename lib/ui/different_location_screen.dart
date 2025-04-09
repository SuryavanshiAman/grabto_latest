import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/view_model/different_location_view_model.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class DifferentLocationScreen extends StatefulWidget {
  final String name;
  const DifferentLocationScreen({super.key,required this.name});

  @override
  State<DifferentLocationScreen> createState() => _DifferentLocationScreenState();
}

class _DifferentLocationScreenState extends State<DifferentLocationScreen> {
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
          "" + widget.name,
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
            nearBy.data?.data?.length==0?Container(): Container(
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
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
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
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: MyColors.redBG,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "${data?.availableSeat ?? ""} seat left",
                                style: TextStyle(
                                    color: MyColors.whiteBG,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                            // Spacer(),
                            SizedBox(width: widths*0.43,),
                            Container(
                              margin: EdgeInsets.only(right: 8),
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
                                child: Icon(Icons.favorite_border, color: MyColors.blackBG,size: 16,))
                            // Icon(Icons.favorite_border, color: Colors.white),
                          ],
                        ),
                      ),
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
                              width: widths * 0.66,
                              // color: Colors.red,
                              child: Text(
                                data?.storeName,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                  // color: Color(0xff00bd62),
                                  borderRadius: BorderRadius.circular(3)
                              ),
                              child: Text("⭐⭐⭐",
                                  style: TextStyle(
                                    color:MyColors.whiteBG,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  )),
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
                          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                              color: Color(0xff00bd62),
                              borderRadius: BorderRadius.circular(3)
                          ),
                          child: Text(
                              "Flat 50% off on pre-booking       +${data?.offers} offers",
                              style: TextStyle(
                                color:MyColors.whiteBG,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              )),

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
        },
      ),
    );
  }
}
