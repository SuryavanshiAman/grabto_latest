import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';

import '../services/api_services.dart';
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
    FirstList("Sort by"),
    FirstList("GIRF"),
    FirstList("Rating 4+"),
    FirstList("Open now"),
    FirstList("Serves Alcohol"),
    FirstList("Open till late"),
    FirstList("Within 5km"),
    FirstList("Pure Veg"),
    FirstList("Cuisines"),
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
        "Get extra 10% off using GIRFNEXT150",
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
        "Get extra 10% off using GIRFNEXT150",
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
        "Get extra 10% off using GIRFNEXT150",
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
        "Get extra 10% off using GIRFNEXT150",
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
        "Get extra 10% off using GIRFNEXT150",
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
        "Get extra 10% off using GIRFNEXT150",
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
        "Get extra 10% off using GIRFNEXT150",
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

  int selectedIndices = 1;
  String selectedName = "";
  @override
  Widget build(BuildContext context) {
    List<FirstList> orderedList = [
      list[0], // Fixed index 0
      list[1], // Fixed index 1
      ...selectedList, // Selected items start from index 2
      ...list
          .sublist(2)
          .where((e) => !selectedList.contains(e)) // Remaining unselected items
    ];
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
                              index==0?showFilterBottomSheet(context):null;
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
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: restaurants.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return RestaurantCard(
                      restaurant: restaurants[index], name: selectedName);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RestaurantCard extends StatefulWidget {
  final Restaurant restaurant;
  final String name;

  RestaurantCard({required this.restaurant, required this.name});

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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with overlay
          Stack(
            children: [
              CarouselSlider(
                items: ambienceList.map((json) {
                  return GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: json['image'],
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
                }).toList(),
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
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    widget.name.toString(),
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.favorite_border, color: Colors.white),
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
                      width: widths * 0.66,
                      // color: Colors.red,
                      child: Text(
                        widget.restaurant.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    CircleAvatar(
                        radius: 9,
                        backgroundColor: MyColors.darkGreen,
                        child: Icon(Icons.star,
                            color: MyColors.whiteBG, size: 12)),
                    SizedBox(width: 4),
                    Text(
                      widget.restaurant.rating.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: MyColors.blackBG),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  widget.restaurant.location,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  "${widget.restaurant.cuisine} • ${widget.restaurant.price}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.grey[600],
                              size: 12,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Table Booking",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ],
                        )),
                  ],
                ),
                Divider(),
                Wrap(
                  children: widget.restaurant.offers.map((offer) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                      decoration: BoxDecoration(),
                      child: Text(offer,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          )),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}
