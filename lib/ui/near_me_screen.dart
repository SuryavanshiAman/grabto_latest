import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/view_model/filter_view_model.dart';
import 'package:grabto/widget/rating.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../helper/shared_pref.dart';
import '../model/features_model.dart';
import '../model/filtered_data_model.dart';
import '../model/store_model.dart';
import '../model/sub_categories_model.dart';
import '../model/user_model.dart';
import '../services/api_services.dart';
import '../utils/snackbar_helper.dart';
import 'coupon_fullview_screen.dart';
import 'filter_boottom_sheet.dart';

class FirstList {
  String name;
  FirstList(this.name);
}

class Restaurant {
  final String name;
  final String location;
  final String cuisine;
  final double rating;
  final String price;
  // final String imageUrl;
  final List<String> offers;

  Restaurant({
    required this.name,
    required this.location,
    required this.cuisine,
    required this.rating,
    required this.price,
    // required this.imageUrl,
    required this.offers,
  });
}

class NearMeScreen extends StatefulWidget {
  const NearMeScreen({super.key});

  @override
  State<NearMeScreen> createState() => _NearMeScreenState();
}

class _NearMeScreenState extends State<NearMeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = true;
  List<FirstList> list = [
    FirstList("Filter"),
    FirstList("Rating 4+"),
    FirstList("Within 5km"),
    FirstList("Up to 10% off"),
  ];
  final List<Restaurant> restaurants = [
    Restaurant(
      name: "Rocca By Hyatt Regency",
      location: "Hotel Savvy Grand, Gomti Nagar, 4.3 km",
      cuisine: "Continental, North Indian",
      rating: 4.0,
      price: "₹1500 for two", // Example image URL
      offers: [
        "Flat 50% off on pre-booking"
            "                 +4 offers",
        // "Get extra 10% off using GIRFNEXT150",
      ],
    ),
    Restaurant(
      name: "Que",
      location: "Hotel Savvy Grand, Gomti Nagar, 4.3 km",
      cuisine: "Continental, North Indian",
      rating: 4.0,
      price: "₹1500 for two", // Example image URL
      offers: [
        "Flat 50% off on pre-booking",
        // "Get extra 10% off using GIRFNEXT150",
        "+4 offers"
      ],
    ),
    Restaurant(
      name: "Que",
      location: "Hotel Savvy Grand, Gomti Nagar, 4.3 km",
      cuisine: "Continental, North Indian",
      rating: 4.0,
      price: "₹1500 for two", // Example image URL
      offers: [
        "Flat 50% off on pre-booking",
        // "Get extra 10% off using GIRFNEXT150",
        "+4 offers"
      ],
    ),
    Restaurant(
      name: "Que",
      location: "Hotel Savvy Grand, Gomti Nagar, 4.3 km",
      cuisine: "Continental, North Indian",
      rating: 4.0,
      price: "₹1500 for two", // Example image URL
      offers: [
        "Flat 50% off on pre-booking",
        // "Get extra 10% off using GIRFNEXT150",
        "+4 offers"
      ],
    ),
    Restaurant(
      name: "Que",
      location: "Hotel Savvy Grand, Gomti Nagar, 4.3 km",
      cuisine: "Continental, North Indian",
      rating: 4.0,
      price: "₹1500 for two", // Example image URL
      offers: [
        "Flat 50% off on pre-booking",
        // "Get extra 10% off using GIRFNEXT150",
        "+4 offers"
      ],
    ),
    Restaurant(
      name: "Que",
      location: "Hotel Savvy Grand, Gomti Nagar, 4.3 km",
      cuisine: "Continental, North Indian",
      rating: 4.0,
      price: "₹1500 for two", // Example image URL
      offers: [
        "Flat 50% off on pre-booking",
        // "Get extra 10% off using GIRFNEXT150",
        "+4 offers"
      ],
    ),
    Restaurant(
      name: "Que",
      location: "Hotel Savvy Grand, Gomti Nagar, 4.3 km",
      cuisine: "Continental, North Indian",
      rating: 4.0,
      price: "₹1500 for two", // Example image URL
      offers: [
        "Flat 50% off on pre-booking",
        // "Get extra 10% off using GIRFNEXT150",
        "+4 offers"
      ],
    ),
    // Add more restaurants here
  ];
  List<FirstList> selectedList = [];
  void toggleSelection(FirstList item) {
    setState(() {
      if (selectedList.contains(item)) {
        selectedList.remove(item);
      } else {
        selectedList.add(item);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);

    getUserDetails();

    feature();
    fetchSubCategories(5);

  }

  void _handleScroll() {
    setState(() {
      if (_scrollController.position.pixels > 100) {
        _showTitle = false;
      } else {
        _showTitle = true;
      }
    });
  }
  String lat="";
  String long="";
  Future<void> getUserDetails() async {
    UserModel n = await SharedPref.getUser();
    setState(() {
      lat=n.lat;
      long = n.long;
    });
    // filterApi(lat, long,"","","");
    Provider.of<FilterViewModel>(context,listen: false).filterApi(context, lat, long, "", "", "", [], []);
  }
  int selectedIndices = 1;
  String selectedName = "";
  @override
  Widget build(BuildContext context) {
    final data=Provider.of<FilterViewModel>(context);
    List<FirstList> orderedList = list;
    return Scaffold(
      backgroundColor: MyColors.whiteBG,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            backgroundColor: _showTitle
                ? Colors.grey.withOpacity(0.2)
                : MyColors.backgroundBg,
            leadingWidth: 45,
            leading: _showTitle
                ? InkWell(
              onTap: (){Navigator.pop(context);},
                  child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CircleAvatar(
                        // radius: 18,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        child: Icon(
                          Icons.arrow_back,
                          color: MyColors.whiteBG,
                        ),
                      ),
                    ),
                )
                : InkWell(
                onTap: (){Navigator.pop(context);},
                child: Icon(Icons.arrow_back, color: MyColors.blackBG)),
            title: !_showTitle
                ? Text(
                    "Restaurants near you",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )
                : const Text(""),
            actions: [
              _showTitle
                  ? CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      child: Icon(
                        Icons.search,
                        color: MyColors.whiteBG,
                      ),
                    )
                  : CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      child: Icon(
                        Icons.search,
                        color: MyColors.blackBG,
                        size: 18,
                      ),
                    ),
              SizedBox(
                width: widths * 0.03,
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: _showTitle
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 62.0, left: 10),
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Restaurants near you",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          )),
                    )
                  : const Text(""),
            ),
            expandedHeight: 160,
            bottom: PreferredSize(
                preferredSize: Size(300.0, 50.0),
                child: Container(
                  color: MyColors.whiteBG,
                  child: SizedBox(
                    height: 55,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: orderedList.length,
                      itemBuilder: (context, index) {
                        FirstList item = orderedList[index];
                        bool isSelected = selectedList.contains(item);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              toggleSelection(item);
                              selectedName = list[index].name;
                              print("item");
                              print(isSelected);
                              isSelected==false? index==0?showFilterBottomSheet(context,lat,long,featureData,subCategoriesList):index==1?data.filterApi(context, lat, long, "4", "", "", [], []):index==2?data.filterApi(context,lat, long,"","5","",[],[],):data.filterApi(context,lat, long,"","","10",[],[]):null;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, ),
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.grey.withOpacity(0.3)
                                    : MyColors.whiteBG,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: isSelected
                                        ? MyColors.blackBG
                                        : Colors.grey.withOpacity(0.5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                                SizedBox(width: widths*0.02,),
                                index == 0
                                    ? Icon(Icons.tune_outlined,size: 18,)
                                    : index == 1
                                        ? Icon(
                                            Icons.keyboard_arrow_down_outlined,size: 20,)
                                        : isSelected
                                            ? Icon(Icons.close,size: 16,)
                                            : Container()
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )),
          ),
          SliverToBoxAdapter(
            child:
            data.filterList.data?.data==null?Center(child: CircularProgressIndicator(color: MyColors.redBG,)):data.filterList.data!.data!.isNotEmpty?Container(
              color: Color(0xffffffff),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount:  data.filterList.data?.data?.length??0,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return RestaurantCard(index:index,name: selectedName,filter:data.filterList.data!.data![index]);
                },
              ),
            ):Column(
              children: [
                Image.asset("assets/images/no-restaurant-image.png",scale: 3,),
                Center(
                    child: Text(
                      "No Restaurants Found",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<SubCategoriesModel> subCategoriesList = [];
  List<FeaturesModel>featureData=[];
  bool isLoading=false;
  Future<void> feature() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await ApiServices.getFeatureApi();
      if (response != null) {
        setState(() {
          featureData = response;
        });
      }
    } catch (e) {
      print('getFeatureApi: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> fetchSubCategories(int category_id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = {"category_id": "$category_id"};
      final response = await ApiServices.fetchSubCategories(body);
      if (response != null) {
        print("Amannnn:$body");
        print("Amannnn:$response");
        setState(() {
          subCategoriesList = response;
        });
      }
    } catch (e) {
      print('fetchSubCategories: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class RestaurantCard extends StatefulWidget {
  final int index;
  final String name;
  final Data filter;

  RestaurantCard({required this.index, required this.name, required this.filter});

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  List ambienceList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGalleryImagesAmbience("177", "ambience");
    getUserDetails();
  }
  int selectedIndex=-1;
  int userId = 0;
  Future<void> getUserDetails() async {
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.name);
    setState(() {
      userId = n.id;
      fetchStoresFullView(widget.filter.id, "${userId}");
    });
  }
  final CarouselSliderController _carouselController =
  CarouselSliderController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final imageList = widget.filter.image ?? [];
    return  InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CouponFullViewScreen(widget.filter.id.toString());
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
                CarouselSlider(
                  items: widget.filter.image?.map((img) {
                    return GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
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
                  }).toList() ?? [],
                  carouselController:
                  _carouselController, // Use empty list if image is null
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
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
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
                              widget.filter.subCategoriesName,
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
                widget.filter.availableSeat!=null?   Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color:int.parse(widget.filter.availableSeat) <=5?MyColors.redBG:MyColors.green ,
                          // color:MyColors.green ,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "${widget.filter.availableSeat.toString()??""} seat left",
                          style: TextStyle(
                              color: MyColors.whiteBG,
                              fontWeight: FontWeight.w500,
                              fontSize: 11),
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
                          "${widget.filter.avgRating.toStringAsFixed(1)}/5",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ),

                      CircleAvatar(
                        radius: 12,
                        backgroundColor: MyColors.whiteBG,
                        child:InkWell(
                          onTap: (){
                            wishlist("$userId", "${widget.filter.id}");
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
                //           "${widget.filter.availableSeat} seat left",
                //           style: TextStyle(
                //               color: MyColors.whiteBG,
                //               fontWeight: FontWeight.bold,
                //               fontSize: 12),
                //         ),
                //       ),
                //       // Spacer(),
                //       SizedBox(
                //         width: widths * 0.43,
                //       ),
                //       Container(
                //         margin: EdgeInsets.only(right: 15),
                //         padding: const EdgeInsets.fromLTRB(6, 4, 8, 4),
                //         decoration: BoxDecoration(
                //           color: Colors.green,
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //         child: Text(
                //           "${widget.filter.avgRating.toStringAsFixed(1)}/5",
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
                //           child: InkWell(
                //             onTap: (){
                //               wishlist("$userId", "${widget.filter.id}");
                //             },
                //             child: Icon(
                //               wishlist_status == 'true'
                //                   ? Icons.favorite
                //                   : Icons.favorite_border,
                //               size: 16,
                //               color:
                //               wishlist_status == 'true' ? Colors.red : Colors.black,
                //             ),
                //           ),
                //           // InkWell(
                //           //   onTap: (){
                //           //     setState(() {
                //           //       selectedIndex=widget.index;
                //           //     });
                //           //   },
                //           //   child: Icon(
                //           //     selectedIndex!=widget.index? Icons.favorite_border:Icons.favorite,
                //           //     color: selectedIndex!=widget.index? MyColors.blackBG:MyColors.redBG,
                //           //     size: 16,
                //           //   ),
                //           // )
                //       )
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
                          widget.filter.storeName,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
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
                        child:  StarRating(color: Colors.yellow,rating: double.parse(widget.filter.avgRating.toStringAsFixed(1).toString()),size: 16,),
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
                  Container(
                    width: widths*0.85,
                    // color: MyColors.redBG,
                    child: Text(
                      "${widget.filter.address}-${widget.filter.distance}Km",
                      style: TextStyle(color: MyColors.textColorTwo, fontSize: 12),
                    ),
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
                  widget.filter.dish != null
                      ? Text(
                    widget.filter.dish.toString(),
                    style: TextStyle(
                        color: MyColors.textColorTwo, fontSize: 12),
                  )
                      : Container(),
                  widget.filter.dish != null
                      ? Divider(
                    color: MyColors.textColorTwo.withOpacity(0.3),
                  )
                      : Container(),
                  Container(
                    width: widths,
                    padding:
                    EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                    decoration: BoxDecoration(
                        color: Color(0xff00bd62),
                        borderRadius: BorderRadius.circular(3)),
                    child: Text(
                        widget.filter.offers!=""? "% Flat ${widget.filter.discountPercentage.toString()}% off on pre-booking       +${widget.filter.offers.toString()} offers":
                        "% Flat ${widget.filter.discountPercentage.toString()??""}% off on pre-booking",
                        style: TextStyle(
                          color: MyColors.whiteBG,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        )),
                  ),
          //         Container(
          //   padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
          //   decoration: BoxDecoration(
          //   color: Color(0xff00bd62),
          //   borderRadius: BorderRadius.circular(3)
          //   ),
          //   child: Text(
          // "Flat 50% off on pre-booking       +${widget.filter.offers} offers",
          //   style: TextStyle(
          //   color:MyColors.whiteBG,
          //   fontWeight: FontWeight.w500,
          //   fontSize: 14,
          //   )),
          //
          //         ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isLoading = true;

  Future<void> fetchGalleryImagesAmbience(String store_id, String food_type) async {
    if (!mounted) return; // exit early if the widget is not mounted
    setState(() {
      isLoading = true;
    });

    try {
      final body = {"store_id": "$store_id", "food_type": "$food_type"};
      final response = await ApiServices.store_multiple_galleryJson(body);
      print("object: $response");

      if (!mounted) return;

      if (response != null) {
        setState(() {
          ambienceList = response;
          print('fetchGalleryImagesAmbience: $response');
        });
      }

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

    } catch (e) {
      print('fetchGalleryImagesAmbience: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  String wishlist_status = '';
  StoreModel? store;

  Future<void> wishlist(String user_id, String store_id) async {
    try {
      final body = {"user_id": user_id, "store_id": store_id};
      final response = await ApiServices.wishlist(body);

      // Check if the response is null or doesn't contain the expected data
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
      //print('verify_otp error: $e');
      // Handle error
      //showErrorMessage(context, message: 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> fetchStoresFullView(String store_id, user_id) async {
    try {
      final body = {
        "store_id": "$store_id",
        "user_id": "$user_id",
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

          print("store: " + data.toString());
          // print('fetchStoresFullView data: ${category_name}');
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
}
