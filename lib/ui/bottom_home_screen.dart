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
import 'package:grabto/ui/recent_joined_page.dart';
import 'package:grabto/ui/refer_and_earn.dart';
import 'package:grabto/ui/search_screen.dart';
import 'package:grabto/ui/select_address_screen.dart';
import 'package:grabto/ui/subcategories_screen.dart';
import 'package:grabto/ui/term_and_condition.dart';
import 'package:grabto/ui/top_categories_screen.dart';
import 'package:grabto/ui/table_paybill_screen.dart';
import 'package:grabto/ui/total_visit_screen.dart';
import 'package:grabto/ui/transaction_screen.dart';
import 'package:grabto/ui/trending_restaurants_page.dart';
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
import '../view_model/profile_view_model.dart';
import '../widget/sub_categories_card_widget.dart';
import 'about_us_screen.dart';
import 'account_setting.dart';
import 'customer_care.dart';
import 'filter_boottom_sheet.dart';
import 'home_restaurent_card.dart';
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
  List<BannerModel> banner=[];
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
    Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
    _scrollController.addListener(_handleScroll);
    _instance = this;
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_){

      getUserDetails();
      fetchSubCategories(5);
      getBanners();

      Provider.of<DifferentLocationViewModel>(context, listen: false).differentLocationApi(context);
      Provider.of<GrabtoGrabViewModel>(context, listen: false).grabtoGrabApi(context);
      Provider.of<NearMeImageViewModel>(context, listen: false).nearMeImageApi(context);
    });

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
      banner=n.banners;
    });
    // Provider.of<FilterViewModel>(context, listen: false)
    //     .filterApi(context,profile?.lat??"", profile?.long, "", "", "", [], []);
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
    final profile = Provider.of<ProfileViewModel>(context).profileData.data?.data;
    final differentLocation = Provider.of<DifferentLocationViewModel>(context);
    final data = Provider.of<FilterViewModel>(context);
    final grab = Provider.of<GrabtoGrabViewModel>(context).grabList.data?.data;
    final nearImage = Provider.of<NearMeImageViewModel>(context).imageList.data;
    List<dynamic> dishList = grab?[0].dish.split(',').map((e) => e.trim()).toList()??[];
    print(location.area);
    final imageList = grab?[0].image ?? [];
    return
      categories.isNotEmpty?
    Scaffold(
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
                          // print(banner[0].url);
                          print(profile?.banner?[0].url);
                          print("widget.bannersDa[0].url");
                          // profile.banner
                          profile?.banner?[0].type == "1"
                              ? navigateToAllCouponScreen(
                                  context,
                              profile?.banner?[0].subcategoryName,
                              profile?.banner?[0].categoryId,
                              profile?.banner?[0].id)
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CouponFullViewScreen(
                                              "${profile?.banner?[0].url}")));
                        },
                        child: Container(
                          height: heights * 0.53,
                          decoration: BoxDecoration(
                              // color: Colors.red,
                              image: DecorationImage(
                                  image:CachedNetworkImageProvider(profile?.banner?[0].image??""),
                                  // NetworkImage(profile?.banner?[0].image??""),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 40, left: 0, bottom: 20,right: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      child: Container(
                                        height: heights*0.06,
                                        width: widths*0.13,
                                        color: Colors.transparent,
                                        child: const Icon(
                                          Icons.menu,
                                          color: MyColors.whiteBG,
                                        ),
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
                                      child: SizedBox(width: widths * 0.67,

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
                                                          profile?.address != null && profile!.address!.isNotEmpty
                                                              ? profile!.address!.split(',')[0]
                                                              : location.address.toString(),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: 'wix',
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
                                                SizedBox(
                                                    width: widths * 0.57,
                                                    child: Text(
                                                      profile?.address != null && profile!.address!.isNotEmpty
                                                          ? profile?.address
                                                          : location.area,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontFamily: 'wix',
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
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ReferAndEarnScreen()));
                                      },
                                      child: Container(
                                        height: heights*0.06,
                                        color: Colors.transparent,
                                        padding: const EdgeInsets.only(left: 5),
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: MyColors.whiteBG,
                                          child: Icon(Icons.account_balance_wallet,size: 16,color: MyColors.redBG,),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: heights*0.06,
                                      padding: const EdgeInsets.only(right: 10),
                                      color: Colors.transparent,
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: MyColors.whiteBG,
                                        child: Icon(Icons.notifications,size: 16,),
                                      ),
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
                                        horizontal: 15, vertical: 7),
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
                              viewportFraction: 0.93,
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
                        SizedBox(
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
                            top: 20,
                            left: 14,
                            right: 14,
                            bottom: 10,
                          ),
                          height: heights * 0.17,
                          width: widths,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            // image: DecorationImage(
                            //     image: NetworkImage(nearImage?.data?[0].image??""),
                            //     fit: BoxFit.fill),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: nearImage?.data?[0].image??"",
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              errorWidget: (context, url, error) =>
                                  Center(child:Image.asset(
                                    'assets/images/placeholder.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )),
                            ),
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
                                  mainAxisExtent: heights*0.239),
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
                              height: heights * 0.64,
                              margin: EdgeInsets.symmetric(vertical: heights*0.02),
                              decoration: BoxDecoration(
                                  // color: MyColors.redBG,
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        grab?[0].backgroundimage,
                                      ),fit: BoxFit.fill
                                      // NetworkImage(
                                      //     grab?[0].backgroundimage),
                                      // fit: BoxFit.fill
                                  )
                              ),
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
                                          horizontal: 15, vertical: 0),
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
                                                  height: heights * 0.27,
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
                                                        "${grab[0].avgRating ?? "0"}/5",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'wix',fontWeight: FontWeight.w600,
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
                                                right: 10,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: RichText(
                                                        textAlign: TextAlign.center,
                                                        // Center align the text
                                                        text: TextSpan(
                                                          text:
                                                          "₹${grab[0].amount}",
                                                          style: TextStyle(
                                                              fontFamily: 'wix',fontWeight: FontWeight.w600,
                                                              color: MyColors.whiteBG
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: "\n for two",
                                                              style: TextStyle(
                                                                  color: MyColors.whiteBG,
                                                                  fontSize: 12,
                                                                  fontFamily: 'wix',fontWeight: FontWeight.w600
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: widths * 0.58,
                                                      // color: Colors.red,
                                                      child: Text(
                                                        grab?[0]
                                                                .storeName
                                                                .toString() ??
                                                            "",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: 'wix',fontWeight: FontWeight.w600),
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
                                                  grab[0].address.toString() ??
                                                      "",
                                                  style: TextStyle(
                                                      color:
                                                          MyColors.textColorTwo,
                                                      fontFamily: 'wix',fontWeight: FontWeight.w600),
                                                ),
                                                Divider(
                                                  color: MyColors.textColorTwo.withAlpha(20),
                                                ),
                                                SizedBox(
                                                  width: widths*0.8,
                                                  // height: heights*0.1,
                                                  // color: Colors.red,
                                                  child: GridView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    // physics: NeverScrollableScrollPhysics(),
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
                                                      return  Container(
                                                        padding:EdgeInsets.all(5),
                                                        // margin:EdgeInsets.all(5),
                                                        color:MyColors.textColorTwo.withAlpha(10),
                                                        child: Center(
                                                          child: Text(
                                                            data,
                                                            style: TextStyle(
                                                                fontFamily: 'wix',fontWeight: FontWeight.w600,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                  // ListView.builder(
                                                  //   shrinkWrap: true,
                                                  //   itemCount:dishList.length,
                                                  //   scrollDirection: Axis.horizontal,
                                                  //   itemBuilder: (context, index) {
                                                  //     final data = dishList[index];
                                                  //     return  Container(
                                                  //       // padding:EdgeInsets.all(15),
                                                  //       margin:EdgeInsets.all(5),
                                                  //       color: Colors.red,
                                                  //       child: Text(
                                                  //           data,
                                                  //         // grab?[0].dish.toString() ??
                                                  //         //     "",
                                                  //         style: TextStyle(
                                                  //             color:
                                                  //             MyColors.textColorTwo,
                                                  //             fontSize: 12),
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),
                                                ),
                                                Divider(
                                                  color: MyColors.textColorTwo.withAlpha(20),
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
                                                  child: Text(grab[0].title !=""?grab[0].title: "",
                                                     // grab[0].title,
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
                                            grab[0].id.toString() ?? "");
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
                                                  fontFamily: 'wix',fontWeight: FontWeight.w600,
                                                  fontSize: 13),
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
                      //   Container(
                      //     margin: EdgeInsets.only(
                      //         top: 25, left: 15, right: 15, bottom: 15),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           "Popular Location",
                      //           style: TextStyle(
                      //               fontSize: 18, fontWeight: FontWeight.w500),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // if (!localtiyList.isEmpty)
                      //   LocationWidget(localtiyList),
                      if (!trendingStoreList.isEmpty)
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
                                    fontSize: 14,fontFamily:'wix',fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      if (!trendingStoreList.isEmpty)
                        TrendingRestruantWidget(trendingStoreList),
                      // if (!recentStoreList.isEmpty)
                        if (!recentStoreList.isEmpty)
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
                              "Taste from different location?",
                              style: TextStyle(
                                  fontSize: 14,   fontFamily: 'wix',fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: heights * 0.1,
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
                                    context, data?.locality ?? "");
                              },
                              child: Container(
                                width: widths*0.18,
                                // padding: EdgeInsets.symmetric(
                                //     vertical: 20, horizontal: 20),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                // height: heights*0.03,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  // image: DecorationImage(image: NetworkImage(data?.image??""),fit: BoxFit.fill),
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
                                child: CachedNetworkImage(
                                  imageUrl: data?.image??"",
                                      // .toString(),
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
                                    fontSize: 14,  fontFamily: 'wix',fontWeight: FontWeight.w600),
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
                                        profile?.lat,
                                        profile?.long,
                                                featureData,
                                                subCategoriesList)
                                            : index == 1
                                                ? showSortBottomSheet(context)
                                                : index == 2
                                                    ? data.filterApi(
                                                        context,
                                        profile?.lat,
                                        profile?.long,
                                                        "4",
                                                        "",
                                                        "", [], [])
                                                    : index == 3
                                                        ? data.filterApi(
                                                            context,
                                      profile?.lat,
                                      profile?.long,
                                                            "",
                                                            "5",
                                                            "",
                                                            [],
                                                            [],
                                                          )
                                                        : data.filterApi(
                                                            context,
                                        profile?.lat,
                                        profile?.long,
                                                            "",
                                                            "",
                                                            "10", [], [])
                                        : null;
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
                                              fontFamily: 'wix',fontWeight: FontWeight.w600),
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
                           else if (  data.filterList.data!.data!.isNotEmpty)
                           ListView.builder(
                             shrinkWrap: true,
                             padding: EdgeInsets.zero,
                             itemCount:10,
                                 // data.filterList.data?.data?.length ?? 0,
                             physics: NeverScrollableScrollPhysics(),
                             itemBuilder: (context, index) {
                               List<Data> sortedList = List.from(data.filterList.data?.data ?? []);
                               if (data.filterIndex == 1) {
                                 double userLat = double.tryParse(profile?.lat) ?? 0;
                                 double userLng = double.tryParse(profile?.long) ?? 0;

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
                                   : HomeScreenRestaurantCard(
                                       index: index,
                                       name: selectedName,
                                       filter: sortedList[index]
                               );
                             },
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
                                      fontFamily: 'wix',fontWeight: FontWeight.w600),
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
                                    profile?.lat,
                                    profile?.long,
                                            featureData,
                                            subCategoriesList)
                                        : index == 1
                                            ? data.filterApi(context, profile?.lat, profile?.long,
                                                "4", "", "", [], [])
                                            : index == 2
                                                ? data.filterApi(
                                                    context,
                                  profile?.lat,
                                  profile?.long,
                                                    "",
                                                    "5",
                                                    "",
                                                    [],
                                                    [],
                                                  )
                                                : data.filterApi(context, profile?.lat,
                                    profile?.long, "", "", "10", [], [])
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
            // drawer: Drawer(
            //   backgroundColor: Colors.white,
            //   child: ListView(
            //     padding: const EdgeInsets.all(0),
            //     children: [
            //       Container(
            //           decoration: BoxDecoration(
            //             //color: MyColors.primaryColor.withOpacity(0.0),
            //             image: DecorationImage(
            //               image: const AssetImage(
            //                   "assets/images/drawer_bg_img.jpg"),
            //               fit: BoxFit.cover,
            //               colorFilter: ColorFilter.mode(
            //                 MyColors.primaryColor.withOpacity(0.1),
            //                 BlendMode.darken,
            //               ),
            //             ),
            //           ), //BoxDecoration
            //           child: Stack(
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.only(
            //                     left: 20, right: 20, top: 50, bottom: 20),
            //                 child: Container(
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Card(
            //                         elevation: 2,
            //                         shape: RoundedRectangleBorder(
            //                           borderRadius: BorderRadius.circular(40),
            //                         ),
            //                         // Set the clip behavior of the card
            //                         clipBehavior: Clip.antiAliasWithSaveLayer,
            //                         // Define the child widgets of the card
            //                         child: SizedBox(
            //                           width: 70,
            //                           height: 70,
            //                           child: ClipOval(
            //                             child: CachedNetworkImage(
            //                               imageUrl: profile?.image.isNotEmpty
            //                                   ? profile?.image
            //                                   : image,
            //                               fit: BoxFit.fill,
            //                               placeholder: (context, url) =>
            //                                   Image.asset(
            //                                 'assets/images/placeholder.png',
            //                                 // Path to your placeholder image asset
            //                                 fit: BoxFit.cover,
            //                                 width: double.infinity,
            //                                 height: double.infinity,
            //                               ),
            //                               errorWidget: (context, url, error) =>
            //                                   const Center(
            //                                       child: Icon(Icons.error)),
            //                             ),
            //                             // child: Image.network(
            //                             //   userimage.isNotEmpty ? userimage : image,
            //                             //   loadingBuilder: (BuildContext context,
            //                             //       Widget child,
            //                             //       ImageChunkEvent? loadingProgress) {
            //                             //     if (loadingProgress == null) {
            //                             //       return child;
            //                             //     } else {
            //                             //       return Center(
            //                             //         child: CircularProgressIndicator(
            //                             //           value: loadingProgress
            //                             //                       .expectedTotalBytes !=
            //                             //                   null
            //                             //               ? loadingProgress
            //                             //                       .cumulativeBytesLoaded /
            //                             //                   (loadingProgress
            //                             //                           .expectedTotalBytes ??
            //                             //                       1)
            //                             //               : null,
            //                             //         ),
            //                             //       );
            //                             //     }
            //                             //   },
            //                             //   errorBuilder: (BuildContext context,
            //                             //       Object error, StackTrace? stackTrace) {
            //                             //     return Icon(Icons
            //                             //         .person); // Placeholder icon for error case
            //                             //   },
            //                             // ),
            //                           ),
            //                         ),
            //                       ),
            //                       const SizedBox(
            //                         width: 10,
            //                         height: 10,
            //                       ),
            //                       Visibility(
            //                         visible: profile?.name.isNotEmpty ||
            //                             profile?.email.isNotEmpty,
            //                         child: RichText(
            //                           text: TextSpan(
            //                             style: const TextStyle(
            //                               color: Colors.black,
            //                               fontSize: 20,
            //                             ),
            //                             children: [
            //                               if (profile?.name.isNotEmpty)
            //                                 TextSpan(
            //                                   text: '${profile?.name}\n',
            //                                   style: const TextStyle(
            //                                     fontSize: 20,
            //                                     color: Colors.black,
            //                                     fontWeight: FontWeight.bold,
            //                                   ),
            //                                 ),
            //                               if (profile?.name.isNotEmpty &&
            //                                   profile?.mobile.isNotEmpty)
            //                                 const WidgetSpan(
            //                                   child: SizedBox(
            //                                       height:
            //                                           25), // Adjust the height as needed
            //                                 ),
            //                               if (profile?.mobile.isNotEmpty)
            //                                 TextSpan(
            //                                   text: profile?.mobile??"",
            //                                   style: TextStyle(
            //                                     fontSize: 17,
            //                                     color: Colors.black
            //                                         .withOpacity(0.7),
            //                                   ),
            //                                 ),
            //                             ],
            //                           ),
            //                         ),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               // Center(
            //               //   child: SvgPicture.string(
            //               //     "assets/images/drawer_img.xml",
            //               //     width: 500,
            //               //     height: 500,
            //               //   ),
            //               // ),
            //             ],
            //           )),
            //       ListTile(
            //         leading: const Icon(
            //           Icons.home,
            //           color: MyColors.drawerIconColor,
            //         ),
            //         title: const Text(' Home '),
            //         onTap: () {
            //           _onItemTappedd(0);
            //         },
            //       ),
            //       ListTile(
            //         leading: const Icon(
            //           Icons.account_balance_wallet,
            //           color: MyColors.drawerIconColor,
            //         ),
            //         title: const Text(' Transaction '),
            //         onTap: () {
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) {
            //             return TransactionScreen();
            //           }));
            //         },
            //       ),
            //       ListTile(
            //         leading: const Icon(
            //           Icons.support_agent,
            //           color: MyColors.drawerIconColor,
            //         ),
            //         title: const Text(' Customer Care '),
            //         onTap: () {
            //           //Navigator.pop(context);
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) {
            //             return CustomerCare();
            //           }));
            //         },
            //       ),
            //       ListTile(
            //         leading: const Icon(
            //           Icons.campaign,
            //           color: MyColors.drawerIconColor,
            //         ),
            //         title: const Text(' Refer and Earn '),
            //         onTap: () {
            //           //Navigator.pop(context);
            //           Navigator.push(context, MaterialPageRoute(builder: (context) {
            //             return    ReferAndEarnScreen();
            //           }));
            //         },
            //       ),
            //       ListTile(
            //         leading: const Icon(
            //           Icons.settings,
            //           color: MyColors.drawerIconColor,
            //         ),
            //         title: const Text(' How to use app '),
            //         onTap: () {
            //           //Navigator.pop(context);
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) {
            //             return HowItWorksScreen();
            //           }));
            //         },
            //       ),
            //       ListTile(
            //         leading: const Icon(
            //           Icons.share_rounded,
            //           color: MyColors.drawerIconColor,
            //         ),
            //         title: const Text(' Share '),
            //         onTap: () {
            //           _scaffoldKey.currentState?.closeDrawer();
            //           shareNetworkImage("$image",
            //               "\nCheck out this store on Discount Deals! \n\n *Download Now* \n\n $playstoreLink");
            //           //Navigator.pop(context);
            //         },
            //       ),
            //       ListTile(
            //         leading: const Icon(
            //           Icons.info_outline,
            //           color: MyColors.drawerIconColor,
            //         ),
            //         title: const Text(' About Us '),
            //         onTap: () async {
            //           final result = await Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => AboutUsScreen()),
            //           );
            //
            //           // Call the function after returning
            //           _handleReturnFromSecondScreen();
            //         },
            //       ),
            //       ListTile(
            //         leading: const Icon(
            //           Icons.book,
            //           color: MyColors.drawerIconColor,
            //         ),
            //         title: const Text(' Terms & Condition '),
            //         onTap: () {
            //           //Navigator.pop(context);
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) {
            //             return TermsAndCondition();
            //           }));
            //         },
            //       ),
            //       Visibility(
            //         visible: user_id != 0,
            //         child: ListTile(
            //           leading: const Icon(
            //             Icons.delete_sweep_rounded,
            //             color: MyColors.drawerIconColor,
            //           ),
            //           title: const Text(' Account Delete '),
            //           onTap: () {
            //             //Navigator.pop(context);
            //
            //             Navigator.push(context,
            //                 MaterialPageRoute(builder: (context) {
            //               return DeleteScreen();
            //             }));
            //
            //             //logoutUser();
            //           },
            //         ),
            //       ),
            //       ListTile(
            //         leading: user_id == 0
            //             ? const Icon(
            //                 Icons.login_outlined,
            //                 color: MyColors.drawerIconColor,
            //               )
            //             : const Icon(
            //                 Icons.logout_outlined,
            //                 color: MyColors.drawerIconColor,
            //               ),
            //         title: user_id == 0
            //             ? const Text(' Login ')
            //             : const Text(' Logout '),
            //         onTap: () {
            //           //Navigator.pop(context);
            //           if (user_id == 0) {
            //             NavigationUtil.navigateToLogin(context);
            //           } else {
            //             logoutUser();
            //           }
            //         },
            //       ),
            //     ],
            //   ),
            // ),
          )
        : Center(
            child: CircularProgressIndicator(
              color: MyColors.redBG,
            ),
          );
  }

  int filterIndex = 0;
  void showSortBottomSheet(BuildContext context) {
    final profile = Provider.of<ProfileViewModel>(context,listen: false).profileData.data?.data;

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
                          .filterApi(context, profile?.lat, profile?.long, "", "", "", [], []);
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
print(body);
print("📞📞📞📞");
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
      child: SizedBox(
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
                  // image: DecorationImage(
                  //   image: NetworkImage(item.image),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: CachedNetworkImage(
                  imageUrl:item.image,
                  // .toString(),
                  fit: BoxFit.cover,
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



class LocationWidget extends StatelessWidget {
  final List<LocalityModel> locationItems;

  LocationWidget(this.locationItems, {super.key});

  @override
  Widget build(BuildContext context) {
    if (locationItems.isEmpty) {
      return SizedBox.shrink(); // Return an empty widget if the list is empty
    }

    return SizedBox(
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
            SizedBox(
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
    return SizedBox(
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
          child: SizedBox(
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


