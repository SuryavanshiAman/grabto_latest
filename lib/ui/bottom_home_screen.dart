import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/main.dart';
import 'package:grabto/model/categories_model.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/model/great_offer_model.dart';
import 'package:grabto/model/locality_model.dart';
import 'package:grabto/model/store_model.dart';
import 'package:grabto/model/sub_categories_model.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/services/api_services.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/all_coupon_screen.dart';
import 'package:grabto/ui/booked_table_screen.dart';
import 'package:grabto/ui/coupon_fullview_screen.dart';
import 'package:grabto/ui/delete_screen.dart';
import 'package:grabto/ui/near_me_screen.dart';
import 'package:grabto/ui/refer_and_earn.dart';
import 'package:grabto/ui/search_screen.dart';
import 'package:grabto/ui/select_address_screen.dart';
import 'package:grabto/ui/subcategories_screen.dart';
import 'package:grabto/ui/term_and_condition.dart';
import 'package:grabto/ui/top_categories_screen.dart';
import 'package:grabto/ui/table_paybill_screen.dart';
import 'package:grabto/ui/total_visit_screen.dart';
import 'package:grabto/ui/transaction_screen.dart';
import 'package:grabto/utils/dashed_line.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:grabto/utils/time_slot.dart';
import 'package:grabto/view_model/different_location_view_model.dart';
import 'package:grabto/view_model/filter_view_model.dart';
import 'package:grabto/view_model/grabto_grab_view_model.dart';
import 'package:grabto/view_model/near_me_image_view_model.dart';
import 'package:grabto/widget/rating.dart';
import 'package:grabto/widget/title_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:grabto/model/pre_book_table_history.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../helper/location_provider.dart';
import '../model/city_model.dart';
import '../model/features_model.dart';
import '../services/api.dart';
import '../widget/sub_categories_card_widget.dart';
import 'about_us_screen.dart';
import 'account_setting.dart';
import 'customer_care.dart';
import 'filter_boottom_sheet.dart';
import 'how_it_works.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class HomeBottamScreen extends StatefulWidget {
  final Future<void> Function(String) onFetchMembership;
  final List<BannerModel> bannersDa;
  HomeBottamScreen(
      {super.key, required this.onFetchMembership, required this.bannersDa});

  @override
  State<HomeBottamScreen> createState() => _HomeBottamScreenState();

  // Static getter to access the instance of _HomeBottomScreenState
  static _HomeBottamScreenState? get instance =>
      _HomeBottamScreenState.instance;
}

