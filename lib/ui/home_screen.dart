import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/helper/user_provider.dart';
import 'package:grabto/main.dart';
import 'package:grabto/model/city_model.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/services/api.dart';
import 'package:grabto/services/api_services.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/bottom_categories_screen.dart';
import 'package:grabto/ui/bottom_home_screen.dart';
import 'package:grabto/ui/bottom_login_screen.dart';
import 'package:grabto/ui/profile/bottom_profile_screen.dart';
import 'package:grabto/ui/bottom_sortlist_screen.dart';
import 'package:grabto/ui/explore_screen.dart';
import 'package:grabto/ui/restaurant_payment_screen.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:grabto/widget/item_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/location_provider.dart';
import '../view_model/profile_view_model.dart';
import 'account_setting.dart';
import 'flicks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  List<CityModel> cityList = [];
  String userName = '';
  String userEmail = '';
  String userMobile = '';
  String userimage = '';
  String dialogimage = '';
  String current_location = '';
  String home_location = '';
  String planName = '';
  String left_day = '';
  String gatewayStatus = '';
  String externalStatus = '';
  int user_id = 0;

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    await getUserDetails();
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
    SharedPref.getGatewayStatus().then((gateway) {
      gatewayStatus = gateway;
      print("gatewayStatus status: " + gatewayStatus);
    }).catchError((error) {
      print('Failed to get gateway status: $error');
    });
    SharedPref.getExternalLinkStatus().then((external) {
      externalStatus = external;
      print("gatewayStatus externalStatus: " + externalStatus);
    }).catchError((error) {
      print('Failed to get gateway status: $error');
    });

    WidgetsBinding.instance.addObserver(this);
    allApiCallHome();
  }

  @override


  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // Call your function when the app resumes
      if (user_id != 0) {
        HomeBottamScreen.instance!.UserPreBookTableHistory("$user_id");
        await getUserDetails();
        await fetchCity();
        await currentMembership("$user_id");
      }
    }
  }

  Future<void> _fetchMembership() async {
    await currentMembership("$user_id");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void allApiCallHome() async {
    setState(() {
      isLoading = true;
    });

    try {
      await getUserDetails();
      await fetchCity();
      await api_popup_dialog(context);
    } catch (e) {
      print('Error in API calls: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showCityDialog() async {
    final CityModel? selectedCity = await showDialog<CityModel>(
      context: context,
      builder: (BuildContext context) {
        return ItemListDialog(items: cityList);
      },
    );

    if (selectedCity != null) {
      if (user_id == 0) {
        setState(() {
          home_location = "${selectedCity.id}";
          current_location = "${selectedCity.city}";
          SharedPref.updateHomeLocation(home_location);
          SharedPref.updateCurrentLocation(current_location);

          if (HomeBottamScreen.instance != null) {
            HomeBottamScreen.instance!.getUserDetails();
          }
        });
      } else {
        user_city_updated("$user_id", "${selectedCity.id}");
      }
    }
  }

  _launchExternalMambership(String user_id) async {
    String url = '$externalPaymentGateway/$user_id';

    // Check if any of the URLs can be launched
    if (await canLaunch(url)) {
      print('Launching map application');
      await launch(url);
    } else {
      throw 'Could not launch map application';
    }
  }

  Future<void> _handleReturnFromSecondScreen() async {
    // This function will be called when returning from the second screen
    print('Returned from HomeScreen');
    await getUserDetails();
    await fetchCity();
    await currentMembership("$user_id");
  }
  Future<bool> _onWillPop() async {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    } else {
      return await showExitConfirmation(context) ?? true;
    }
  }
  final List<String> _image = [
    "assets/images/home_app_logo.png",
    "assets/images/menu_Icons.png",
    "assets/images/add_card.png",
    "assets/images/auto_read_play.png",
    "assets/images/home_app_logo.png",
  ];

  final List<String> _labels = [
    "Home",
    "Explore",
    "Pay Bill",
    "Flicks",
    "Profile",
  ];
  @override
  Widget build(BuildContext context) {
    final address=Provider.of<Address>(context);
    final profile = Provider.of<ProfileViewModel>(context).profileData.data?.data;
print("dsd ${banners.length}");
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.backgroundBg,
      appBar:_selectedIndex!=0&&_selectedIndex!=3&&_selectedIndex!=4&& _selectedIndex!=1?AppBar(
        backgroundColor: MyColors.backgroundBg,
        leadingWidth: 20,
        leading: GestureDetector(
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
            color: MyColors.blackBG,
          ),
        ),
        centerTitle: true,
        title:_selectedIndex==1? Text("Explore"):_selectedIndex==2?Text("Pay Bill"):_selectedIndex==3? Text("Flicks"): Text("Profile"),
      actions:_selectedIndex==4? [
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountSettingsScreen()));
          },
          child: CircleAvatar(
            radius: 12,
            backgroundColor: MyColors.whiteBG,
            child: Icon(Icons.settings_outlined,size: 16,),
          ),
        ),
        SizedBox(width: widths*0.02,)
      ]:null,
      ):null,
      body:
      // banners !=[] && banners.isNotEmpty && banners.length>=1 ?
      Stack(children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height),
          child: <Widget>[
            /// Home page
            ///
            HomeBottamScreen(
              onFetchMembership: currentMembership, bannersDa:banners,
            ),
            ExploreScreen(),
            // CategoriesBottamWidget(),
            RestaurantPaymentScreen(),
            // Center(child: Text("Page: ${_labels[_selectedIndex]}")),
            //BottomLoginScreen(),
            // user_id == 0 ? const BottomLoginScreen() : SortListBottamWidget(),
            user_id == 0 ? const BottomLoginScreen() :FlicksScreen(),
            // Center(child: _buildNoDataWidget()),

            user_id == 0 ? const BottomLoginScreen() : ProfileBottomScreen(),
          ][_selectedIndex],
        ),
        // if (isLoading)
        //   Container(
        //     color: Colors.black.withOpacity(0.5),
        //     // Adjust opacity as needed
        //     child: Center(
        //       child: CircularProgressIndicator(
        //         valueColor: AlwaysStoppedAnimation<Color>(
        //           MyColors.primaryColor,
        //         ),
        //         // Change the color
        //         strokeWidth: 4,
        //       ),
        //     ),
        //   ),
      ]),
          // :Center(child: CircularProgressIndicator(color: MyColors.redBG,)),
      // drawer: Drawer(
      //   backgroundColor: Colors.white,
      //   child: ListView(
      //     padding: const EdgeInsets.all(0),
      //     children: [
      //       Container(
      //           decoration: BoxDecoration(
      //             //color: MyColors.primaryColor.withOpacity(0.0),
      //             image: DecorationImage(
      //               image: const AssetImage("assets/images/drawer_bg_img.jpg"),
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
      //                         child: Container(
      //                           width: 70,
      //                           height: 70,
      //                           child: ClipOval(
      //                             child: CachedNetworkImage(
      //                               imageUrl: userimage.isNotEmpty
      //                                   ? userimage
      //                                   : image,
      //                               fit: BoxFit.fill,
      //                               placeholder: (context, url) => Image.asset(
      //                                 'assets/images/placeholder.png',
      //                                 // Path to your placeholder image asset
      //                                 fit: BoxFit.cover,
      //                                 width: double.infinity,
      //                                 height: double.infinity,
      //                               ),
      //                               errorWidget: (context, url, error) =>
      //                                   const Center(child: Icon(Icons.error)),
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
      //                         visible:
      //                             userName.isNotEmpty || userEmail.isNotEmpty,
      //                         child: RichText(
      //                           text: TextSpan(
      //                             style: const TextStyle(
      //                               color: Colors.black,
      //                               fontSize: 20,
      //                             ),
      //                             children: [
      //                               if (userName.isNotEmpty)
      //                                 TextSpan(
      //                                   text: '$userName\n',
      //                                   style: const TextStyle(
      //                                     fontSize: 20,
      //                                     color: Colors.black,
      //                                     fontWeight: FontWeight.bold,
      //                                   ),
      //                                 ),
      //                               if (userName.isNotEmpty &&
      //                                   userMobile.isNotEmpty)
      //                                 const WidgetSpan(
      //                                   child: SizedBox(
      //                                       height:
      //                                           25), // Adjust the height as needed
      //                                 ),
      //                               if (userMobile.isNotEmpty)
      //                                 TextSpan(
      //                                   text: '$userMobile',
      //                                   style: TextStyle(
      //                                     fontSize: 17,
      //                                     color: Colors.black.withOpacity(0.7),
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
      //
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
      //           Navigator.push(context, MaterialPageRoute(builder: (context) {
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
      //           Navigator.push(context, MaterialPageRoute(builder: (context) {
      //             return CustomerCare();
      //
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
      //           Navigator.push(context, MaterialPageRoute(builder: (context) {
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
      //
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
      //           Navigator.push(context, MaterialPageRoute(builder: (context) {
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
      //             Navigator.push(context, MaterialPageRoute(builder: (context) {
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
      //         title: user_id == 0 ? const Text(' Login ') : const Text(' Logout '),
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
      //
      bottomNavigationBar: PopScope(
        canPop: false,
        onPopInvoked: (v) {
          _onWillPop();
        },
        child:Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_image.length, (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: index==2? EdgeInsets.all(10):null,
                        decoration: BoxDecoration(
                            color: index==2? Colors.red : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            boxShadow:index==2? [
                              BoxShadow(
                                color: MyColors.redBG,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                                blurRadius: 7,
                              ),
                            ]:null,
                        border:index==2?Border(top: BorderSide(color: MyColors.whiteBG,width: 2)):null
                        ),

                        child:index==4?CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(profile?.image??""),
                        ):
                        Column(
                          children: [
                            index!=2?   Image(image: AssetImage(_image[index],),color:_selectedIndex==index?  MyColors.redBG:MyColors.whiteBG,height:heights*0.024,):
                            Image(image: AssetImage(_image[index],),color:MyColors.whiteBG,height:heights*0.024,),

              index==2?Text(
              _labels[index],
              style: TextStyle(
              color: MyColors.whiteBG,
              fontSize: 12,
                fontWeight: FontWeight.w500
              ),):Container()
                          ],
                        )
                    ),
                    index!=2? Text(
                      _labels[index],
                      style: TextStyle(
                        color:_selectedIndex==index?  MyColors.redBG:MyColors.whiteBG,
                        fontSize: 12,
                      ),):Container()
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
  Widget _buildNoDataWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 150,
            height: 100,
            child: Image.asset('assets/vector/blank.png')),
        // Assuming you have an image asset for 'No coupons available'
        SizedBox(height: 16),
        Text(
          'No Flicks Available',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
  void _onItemTappedd(int index) {
    setState(() {
      _selectedIndex = index;
    });
    //Navigator.push(context, MaterialPageRoute(builder: (context){return HomeScreen();}));
    Navigator.pop(context);

    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBottamScreen()));
  }
  static showExitConfirmation(BuildContext context) async {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return await showModalBottomSheet(
      elevation: 5,
      // backgroundColor: primary,
      shape: const RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35))),
      context: context,
      builder: (context) {
        return Container(
          height: height * 0.45,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 28.0, top: 28),
                child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close)),
              ),
              SizedBox(height: height / 30),
              const Center(
                child: Text("Exit App",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: height*0.02),
              const Center(
                child: Text("Are you sure want to exit app?",
                    style: TextStyle(
                      color: MyColors.blackBG,
                      fontSize: 16,
                    )),
              ),
              SizedBox(height: height * 0.04),
              Center(
                child: SizedBox(
                  width: width * 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // side:
                            // BorderSide(width: 1, color: Colors.white),
                            // elevation: 3,
                              backgroundColor: MyColors.redBG,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(55)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.34,
                                  vertical: height * 0.02)),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: const Text("Yes",
                              style: TextStyle(
                                  color: MyColors.whiteBG,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                      SizedBox(height: height * 0.03),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:MyColors.redBG,
                              // side: const BorderSide(width: 1,color: tertiary),
                              // elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(55)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.34,
                                  vertical: height * 0.02)),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("No",
                              style: TextStyle(
                                  color: MyColors.whiteBG,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    ) ??
        false;
  }
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

  Future<void> getUserDetails() async {

    String token = await SharedPref.getToken();
    user_details("${user_id}");

    UserModel n = await SharedPref.getUser();
    print("getUserDetails: ${n.id}");
    setState(() {
      user_id = n.id;
      userName = n.name;
      userEmail = n.email;
      userMobile = n.mobile;
      userimage = n.image;
      current_location = n.current_location;
      home_location = n.home_location;

      if (user_id != 0) {
        user_details("${user_id}");
        firebaseTokenApi(context, "$token", "$user_id");
        currentMembership("$user_id");
      }
    });

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

  void logoutUser() {
    SharedPref.logout(context);
  }

  Future<void> api_popup_dialog(BuildContext context) async {
    try {
      final response = await ApiServices.api_popup_dialog();

      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        if (data != null &&
            data is Map<String, dynamic> &&
            data.containsKey('image')) {
          String imageUrl = data['image'] as String;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomPopup(imageUrl: imageUrl);
            },
          );
        } else {
          //showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];
        //showErrorMessage(context, message: msg);
      }
    } catch (e) {
      print('Error in api_popup_dialog: $e');
      //showErrorMessage(context, message: 'An error occurred: $e');
    }
  }
  List<BannerModel> banners=[];
  Future<void> user_details(String user_id) async {
    try {
      final body = {
        "user_id": user_id,
      };
      final response = await ApiServices.user_details(context, body);
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        if (data != null && data is Map<String, dynamic>) {
          final user = UserModel.fromMap(data);

          setState(() async{
            await SharedPref.userLogin({
              SharedPref.KEY_ID: user.id,
              SharedPref.REFFREE: user.reffree,
              SharedPref.KEY_CURRENT_MONTH: user.current_month,
              SharedPref.KEY_PREMIUM: user.premium,
              SharedPref.KEY_STATUS: user.status,
              SharedPref.KEY_NAME: user.name,
              SharedPref.KEY_EMAIL: user.email,
              SharedPref.KEY_MOBILE: user.mobile,
              SharedPref.KEY_DOB: user.dob,
              SharedPref.KEY_OTP: user.otp,
              SharedPref.KEY_IMAGE: user.image,
              SharedPref.KEY_HOME_LOCATION: user.home_location,
              SharedPref.KEY_CURRENT_LOCATION: user.current_location,
              SharedPref.ADDRESS: user.address,
              SharedPref.KEY_LAT: user.lat,
              SharedPref.KEY_LONG: user.long,
              SharedPref.WALLET: user.wallet,
              SharedPref.REFERRALLINK: user.referralLink,
              SharedPref.KEY_CREATED_AT: user.created_at,
              SharedPref.KEY_UPDATED_AT: user.updated_at,
              SharedPref.KEY_FIRST_RECHARGE: user.firstReachage,
              SharedPref.KEY_COVER_PHOTO: user.coverPhoto,
              SharedPref.KEY_USER_NAME: user.userName,
              SharedPref.KEY_BIO: user.bio,
              SharedPref.KEY_POST: user.post,
              SharedPref.KEY_FOLLOWER: user.follower,
              SharedPref.KEY_FOLLOWING: user.following,
              SharedPref.KEY_BANNER: jsonEncode(user.banners),
            });
          });

          // 3. Update provider
          Provider.of<UserProvider>(context, listen: false).fetchUserDetails();
          Provider.of<UserProvider>(context, listen: false).updateUserDetails(user);
        }
        // if (data != null && data is Map<String, dynamic>) {
        //   final user = UserModel.fromMap(data);
        //
        //   setState(() {
        //
        //      SharedPref.userLogin({
        //       SharedPref.KEY_ID: user.id,
        //       SharedPref.REFFREE: user.reffree,
        //       SharedPref.KEY_CURRENT_MONTH: user.current_month,
        //       SharedPref.KEY_PREMIUM: user.premium,
        //       SharedPref.KEY_STATUS: user.status,
        //       SharedPref.KEY_NAME: user.name,
        //       SharedPref.KEY_EMAIL: user.email,
        //       SharedPref.KEY_MOBILE: user.mobile,
        //       SharedPref.KEY_DOB: user.dob,
        //       SharedPref.KEY_OTP: user.otp,
        //       SharedPref.KEY_IMAGE: user.image,
        //       SharedPref.KEY_HOME_LOCATION: user.home_location,
        //       SharedPref.KEY_CURRENT_LOCATION: user.current_location,
        //       SharedPref.ADDRESS: user.address,
        //       SharedPref.KEY_LAT: user.lat,
        //       SharedPref.KEY_LONG: user.long,
        //       SharedPref.WALLET: user.wallet,
        //       SharedPref.REFERRALLINK: user.referralLink,
        //       SharedPref.KEY_CREATED_AT: user.created_at,
        //       SharedPref.KEY_UPDATED_AT: user.updated_at,
        //       SharedPref.KEY_FIRST_RECHARGE: user.firstReachage,
        //       SharedPref.KEY_COVER_PHOTO: user.coverPhoto,
        //       SharedPref.KEY_USER_NAME: user.userName,
        //       SharedPref.KEY_BIO: user.bio,
        //       SharedPref.KEY_POST: user.post,
        //       SharedPref.KEY_FOLLOWER: user.follower,
        //       SharedPref.KEY_FOLLOWING: user.following,
        //       SharedPref.KEY_BANNER: jsonEncode(user.banners),
        //     });
        //      banners= user.banners;
        //   });
        //   Provider.of<UserProvider>(context, listen: false)
        //       .fetchUserDetails();
        //   Provider.of<UserProvider>(context, listen: false)
        //       .updateUserDetails(user);
        //         }
        else {
          // Handle invalid response data format
          showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      //print('verify_otp error: $e');
      // Handle error
      //showErrorMessage(context, message: 'An error occurred: $e');
    } finally {}
  }

  Future<void> user_city_updated(String user_id, String city_id) async {
    print('UpdateUserCity datashow: $city_id');
    setState(() {
      isLoading = false;
    });
    try {
      final body = {
        "user_id": user_id,
        "city_id": city_id,
      };
      final response = await ApiServices.updateUserCity(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        print('UpdateUserCity datashow: $data');
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          final user = UserModel.fromMap(data);

          if (user != null) {
            await SharedPref.userLogin({
              SharedPref.KEY_ID: user.id,
              SharedPref.KEY_CURRENT_MONTH: user.current_month,
              SharedPref.KEY_PREMIUM: user.premium,
              SharedPref.KEY_STATUS: user.status,
              SharedPref.KEY_NAME: user.name,
              SharedPref.KEY_EMAIL: user.email,
              SharedPref.KEY_MOBILE: user.mobile,
              SharedPref.KEY_DOB: user.dob,
              SharedPref.KEY_OTP: user.otp,
              SharedPref.KEY_IMAGE: user.image,
              SharedPref.KEY_HOME_LOCATION: user.home_location,
              SharedPref.KEY_CURRENT_LOCATION: user.current_location,
              SharedPref.KEY_LAT: user.lat,
              SharedPref.KEY_LONG: user.long,
              SharedPref.KEY_CREATED_AT: user.created_at,
              SharedPref.KEY_UPDATED_AT: user.updated_at,
            });

            setState(() async {
              UserModel n = await SharedPref.getUser();
              current_location = n.current_location;
              if (HomeBottamScreen.instance != null) {
                HomeBottamScreen.instance!
                    .allApiCall(n.home_location); // Add ! or null check
              }
            });
          } else {
            // Handle null user
            showErrorMessage(context, message: 'User data is invalid');
          }
        } else {
          // Handle invalid response data format
          //showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
        //showErrorMessage(context, message: msg);
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

  Future<void> firebaseTokenApi(
      BuildContext context, String token, String userid) async {
    try {
      final body = {"token": token, "userid": userid};
      final response = await ApiServices.firebaseToken(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        final msg = response['msg'];
      } else if (response != null) {
        String msg = response['msg'];
      }
    } catch (e) {
    } finally {}
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
}

//Notification
class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_sharp),
              title: Text('Notification 1'),
              subtitle: Text('This is a notification'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_sharp),
              title: Text('Notification 2'),
              subtitle: Text('This is a notification'),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPopup extends StatefulWidget {
  final String imageUrl;

  CustomPopup({super.key, required this.imageUrl});

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _contentBox(context),
    );
  }

  Widget _contentBox(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.maxFinite,
      height: screenWidth * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              width: double.maxFinite,
              fit: BoxFit.fill,
              height: screenWidth * 0.8,
              imageUrl: "$_imageUrl",
              placeholder: (context, url) => Image.asset(
                'assets/images/placeholder.png',
                // Path to your placeholder image asset
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            ),
          ),
          Positioned(
            top: screenWidth <= 600 ? 5 : 10, // Adjust based on screen width
            right: screenWidth <= 600 ? 5 : 10, // Adjust based on screen width
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                width: screenWidth <= 600 ? 30 : 40,
                // Adjust based on screen width
                height: screenWidth <= 600 ? 30 : 40,
                // Adjust based on screen width
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.9),
                ),
                child: Icon(
                  Icons.close,
                  color: MyColors.primaryColor,
                  size: screenWidth <= 600
                      ? 18
                      : 24, // Adjust based on screen width
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