class _HomeBottamScreenState extends State<HomeBottamScreen>
    with WidgetsBindingObserver {
  final CarouselSliderController _controller = CarouselSliderController();

  List imageSlider = [];
  List<CategoriesModel> categories = [];
  List<StoreModel> trendingStoreList = [];
  List<StoreModel> recentStoreList = [];
  List<StoreModel> topCollectionStoreList = [];

  List<GreatOfferModel> greatOfferList1 = [];
  List<GreatOfferModel> greatOfferList2 = [];
  List<SubCategoriesModel> wahtyourchoicList = [];
  List<LocalityModel> localtiyList = [];
  String userName = '';
  String bannerId = '';
  String bannerType = '';
  String bannerImage = '';
  String bannerStatus = '';
  String bannerURL = '';
  bool isLoading = false;
  String cityId = "";
  List<PreBookTableHistoryModel> prebookofferlistHistory = [];
  int user_id = 0;
  var topCategoriesController = TextEditingController();

  static _HomeBottamScreenState? _instance;
  List<SubCategoriesModel> subCategoriesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_handleScroll);
    _instance = this;
    WidgetsBinding.instance.addObserver(this);
    getUserDetails();
    fetchSubCategories(5);
    getBanners();
    Provider.of<DifferentLocationViewModel>(context, listen: false)
        .differentLocationApi(context);
    Provider.of<GrabtoGrabViewModel>(context, listen: false)
        .grabtoGrabApi(context);
    Provider.of<NearMeImageViewModel>(context, listen: false)
        .nearMeImageApi(context);
    // fetchSubCategories()
  }

  @override
  void dispose() {
    // Unregistering the observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // This is called when the app is resumed (comes to the foreground)
      print("App has resumed and is in the foreground!");
      // You can perform any action you want here, like refreshing data.
      if (user_id != 0) {
        UserPreBookTableHistory("");
      }
    }
  }

  static _HomeBottamScreenState? get instance => _instance;

  List<CityModel> cityList = [];
  String userEmail = '';
  String userMobile = '';
  String userimage = '';
  String dialogimage = '';
  String current_location = '';
  String address = '';
  String home_location = '';
  String planName = '';
  String left_day = '';
  String gatewayStatus = '';
  String externalStatus = '';
  String lat = "";
  String long = "";
  Future<void> getUserDetails() async {
    setState(() {
      isLoading = true;
    });
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: bottomHomeScreen " + n.home_location);
    UserPreBookTableHistory("${n.id}");
    setState(() {
      user_id = n.id;
      cityId = n.home_location;
      user_id = n.id;
      userName = n.name;
      userEmail = n.email;
      userMobile = n.mobile;
      userimage = n.image;
      address = n.address;
      current_location = n.current_location;
      home_location = n.home_location;
      lat = n.lat;
      long = n.long;
    });
    Provider.of<FilterViewModel>(context, listen: false)
        .filterApi(context, lat, long, "", "", "", [], []);
    await allApiCall(cityId);
  }

  int _selectedIndex = 0;
  Future<void> shareNetworkImage(String imageUrl, String text) async {
    setState(() {
      isLoading = true;
    });
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final Directory directory = await getTemporaryDirectory();
    final File file = await File('${directory.path}/Image.png')
        .writeAsBytes(response.bodyBytes);
    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text: text,
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<void> allApiCall(String _cityId) async {
    setState(() {
      isLoading = true;
    });
    try {
      // UserModel n = await SharedPref.getUser();
      // widget.onFetchMembership("${n.id}");
      // UserPreBookTableHistory("${n.id}");

      fetchShowSlider("${_cityId}");
      fetchCategories();
      fetchTrendingStore("", "10", "", "", "", "1", "", "", "${_cityId}", "");
      fetchRecentStore("", "10", "", "", "", "", "1", "", "${_cityId}", "");
      fetchTopCollectionStore(
          "", "10", "", "", "", "", "", "1", "${_cityId}", "");
      getName();
      getBanners();
      fetchGreatOffers1("");
      fetchGreatOffers2("2");
      fetchWhatYourChoice();
      fetchCityLocality("${_cityId}");
    } catch (e) {
      print('Error in API calls: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    try {
      // Simulate network fetch or database query
      await Future.delayed(Duration(seconds: 2));
      // Update the list of items and refresh the UI
      UserModel n = await SharedPref.getUser();
      widget.onFetchMembership("${n.id}");
      UserPreBookTableHistory("${n.id}");
      setState(() {
        allApiCall(cityId);
      });
    } catch (error) {
      // Handle the error, e.g., by displaying a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $error'),
        ),
      );
    }
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _onItemTappedd(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  Future<void> _handleReturnFromSecondScreen() async {
    // This function will be called when returning from the second screen
    print('Returned from HomeScreen');
    await getUserDetails();
    await fetchCity();
    await currentMembership("$user_id");
  }

  void logoutUser() {
    SharedPref.logout(context);
  }

  final ScrollController _scrollController = ScrollController();
  bool _showTitle = true;
  void _handleScroll() {
    setState(() {
      if (_scrollController.position.pixels > 2500) {
        _showTitle = false;
      } else {
        _showTitle = true;
      }
    });
  }

  List<FirstList> list = [
    FirstList("Filter"),
    FirstList("ShortBy"),
    FirstList(
      "Rating 4+",
    ),
    FirstList("Within 5km"),
    FirstList("Up to 10% off"),
  ];
  String selectedName = "";
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
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int sliderIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<FirstList> orderedList = list;
    final location = Provider.of<Address>(context);
    final differentLocation = Provider.of<DifferentLocationViewModel>(context);
    final data = Provider.of<FilterViewModel>(context);
    final grab = Provider.of<GrabtoGrabViewModel>(context).grabList.data?.data;
    final nearImage = Provider.of<NearMeImageViewModel>(context).imageList.data;
    print(location.area);
    final imageList = grab?[0].image ?? [];
    return categories.isNotEmpty
        ? Scaffold(
      key: _scaffoldKey,
            backgroundColor: MyColors.backgroundBg,
            body: Container(
              color: MyColors.backgroundBg,
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height),
              child: RefreshIndicator(
                color: Colors.white,
                backgroundColor: MyColors.primaryColor,
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          print(widget.bannersDa[0].url);
                          print("widget.bannersDa[0].url");
                          widget.bannersDa[0].type == "1"
                              ? navigateToAllCouponScreen(
                                  context,
                                  widget.bannersDa[0].subcategory_name,
                                  widget.bannersDa[0].category_id,
                                  widget.bannersDa[0].id)
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CouponFullViewScreen(
                                              "${widget.bannersDa[0].url}")));
                        },
                        child: Container(
                          height: heights * 0.53,
                          decoration: BoxDecoration(
                              // color: Colors.red,
                              image: DecorationImage(
                                  image:
                                      NetworkImage(widget.bannersDa[0].image),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 40, left: 10, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // final scaffoldState = _scaffoldKey.currentState;
                                        // if (scaffoldState != null) {
                                        //   if (scaffoldState.isDrawerOpen) {
                                        //     scaffoldState.closeDrawer();
                                        //   } else {
                                        //     scaffoldState.openDrawer();
                                        //   }
                                        // }
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountSettingsScreen()));
                                      },
                                      child: const Icon(
                                        Icons.menu,
                                        color: MyColors.whiteBG,
                                      ),
                                    ),
                                    // GestureDetector(
                                    //     onTap: () {
                                    //       if (_scaffoldKey
                                    //           .currentState!.isDrawerOpen) {
                                    //         _scaffoldKey.currentState!
                                    //             .closeDrawer();
                                    //       } else {
                                    //         _scaffoldKey.currentState!
                                    //             .openDrawer();
                                    //       }
                                    //     },
                                    //     child: const Icon(
                                    //       Icons.menu,
                                    //       color: MyColors.whiteBG,
                                    //     )),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddressScreen(
                                                      type: 2,
                                                    )));
                                      },
                                      child: Container(width: widths * 0.7,

                                        child: Row(
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.start,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset("assets/svg/pin_drop.svg"),
                                            // Image.asset(
                                            //   "assets/images/pin_drop.png",
                                            //   scale: 0.8,
                                            // ),
                                            SizedBox(
                                              width: widths * 0.02,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            top: 2),
                                                        // width: widths * 0.6,
                                                        child: Text(
                                                          address.toString() !=
                                                                  ""
                                                              ? address
                                                                  .toString()
                                                                  .split(',')[0]
                                                              : location.address
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            color: MyColors
                                                                .whiteBG,
                                                          ),
                                                        )),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                      size: 16,
                                                      color: MyColors.whiteBG,
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                    width: widths * 0.59,
                                                    child: Text(
                                                      address != ""
                                                          ? address
                                                          : location.area,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: MyColors.whiteBG,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: MyColors.whiteBG,
                                      child: Icon(Icons.notifications,size: 16,),
                                    )
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    _navigateToSearchScreen(context);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    height: 40,
                                    child: Material(
                                      elevation:
                                          1, // Set the elevation value as needed
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Container(
                                        height: 55,
                                        padding: const EdgeInsets.all(10),
                                        decoration: ShapeDecoration(
                                          color: MyColors.searchBg,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                'Search for restaurants',
                                                style: TextStyle(
                                                  color: Color(0x993C3C43),
                                                  fontSize: 14,
                                                  // fontFamily: 'SF Pro Text',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0.08,
                                                  letterSpacing: -0.41,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: 28,
                                                height: 28,
                                                child: Icon(
                                                  Icons.search,
                                                  color: MyColors.textColorTwo,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Visibility(
                        visible: imageSlider.isNotEmpty,
                        child: Center(
                          child: CarouselSlider(
                            carouselController: _controller,
                            items: imageSlider.map((json) {
                              return GestureDetector(
                                onTap: () {
                                  print("url: " + json['image']);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CouponFullViewScreen(
                                                  "${json['store_id']}")));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
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
                                        Center(child: Icon(Icons.error)),
                                  ),
                                ),
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: 165,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              reverse: true,
                              disableCenter: true,
                              aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              viewportFraction: 0.9,
                            ),
                          ),
                        ),
                      ),
                      if (prebookofferlistHistory.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(
                              top: 25, left: 15, right: 15, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Booking",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      if (prebookofferlistHistory.isNotEmpty)
                        Container(
                          height: 300,
                          child: _buildOfferCard(prebookofferlistHistory),
                        ),

                      /// abhi kholna hai

                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NearMeScreen()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 14,
                            right: 14,
                          ),
                          height: heights * 0.15,
                          width: widths,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(nearImage?.data?[0].image??""),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 15,
                          right: 15,
                        ),
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
                              "Explore Categories",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: heights * 0.49,
                        margin: EdgeInsets.only(top: heights * 0.02),
                        padding: EdgeInsets.only(
                            left: widths * 0.03, right: widths * 0.03),
                        // color: Colors.red,
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: subCategoriesList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  mainAxisExtent: 180),
                          itemBuilder: (BuildContext context, int index) {
                            SubCategoriesModel subCategoriesModel =
                                subCategoriesList[index];
                            return SubCategoriesCardWidget(
                              imgUrl: subCategoriesModel.image,
                              subcategoryName:
                                  subCategoriesModel.subcategory_name,
                              spotAvailable: "",
                              redeemed: "",
                              onTap: () {
                                print(subCategoriesModel.category_id);
                                print(subCategoriesModel.id);
                                print("subCategoriesModel.id");
                                navigateToAllCouponScreen(
                                  context,
                                  subCategoriesModel.subcategory_name,
                                  subCategoriesModel.category_id,
                                  subCategoriesModel.id,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      grab != "" && grab != null
                          ? Container(
                              height: heights * 0.55,
                              margin: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  // color: MyColors.redBG,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          grab?[0].backgroundimage),
                                      fit: BoxFit.fill)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Grabto Grab",
                                    style: TextStyle(
                                        color: MyColors.whiteBG,
                                        fontFamily: 'vast',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return CouponFullViewScreen(
                                            grab?[0].id.toString() ?? "");
                                      }));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 8),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Image with overlay
                                          Stack(
                                            children: [
                                              CarouselSlider(
                                                items: grab?[0]
                                                        .image
                                                        ?.map((img) {
                                                      return GestureDetector(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: img.url
                                                                .toString(),
                                                            fit: BoxFit.fill,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              'assets/images/placeholder.png',
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .error)),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList() ??
                                                    [],
                                                carouselController:
                                                    _carouselController, // Use empty list if image is null
                                                options: CarouselOptions(
                                                  height: heights * 0.22,
                                                  enlargeCenterPage: true,
                                                  autoPlay: true,
                                                  reverse: true,
                                                  disableCenter: true,
                                                  aspectRatio: 1 / 9,
                                                  autoPlayCurve:
                                                      Curves.fastOutSlowIn,
                                                  enableInfiniteScroll: true,
                                                  autoPlayAnimationDuration:
                                                      const Duration(
                                                          milliseconds: 800),
                                                  viewportFraction: 1,
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      sliderIndex = index;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Positioned(
                                                top: 10,
                                                left: 10,
                                                child: Row(
                                                  children: [
                                                    grab?[0].availableSeat !=
                                                            null
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        2),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: int.parse(grab?[
                                                                              0]
                                                                          .availableSeat) <=
                                                                      5
                                                                  ? MyColors
                                                                      .redBG
                                                                  : MyColors
                                                                      .green,
                                                              // color:MyColors.green ,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Text(
                                                              "${grab?[0].availableSeat.toString() ?? ""} seat left",
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .whiteBG,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 11),
                                                            ),
                                                          )
                                                        : Container(),
                                                    // Spacer(),
                                                    SizedBox(
                                                      width: widths * 0.43,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 15),
                                                      padding: const EdgeInsets
                                                          .fromLTRB(6, 4, 8, 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Text(
                                                        "${grab?[0].rating ?? "0"}/5",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ),

                                                    CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor:
                                                            MyColors.whiteBG,
                                                        child: InkWell(
                                                          onTap: () {
                                                            fetchStoresFullView(
                                                                grab?[0]
                                                                        .id
                                                                        .toString() ??
                                                                    "");
                                                            wishlist(grab?[0]
                                                                    .id
                                                                    .toString() ??
                                                                "");
                                                          },
                                                          child: Icon(
                                                            wishlist_status ==
                                                                    'true'
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_border,
                                                            size: 16,
                                                            color:
                                                                wishlist_status ==
                                                                        'true'
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                        )),
                                                    //   // InkWell(
                                                    //   //   onTap: (){
                                                    //   //     setState(() {
                                                    //   //       selectedIndex=widget.index;
                                                    //   //     });
                                                    //   //   },
                                                    //   //   child: Icon(
                                                    //   //     selectedIndex!=widget.index? Icons.favorite_border:Icons.favorite,
                                                    //   //     color: selectedIndex!=widget.index? MyColors.blackBG:MyColors.redBG,
                                                    //   //     size: 16,
                                                    //   //   ),
                                                    //   // )
                                                    // )
                                                    // Icon(Icons.favorite_border, color: Colors.white),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 10,
                                                left: 0,
                                                right: 0,
                                                child: Center(
                                                  child:
                                                      AnimatedSmoothIndicator(
                                                    activeIndex: sliderIndex,
                                                    count: imageList.length,
                                                    effect:
                                                        const ExpandingDotsEffect(
                                                      dotHeight: 6,
                                                      dotWidth: 6,
                                                      spacing: 6,
                                                      expansionFactor: 3,
                                                      activeDotColor:
                                                          MyColors.whiteBG,
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
                                                          color: MyColors
                                                              .blackBG
                                                              .withOpacity(0.6),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      margin: EdgeInsets.all(8),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              8, 2, 8, 2),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                              "assets/images/local_cafe.png"),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            grab?[0]
                                                                    .subcategoryName
                                                                    .toString() ??
                                                                "",
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: MyColors
                                                                  .whiteBG,
                                                              fontSize: 10,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: widths * 0.58,
                                                      // color: Colors.red,
                                                      child: Text(
                                                        grab?[0]
                                                                .storeName
                                                                .toString() ??
                                                            "",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    grab?[0].rating != ""
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        3,
                                                                    vertical:
                                                                        1),
                                                            decoration:
                                                                BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.3)),
                                                                    // color: Color(0xff00bd62),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            3)),
                                                            child: StarRating(
                                                              color:
                                                                  Colors.yellow,
                                                              rating: double.parse(grab?[
                                                                          0]
                                                                      .rating
                                                                      .toStringAsFixed(
                                                                          1)
                                                                      .toString() ??
                                                                  "0.0"),
                                                              size: 16,
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  grab?[0].address.toString() ??
                                                      "",
                                                  style: TextStyle(
                                                      color:
                                                          MyColors.textColorTwo,
                                                      fontSize: 12),
                                                ),
                                                Divider(
                                                  color: MyColors.textColorTwo
                                                      .withOpacity(0.3),
                                                ),
                                                Container(
                                                  width: widths,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff00bd62),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3)),
                                                  child: Text(
                                                      grab?[0].offers != ""
                                                          ? "% Flat ${grab?[0].discountPercentage.toString()}% off on pre-booking       +${grab?[0].offers.toString()} offers"
                                                          : "% Flat ${grab?[0].discountPercentage.toString() ?? ""}% off on pre-booking",
                                                      style: TextStyle(
                                                        color: MyColors.whiteBG,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return CouponFullViewScreen(
                                            grab?[0].id.toString() ?? "");
                                      }));
                                    },
                                    child: Container(
                                        width: widths * 0.33,
                                        margin: EdgeInsets.only(bottom: 10),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        decoration: BoxDecoration(
                                          color: MyColors.redBG,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "GRAB NOW ",
                                              style: TextStyle(
                                                  color: MyColors.whiteBG,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            Image.asset(
                                              "assets/images/arrow_outward.png",
                                              color: MyColors.whiteBG,
                                            )
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                      // if (!localtiyList.isEmpty)
                        Container(
                          margin: EdgeInsets.only(
                              top: 25, left: 15, right: 15, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Popular Location",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      // if (!localtiyList.isEmpty)
                        LocationWidget(localtiyList),
                      // if (!trendingStoreList.isEmpty)
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 15),
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
                                // "Trending Restaurants",
                                "Trending Restaurants",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      // if (!trendingStoreList.isEmpty)
                        TrendingRestruantWidget(trendingStoreList),
                      // if (!recentStoreList.isEmpty)
                      //   if (!recentStoreList.isEmpty)
                          RecentJoinedWidget(recentStoreList, cityId),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 15,
                          right: 15,
                        ),
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
                              "Taste from Different location?",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),

                            // InkWell(
                            //   onTap: () {
                            //     navigateToTopCategoriesScreen();
                            //   },
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         "View All",
                            //         style: TextStyle(
                            //             color: MyColors.txtDescColor,
                            //             fontSize: 14,
                            //             fontWeight: FontWeight.w300),
                            //       ),
                            //       SizedBox(
                            //         width: 5,
                            //       ),
                            //       Icon(
                            //         Icons.arrow_forward,
                            //         size: 15,
                            //         color: MyColors.primaryColor,
                            //       )
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: heights * 0.06,
                        child: ListView.builder(
                          itemCount: differentLocation
                                  .locationList.data?.data?.length ??
                              0,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final data = differentLocation
                                .locationList.data?.data?[index];
                            return InkWell(
                              onTap: () {
                                differentLocation.nearByPlacesApi(
                                    context, data?.localityName ?? "");
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 30),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                // height: heights*0.03,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: MyColors.blackBG,
                                        spreadRadius: 0.2,
                                        offset: Offset(2, 2),
                                        blurRadius: 1,
                                      ),
                                    ],
                                    color: Color(0xffECECEC),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  data?.localityName ?? "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // if (!topCollectionStoreList.isEmpty)
                        Container(
                          margin: EdgeInsets.only(
                              top: 25, left: 15, right: 15, bottom: 15),
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
                                "All Restaurants",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),

                        // color: MyColors.whiteBG,
                        child: SizedBox(
                          height: 50,
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
                                    isSelected == false
                                        ? index == 0
                                            ? showFilterBottomSheet(
                                                context,
                                                lat,
                                                long,
                                                featureData,
                                                subCategoriesList)
                                            : index == 1
                                                ? showSortBottomSheet(context)
                                                : index == 2
                                                    ? data.filterApi(
                                                        context,
                                                        lat,
                                                        long,
                                                        "4",
                                                        "",
                                                        "", [], [])
                                                    : index == 3
                                                        ? data.filterApi(
                                                            context,
                                                            lat,
                                                            long,
                                                            "",
                                                            "5",
                                                            "",
                                                            [],
                                                            [],
                                                          )
                                                        : data.filterApi(
                                                            context,
                                                            lat,
                                                            long,
                                                            "",
                                                            "",
                                                            "10", [], [])
                                        : null;

                                    // index==0?showFilterBottomSheet(context,lat,long,featureData,subCategoriesList):index==1?filterApi(lat, long,"4","",""):index==2?filterApi(lat, long,"","5",""):filterApi(lat, long,"","","10");
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                      color: isSelected
                                          ? MyColors.blackBG
                                          : MyColors.whiteBG,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.grey.withOpacity(0.5))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      index == 0
                                          ? Icon(
                                              Icons.filter_alt_outlined,
                                              size: 18,
                                              color: isSelected
                                                  ? MyColors.whiteBG
                                                  : Colors.black,
                                            )
                                          : index == 1
                                              ? Icon(
                                                  Icons
                                                      .keyboard_arrow_down_outlined,
                                                  size: 20,
                                                )
                                              : isSelected
                                                  ? Icon(
                                                      Icons.close,
                                                      size: 16,
                                                    )
                                                  : Container(),
                                      SizedBox(
                                        width: widths * 0.02,
                                      ),
                                      Center(
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
                                              color: isSelected
                                                  ? MyColors.whiteBG
                                                  : Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if(data.filterList.data?.data == null)
                        Center(child: CircularProgressIndicator(color: MyColors.redBG))

                           else if (   data.filterList.data!.data!.isNotEmpty)
                           Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount:
                                    data.filterList.data?.data?.length ?? 0,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  List<Data> sortedList = List.from(data.filterList.data?.data ?? []);
                                  if (data.filterIndex == 1) {
                                    double userLat = double.tryParse(lat) ?? 0;
                                    double userLng = double.tryParse(long) ?? 0;

                                    double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
                                      const double p = 0.017453292519943295; // pi/180
                                      final double a = 0.5 -
                                          cos((lat2 - lat1) * p) / 2 +
                                          cos(lat1 * p) * cos(lat2 * p) *
                                              (1 - cos((lon2 - lon1) * p)) / 2;
                                      return 12742 * asin(sqrt(a)); // Earth's diameter * arc calculation
                                    }

                                    sortedList.sort((a, b) {
                                      double latA = double.tryParse(a.lat ?? "0") ?? 0;
                                      double lngA = double.tryParse(a.long ?? "0") ?? 0;
                                      double latB = double.tryParse(b.lat ?? "0") ?? 0;
                                      double lngB = double.tryParse(b.long ?? "0") ?? 0;

                                      double distA = calculateDistance(userLat, userLng, latA, lngA);
                                      double distB = calculateDistance(userLat, userLng, latB, lngB);
                                      return distA.compareTo(distB); // Nearest first
                                    });
                                  } else if (data.filterIndex == 2) {
                                    sortedList.sort((a, b) {
                                      double ratingA = double.tryParse(a.avgRating.toString()) ?? 0;
                                      double ratingB = double.tryParse(b.avgRating.toString()) ?? 0;
                                      return ratingB.compareTo(ratingA); // High to Low
                                    });
                                  } else if (data.filterIndex == 3) {
                                    sortedList.sort((a, b) {
                                      double ratingA = double.tryParse(a.avgRating.toString()) ?? 0;
                                      double ratingB = double.tryParse(b.avgRating.toString()) ?? 0;
                                      return ratingA.compareTo(ratingB); // Low to High
                                    });
                                  }

                                  return data.filterList.data?.data?.length == 0
                                      ? Text("Nodata")
                                      : RestaurantCard(
                                          index: index,
                                          name: selectedName,
                                          filter: sortedList[index]
                                  );
                                },
                              ),
                            )
                          else Column(
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
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: _showTitle == false
                ? Container(
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
                                isSelected == false
                                    ? index == 0
                                        ? showFilterBottomSheet(
                                            context,
                                            lat,
                                            long,
                                            featureData,
                                            subCategoriesList)
                                        : index == 1
                                            ? data.filterApi(context, lat, long,
                                                "4", "", "", [], [])
                                            : index == 2
                                                ? data.filterApi(
                                                    context,
                                                    lat,
                                                    long,
                                                    "",
                                                    "5",
                                                    "",
                                                    [],
                                                    [],
                                                  )
                                                : data.filterApi(context, lat,
                                                    long, "", "", "10", [], [])
                                    : null;

                                // index==0?showFilterBottomSheet(context,lat,long,featureData,subCategoriesList):index==1?filterApi(lat, long,"4","",""):index==2?filterApi(lat, long,"","5",""):filterApi(lat, long,"","","10");
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.grey.withOpacity(0.3)
                                      : MyColors.whiteBG,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: isSelected
                                          ? MyColors.blackBG
                                          : Colors.grey.withOpacity(0.5))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  index == 0
                                      ? Icon(
                                          Icons.filter_alt_outlined,
                                          size: 18,
                                        )
                                      : index == 1
                                          ? Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              size: 20,
                                            )
                                          : isSelected
                                              ? Icon(
                                                  Icons.close,
                                                  size: 16,
                                                )
                                              : Container(),
                                  SizedBox(
                                    width: widths * 0.02,
                                  ),
                                  Center(
                                    child: Text(
                                      item.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Text(""),
            drawer: Drawer(
              backgroundColor: Colors.white,
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  Container(
                      decoration: BoxDecoration(
                        //color: MyColors.primaryColor.withOpacity(0.0),
                        image: DecorationImage(
                          image: const AssetImage(
                              "assets/images/drawer_bg_img.jpg"),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            MyColors.primaryColor.withOpacity(0.1),
                            BlendMode.darken,
                          ),
                        ),
                      ), //BoxDecoration
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 50, bottom: 20),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    // Set the clip behavior of the card
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    // Define the child widgets of the card
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: userimage.isNotEmpty
                                              ? userimage
                                              : image,
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            'assets/images/placeholder.png',
                                            // Path to your placeholder image asset
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Center(
                                                  child: Icon(Icons.error)),
                                        ),
                                        // child: Image.network(
                                        //   userimage.isNotEmpty ? userimage : image,
                                        //   loadingBuilder: (BuildContext context,
                                        //       Widget child,
                                        //       ImageChunkEvent? loadingProgress) {
                                        //     if (loadingProgress == null) {
                                        //       return child;
                                        //     } else {
                                        //       return Center(
                                        //         child: CircularProgressIndicator(
                                        //           value: loadingProgress
                                        //                       .expectedTotalBytes !=
                                        //                   null
                                        //               ? loadingProgress
                                        //                       .cumulativeBytesLoaded /
                                        //                   (loadingProgress
                                        //                           .expectedTotalBytes ??
                                        //                       1)
                                        //               : null,
                                        //         ),
                                        //       );
                                        //     }
                                        //   },
                                        //   errorBuilder: (BuildContext context,
                                        //       Object error, StackTrace? stackTrace) {
                                        //     return Icon(Icons
                                        //         .person); // Placeholder icon for error case
                                        //   },
                                        // ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: userName.isNotEmpty ||
                                        userEmail.isNotEmpty,
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                        children: [
                                          if (userName.isNotEmpty)
                                            TextSpan(
                                              text: '$userName\n',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          if (userName.isNotEmpty &&
                                              userMobile.isNotEmpty)
                                            const WidgetSpan(
                                              child: SizedBox(
                                                  height:
                                                      25), // Adjust the height as needed
                                            ),
                                          if (userMobile.isNotEmpty)
                                            TextSpan(
                                              text: '$userMobile',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // Center(
                          //   child: SvgPicture.string(
                          //     "assets/images/drawer_img.xml",
                          //     width: 500,
                          //     height: 500,
                          //   ),
                          // ),
                        ],
                      )),
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: MyColors.drawerIconColor,
                    ),
                    title: const Text(' Home '),
                    onTap: () {
                      _onItemTappedd(0);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.account_balance_wallet,
                      color: MyColors.drawerIconColor,
                    ),
                    title: const Text(' Transaction '),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TransactionScreen();
                      }));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.support_agent,
                      color: MyColors.drawerIconColor,
                    ),
                    title: const Text(' Customer Care '),
                    onTap: () {
                      //Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CustomerCare();
                      }));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.campaign,
                      color: MyColors.drawerIconColor,
                    ),
                    title: const Text(' Refer and Earn '),
                    onTap: () {
                      //Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return    ReferAndEarnScreen();
                      }));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: MyColors.drawerIconColor,
                    ),
                    title: const Text(' How to use app '),
                    onTap: () {
                      //Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HowItWorksScreen();
                      }));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.share_rounded,
                      color: MyColors.drawerIconColor,
                    ),
                    title: const Text(' Share '),
                    onTap: () {
                      _scaffoldKey.currentState?.closeDrawer();
                      shareNetworkImage("$image",
                          "\nCheck out this store on Discount Deals! \n\n *Download Now* \n\n $playstoreLink");
                      //Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: MyColors.drawerIconColor,
                    ),
                    title: const Text(' About Us '),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AboutUsScreen()),
                      );

                      // Call the function after returning
                      _handleReturnFromSecondScreen();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.book,
                      color: MyColors.drawerIconColor,
                    ),
                    title: const Text(' Terms & Condition '),
                    onTap: () {
                      //Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TermsAndCondition();
                      }));
                    },
                  ),
                  Visibility(
                    visible: user_id != 0,
                    child: ListTile(
                      leading: const Icon(
                        Icons.delete_sweep_rounded,
                        color: MyColors.drawerIconColor,
                      ),
                      title: const Text(' Account Delete '),
                      onTap: () {
                        //Navigator.pop(context);

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DeleteScreen();
                        }));

                        //logoutUser();
                      },
                    ),
                  ),
                  ListTile(
                    leading: user_id == 0
                        ? const Icon(
                            Icons.login_outlined,
                            color: MyColors.drawerIconColor,
                          )
                        : const Icon(
                            Icons.logout_outlined,
                            color: MyColors.drawerIconColor,
                          ),
                    title: user_id == 0
                        ? const Text(' Login ')
                        : const Text(' Logout '),
                    onTap: () {
                      //Navigator.pop(context);
                      if (user_id == 0) {
                        NavigationUtil.navigateToLogin(context);
                      } else {
                        logoutUser();
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(
              color: MyColors.primary,
            ),
          );
  }

  int filterIndex = 0;
  void showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        List<String> options = [
          "Relevance",
          "Distance: Nearby To Far",
          "Popularity: High to Low",
          "Cost for two: Low to High",
          "Cost for two: High to Low",
        ];

        String selectedOption = options[0]; // default

        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(options.length, (index) {
                return RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  value: options[index],
                  groupValue: selectedOption,
                  title: Text(
                    options[index],
                    style: TextStyle(color: MyColors.blackBG),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                      Provider.of<FilterViewModel>(context, listen: false).setFilterIndex(index);
                      print("Selected: $selectedOption");
                      Provider.of<FilterViewModel>(context, listen: false)
                          .filterApi(context, lat, long, "", "", "", [], []);
                    });
                  },
                  activeColor: MyColors.redBG,
                );
              }),
            ),
          );
        });
      },
    );
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

          print("storeeeeee: " + data.toString());

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

  List<FeaturesModel> featureData = [];
  // bool isLoading=false;
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

  List<FilteredDataModel> data = [];
  Future<void> filterApi(
    dynamic lat,
    dynamic long,
    dynamic rating,
    dynamic distance,
    dynamic discount,
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "latitude": lat,
        "longitude": long,
        "rating": rating,
        "discount": discount,
        "distance": distance,
        "amenities": "",
        "subcategory_id": "",
      };
      print("Amannnn:$body");
      final response = await ApiServices.filterApi(body, context);
      if (response != null) {
        print("Amannnn:$response");
        setState(() {
          data = response;
        });
      } else {
        // showErrorMessage(context, message: "message");
      }
    } catch (e) {
      print('fetchSubCategories: $e');
    } finally {
      // setModalState(() {
      //   isLoading = false;
      // });
    }
  }

  Future<void> navigateToAllCouponScreen(BuildContext context,
      String subCategoryName, String category_id, int subcategory_id) async {
    final route = MaterialPageRoute(
        builder: (context) => AllCouponScreen("$subCategoryName", "",
            "$category_id", "$subcategory_id", "", "", "", "", "$cityId", ""));
    await Navigator.push(context, route);
  }

  Future<void> fetchCity() async {
    try {
      final response = await ApiServices.api_show_city(context);
      print('fetchCity:response  $response');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'] as List<dynamic>;

        cityList = data.map((e) {
          return CityModel.fromMap(e);
        }).toList();
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      print('fetchCity: $e');
    }
  }

  Future<void> currentMembership(String user_id) async {
    print('current_membership user_id: $user_id');
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "user_id": user_id,
      };
      final response = await ApiServices.api_CurrentMembership(body);
      print('current_membership response: $response');
      if (response != null) {
        setState(() {
          planName = response.plan_name;
          left_day = "${response.left_day}";
        });
      } else {
        planName = '';
        left_day = '';
      }
    } catch (e) {
      print('Error: $e');
      planName = '';
      left_day = '';
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

  Widget _buildOfferCard(
      List<PreBookTableHistoryModel> prebookofferlistHistory) {
    return SizedBox(
      // height: 270, // Adjust height based on card content
      child: PageView.builder(
        itemCount: prebookofferlistHistory.length,
        controller: PageController(viewportFraction: 1.0),
        // Controls card width
        itemBuilder: (context, index) {
          var offer = prebookofferlistHistory[index];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Container(
                  height: 45,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColors.offerCardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${offer.title}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(12.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(color: MyColors.offerCardColor),
                      right: BorderSide(color: MyColors.offerCardColor),
                      bottom: BorderSide(color: MyColors.offerCardColor),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Left side: Title and Description
                          Expanded(
                            flex: 2, // Takes up 50% of the width
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TitleDescriptionWidget(
                                title: offer.store_name,
                                description: offer.address,
                                titleFontSize: 16,
                                descriptionFontSize: 13,
                              ),
                            ),
                          ),

                          // Right side: Icons (Phone, Location)
                          Expanded(
                            flex: 1, // Takes up 50% of the width
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centers the icons horizontally
                              children: [
                                if (offer.mobile.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      _makePhoneCall(offer.mobile);
                                    },
                                    child: _buildIcon(Icons.phone),
                                  ),
                                if (offer.map_link.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      _launchMaps(context, offer.map_link);
                                    },
                                    child: _buildIcon(Icons.location_on),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      DashedLine(
                        color: Color(0xFF757575),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildRowWithIcon(
                                    icon: Icons.phone,
                                    text:
                                        "Number of guests: ${offer.no_of_guest}",
                                  ),
                                  SizedBox(height: 5),
                                  _buildRowWithIcon(
                                    icon: Icons.calendar_month,
                                    text:
                                        "${offer.booking_date} at ${offer.booking_time}",
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TitleDescriptionWidget(
                            title: 'Status',
                            description: offer.table_status,
                            titleFontSize: 14,
                            descriptionFontSize: 12,
                            titleFontWeight: FontWeight.w400,
                            descriptionFontWeight: FontWeight.bold,
                            descriptionColor: MyColors.offerCardColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookedTableScreen("${offer.id}"),
                                  ),
                                );
                              },
                              child: _buildButton(
                                'View details',
                                MyColors.offerCardColor,
                                Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           TablePaybillScreen(
                                //               offer, offer.store_name,
                                //               offer.address)),
                                // );
                                if (isBookingTimePassed(
                                    offer.booking_date, offer.booking_time)) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TablePaybillScreen(
                                                offer,
                                                offer.store_name,
                                                offer.address)),
                                  );
                                }
                              },
                              child: _buildButton(
                                  'Pay bill',
                                  isBookingTimePassed(offer.booking_date,
                                          offer.booking_time)
                                      ? Colors.red
                                      : Colors.grey.shade300,
                                  isBookingTimePassed(offer.booking_date,
                                          offer.booking_time)
                                      ? Colors.white
                                      : Colors.grey),
                            ),
                          ),
                        ],
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

  _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      print('Error: Phone number is null or empty');
      return;
    }
    final url = 'tel:$phoneNumber';
    print(
        'Phone number: $phoneNumber'); // Print the phone number to the console
    try {
      await launch('$url');
    } catch (e) {
      print('Error launching phone call: $e');
      // Handle the error gracefully, such as displaying an error message to the user
    }
  }

  _launchMaps(BuildContext context, storeMap_link) async {
    // Use the provided storeMap_link if available
    String url = storeMap_link;

    // Check if storeMap_link is empty or null
    if (storeMap_link == null || storeMap_link.isEmpty) {
      showErrorMessage(context, message: "Map link not available");
      return;
    }

    // Check if any of the URLs can be launched
    if (await canLaunch(url)) {
      print('Launching map application');
      await launch(url);
    }
    // else if (await canLaunch(googleUrl)) {
    //   print('Launching Google Maps');
    //   await launch(googleUrl);
    // }
    // else if (await canLaunch(appleUrl)) {
    //   print('Launching Apple Maps');
    //   await launch(appleUrl);
    // }
    else {
      throw 'Could not launch map application';
    }
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      margin: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF6200EE),
      ),
      padding: EdgeInsets.all(8.0),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildRowWithIcon({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: MyColors.offerCardColor, size: 18.0),
        SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color backgroundColor, Color textColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Future<void> getName() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    final UserModel n = await SharedPref.getUser();
    print("name: " + n.name);
    userName = n.name;
  }

  Future<void> getBanners() async {
    print("ttttt");
    final UserModel user = await SharedPref.getUser();
    List<BannerModel> banners = user.banners;
    for (var banner in banners) {
      // setState(() {
      bannerId = banner.id.toString();
      bannerImage = banner.image;
      bannerType = banner.type;
      bannerURL = banner.url;
      bannerStatus = banner.status;
      // });
      print(banner.image);
      print("ttttt");
    }
  }

  Future<void> navigateToTopCategoriesScreen() async {
    final route = MaterialPageRoute(
        builder: (context) => TopCategoriesScreen("Categories", categories));

    await Navigator.push(context, route);
  }

  Future<void> navigateToTopSubCategories(
      BuildContext context, String categoryName, int categoryId) async {
    final route = MaterialPageRoute(
      builder: (context) => SubCategoriesScreen(categoryName, categoryId),
    );

    await Navigator.push(context, route);
  }

  Future<void> fetchShowSlider(
    String city_id,
  ) async {
    print(city_id);
    print("☕☕☕☕☕");
    try {
      final body = {
        "city_id": "$city_id",
      };
      final response = await ApiServices.Api_show_slider(body);
      if (response != null) {
        setState(() {
          imageSlider = response;
        });
      } else {
        setState(() {
          imageSlider = [];
        });
      }
    } catch (e) {
      setState(() {
        imageSlider.clear();
      });
      print('ShowSliderError: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await ApiServices.fetchCategories();
      if (response != null) {
        setState(() {
          categories = response;
        });
      }
    } catch (e) {
      print('fetchCategories: $e');
    }
  }

  Future<void> fetchRecentStore(
      String user_id,
      String store_limit,
      String cat_id,
      String subcat_id,
      String offer_id,
      String trending_status,
      String recent_status,
      String topcollection_status,
      String city_id,
      String localtiy_id) async {
    try {
      final body = {
        "user_id": "$user_id",
        "store_limit": "$store_limit",
        "cat_id": "$cat_id",
        "subcat_id": "$subcat_id",
        "offer_id": "$offer_id",
        "trending_status": "$trending_status",
        "recent_status": "$recent_status",
        "topcollection_status": "$topcollection_status",
        "city_id": "$city_id",
        "locality_id": "$localtiy_id",
      };
      final response = await ApiServices.all_store(body);
      if (response != null) {
        print('fetchRecentStore: if');
        print('fetchRecentStore: response: $response');
        setState(() {
          recentStoreList = response;
        });
      } else {
        setState(() {
          recentStoreList = [];
        });
      }
    } catch (e) {
      print('fetchRecentStore bottom Home Screen: $e');
    }
  }

  Future<void> fetchTrendingStore(
      String user_id,
      String store_limit,
      String cat_id,
      String subcat_id,
      String offer_id,
      String trending_status,
      String recent_status,
      String topcollection_status,
      String city_id,
      String localtiy_id) async {
    try {
      final body = {
        "user_id": "$user_id",
        "store_limit": "$store_limit",
        "cat_id": "$cat_id",
        "subcat_id": "$subcat_id",
        "offer_id": "$offer_id",
        "trending_status": "$trending_status",
        // "recent_status": "$recent_status",
        // "topcollection_status": "$topcollection_status",
        "city_id": "$city_id",
        "locality_id": "$localtiy_id",
      };

      final response = await ApiServices.trending_store(body);
      if (response != null) {
        setState(() {
          trendingStoreList = response;
        });
      } else {
        setState(() {
          trendingStoreList = [];
        });
      }
    } catch (e) {
      print('fetchRecentStore: $e');
    }
  }

  Future<void> fetchTopCollectionStore(
      String user_id,
      String store_limit,
      String cat_id,
      String subcat_id,
      String offer_id,
      String trending_status,
      String recent_status,
      String topcollection_status,
      String city_id,
      String localtiy_id) async {
    try {
      final body = {
        "user_id": "$user_id",
        "store_limit": "$store_limit",
        "cat_id": "$cat_id",
        "subcat_id": "$subcat_id",
        "offer_id": "$offer_id",
        "trending_status": "$trending_status",
        "recent_status": "$recent_status",
        "topcollection_status": "$topcollection_status",
        "city_id": "$city_id",
        "locality_id": "$localtiy_id",
      };
      final response = await ApiServices.all_store(body);
      if (response != null) {
        setState(() {
          topCollectionStoreList = response;
        });
      } else {
        setState(() {
          topCollectionStoreList = [];
        });
      }
    } catch (e) {
      print('fetchRecentStore: $e');
    }
  }

  Future<void> fetchGreatOffers1(String api_no) async {
    try {
      final response = await ApiServices.show_offer(api_no);
      if (response != null) {
        setState(() {
          greatOfferList1 = response;
        });
      }
    } catch (e) {
      print('fetchGreatOffers1: $e');
    }
  }

  Future<void> fetchGreatOffers2(String api_no) async {
    try {
      final response = await ApiServices.show_offer(api_no);
      if (response != null) {
        setState(() {
          greatOfferList2 = response;
        });
      }
    } catch (e) {
      print('fetchGreatOffers2: $e');
    }
  }

  Future<void> fetchWhatYourChoice() async {
    try {
      final body = {"category_id": ""};
      final response = await ApiServices.fetchSubCategories(body);
      if (response != null) {
        setState(() {
          wahtyourchoicList = response;
        });
      }
    } catch (e) {
      print('fetchSubCategories: $e');
    }
  }

  Future<void> fetchCityLocality(String city_id) async {
    try {
      final body = {"city_id": "$city_id"};

      final response = await ApiServices.ShowLocality(context, body);
      print('fetchCityLocality:response  $response');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'] as List<dynamic>;

        localtiyList = data.map((e) {
          return LocalityModel.fromMap(e);
        }).toList();
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
        //showErrorMessage(context, message: msg);
      }
    } catch (e) {
      print('fetchCityLocality: $e');
    }
  }

  Future<void> _navigateToSearchScreen(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchStoreScreen(
                  status: "0",
                )));
  }

  Future<void> UserPreBookTableHistory(String user_id) async {
    print('UserPreBookTableHistory: user_id $user_id');

    setState(() {
      isLoading = true;
    });

    try {
      final body = {"user_id": "$user_id"};
      final response = await ApiServices.UserPreBookTableHistory(body);
      print('UserPreBookTableHistory: response $response');
      if (response != null) {
        setState(() {
          prebookofferlistHistory = response;
          isLoading = false; // Set isLoading to false when fetching ends
        });
      } else {
        setState(() {
          prebookofferlistHistory = [];
          isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('UserPreBookTableHistory: $e');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }
}

class CustomDropdown extends StatefulWidget {
  final String selectedOption;
  final Function(String) onSelect;

  const CustomDropdown({
    required this.selectedOption,
    required this.onSelect,
    super.key,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String selected;

  List<String> options = [
    "Relevance",
    "Distance: Nearby To Far",
    "Popularity: High to Low",
    "Cost for two: Low to High",
    "Cost for two: High to Low",
  ];

  @override
  void initState() {
    selected = widget.selectedOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: Offset(0, 40),
      constraints: BoxConstraints(minWidth: 250),
      onSelected: (value) {
        setState(() {
          selected = value;
        });
        widget.onSelect(value);
      },
      itemBuilder: (context) {
        return options.map((e) {
          return PopupMenuItem(
            value: e,
            child: Row(
              children: [
                Icon(
                  selected == e
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected == e ? Colors.orange : Colors.grey,
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(child: Text(e, style: TextStyle(fontSize: 14))),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Text(
              selected,
              style: TextStyle(fontSize: 12),
            ),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

//What your choice
class YourChoiceHomeWidget extends StatelessWidget {
  final List<SubCategoriesModel> yourChoiceItems;
  String city_id;

  YourChoiceHomeWidget(this.yourChoiceItems, this.city_id, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 120,
        child: ListView.builder(
          itemBuilder: (context, index) {
            final item = yourChoiceItems[index];
            return buildYourChoiceWidget(context, item);
          },
          itemCount: yourChoiceItems.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget buildYourChoiceWidget(BuildContext context, SubCategoriesModel item) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AllCouponScreen("${item.subcategory_name}", "", "",
              "${item.id}", "", "", "", "", "$city_id", "");
        }));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0),
              child: Center(
                child: Text(
                  item.subcategory_name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//TrendingResturant
class TrendingRestruantWidget extends StatelessWidget {
  final List<StoreModel> restaurantsItems;

  TrendingRestruantWidget(this.restaurantsItems, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
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
                height: 290,
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

// Widget buildRestaurantsWidget(BuildContext context, int id, String imgUrl,
//     String restaurantName, String location, String distance, String offers) {
//   return Container(
//     margin: EdgeInsets.only(left: 10, right: 5),
//     child: InkWell(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) {
//           return CouponFullViewScreen("$id");
//         }));
//       },
//       child: Card(
//         color: Colors.white,
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             // Container(
//             //   width: 250,
//             //   child: Column(
//             //     children: [
//             //       Container(
//             //         height: 282,
//             //         decoration: BoxDecoration(
//             //           image: DecorationImage(
//             //             image: NetworkImage(imgUrl),
//             //             fit: BoxFit.fill,
//             //           ),
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             Container(
//               width: 250,
//               child: Column(
//                 children: [
//                   FadeInImage(
//                     placeholder: AssetImage("assets/images/placeholder.png"),
//                     // Placeholder image
//                     image: NetworkImage(imgUrl),
//                     // Network image
//                     fit: BoxFit.fill,
//                     width: double.infinity,
//                     height: 282,
//                   ),
//                 ],
//               ),
//             ),
//
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black87, Colors.black],
//                 ),
//               ),
//               height: 120,
//               width: 250,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.fromLTRB(12, 5, 25, 5),
//                     decoration: BoxDecoration(
//                         shape: BoxShape.rectangle,
//                         color: MyColors.blueBG,
//                         borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(20),
//                             bottomRight: Radius.circular(20))),
//                     child: Expanded(
//                       // Use Expanded to allow text to wrap if needed
//                       child: Text(
//                         "Offer :- $offers",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                           fontSize: 18,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 15),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           // Use Expanded to allow text to wrap if needed
//                           child: Text(
//                             restaurantName,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               color: MyColors.whiteBG,
//                               fontSize: 19,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Container(
//                   //   margin: EdgeInsets.only(left: 15, top: 8, bottom: 15),
//                   //   child: Row(
//                   //     children: [
//                   //       Expanded( // Use Expanded to allow text to wrap if needed
//                   //         child: Text(
//                   //           location,
//                   //           style: TextStyle(
//                   //             fontWeight: FontWeight.w200,
//                   //             color: MyColors.whiteBG,
//                   //             fontSize: 12,
//                   //             overflow: TextOverflow.ellipsis,
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}

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
                      fontWeight: FontWeight.w500),
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
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Text(
              categoryName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 35.0),
            child: Container(
              alignment: Alignment.center,
              height: heights * 0.03,
              width: widths * 0.4,
              decoration: BoxDecoration(
                  color: MyColors.whiteBG,
                  borderRadius: BorderRadius.circular(25)),
              child: Text(
                "Book Table",
                style: TextStyle(fontSize: 12),
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
                fontWeight: FontWeight.w700,
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

class LocationWidget extends StatelessWidget {
  final List<LocalityModel> locationItems;

  LocationWidget(this.locationItems, {super.key});

  @override
  Widget build(BuildContext context) {
    if (locationItems.isEmpty) {
      return SizedBox.shrink(); // Return an empty widget if the list is empty
    }

    return Container(
      height: 135,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return locationCard(context, locationItems[index]);
        },
        itemCount: locationItems.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget locationCard(BuildContext context, LocalityModel locality) {
    return InkWell(
      onTap: () {
        navigateToAllCouponScreen(context, "${locality.locality}",
            "${locality.city_id}", "${locality.id}");
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: locality.image,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/placeholder.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              locality.locality,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> navigateToAllCouponScreen(BuildContext context,
      String locationName, String city_id, String localtiy_id) async {
    //showErrorMessage(context, message: "city_id: "+city_id+", localtiyId: "+localtiy_id);
    final route = MaterialPageRoute(
        builder: (context) => AllCouponScreen("$locationName", "", "", "", "",
            "", "", "", "$city_id", "$localtiy_id"));
    await Navigator.push(context, route);
  }
}

//Top Collection
class TopCollectionWidget extends StatelessWidget {
  List<StoreModel> restaurantsItems;
  dynamic leftMrgin;

  TopCollectionWidget(this.restaurantsItems, this.leftMrgin, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.width * 0.32,
      child: ListView.builder(
        itemBuilder: (context, index) {
          //return buildRestaurantsWidget(context, "" + restaurantsItems[index]['imgUrl']);
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.only(left: leftMrgin),
              child: buildRestaurantsWidget(
                  context,
                  "" + restaurantsItems[index].logo,
                  restaurantsItems[index].id),
            );
          } else {
            // For other items, no left margin
            return buildRestaurantsWidget(context,
                "" + restaurantsItems[index].logo, restaurantsItems[index].id);
          }
        },
        itemCount: restaurantsItems.length,
        //reverse: true,
        //itemExtent: 100,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget buildRestaurantsWidget(BuildContext context, String imgUrl, int id) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 2),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CouponFullViewScreen("$id");
          }));
        },
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.3, // Adjust the width according to your requirement
            height: MediaQuery.of(context).size.width *
                0.3, // Adjust the height according to your requirement
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
          ),
        ),
      ),
    );
  }
}

class RestaurantCard extends StatefulWidget {
  // final Restaurant restaurant;
  final int index;
  final String name;
  final Data filter;

  RestaurantCard(
      {required this.index, required this.name, required this.filter});

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
                            }).toList() ??
                            [],
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
                                          fontWeight: FontWeight.w500,
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
                                  fontWeight: FontWeight.w500,
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
                            // Icon(Icons.favorite_border, color: Colors.white),
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
                                      fontSize: 11,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
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
                              child: StarRating(
                                color: Colors.yellow,
                                rating: double.parse(widget.filter.avgRating
                                    .toStringAsFixed(1)
                                    .toString()),
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.filter.address.toString(),
                          style: TextStyle(
                              color: MyColors.textColorTwo, fontSize: 12),
                        ),
                        Divider(
                          color: MyColors.textColorTwo.withOpacity(0.3),
                        ),
                        widget.filter.dish != null
                            ? Text(
                                widget.filter.dish.toString(),
                                style: TextStyle(
                                    color: MyColors.textColorTwo, fontSize: 14),
                              )
                            : Container(),
                        widget.filter.dish != null
                            ? Divider(
                                color: MyColors.textColorTwo.withOpacity(0.3),
                              )
                            : Container(),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 58.0),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Stack(
                        //         children:
                        //         avatars.asMap().entries.map((entry) {
                        //           int idx = entry.key;
                        //           String avatar = entry.value;
                        //           final remaning = avatars.length-maxVisibleAvatars;
                        //           return Transform.translate(
                        //             offset: Offset(idx * -12.0, 0),
                        //             child: Container(
                        //               width: widths * 0.06,
                        //               height: heights * 0.05,
                        //               decoration: BoxDecoration(
                        //                 shape: BoxShape.circle,
                        //                 image: DecorationImage(
                        //                     image: AssetImage(avatar)),
                        //                 border: Border.all(
                        //                     color: MyColors.whiteBG, width: 1),
                        //               ),
                        //             ),
                        //           );
                        //         }).toList(),
                        //       ),
                        //
                        //     ],
                        //   ),
                        // ),
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
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
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
                                child: Text("View >",style:TextStyle(color: MyColors.redBG,fontWeight: FontWeight.w500),))
                          ],
                        ),
                        Container(
                          width: widths,
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                          decoration: BoxDecoration(
                              color: Color(0xff00bd62),
                              borderRadius: BorderRadius.circular(3)),
                          child: Text(
                              widget.filter.offers != ""
                                  ? "% Flat ${widget.filter.discountPercentage.toString()}% off on pre-booking       +${widget.filter.offers.toString()} offers"
                                  : "% Flat ${widget.filter.discountPercentage.toString() ?? ""}% off on pre-booking",
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

          print("storeeeeee: " + data.toString());

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
