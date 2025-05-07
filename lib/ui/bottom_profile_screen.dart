import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/helper/user_provider.dart';
import 'package:grabto/main.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/services/api.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/edit_profiel_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_setting.dart';

class ProfileBottomScreen extends StatefulWidget {
  @override
  State<ProfileBottomScreen> createState() => _ProfileBottomScreenState();
}

class _ProfileBottomScreenState extends State<ProfileBottomScreen> {
  String userName = '';
  String userEmail = '';
  String  userMobile='';
  String userImage = '';
  String  userLocation='';
  String  userDob='';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      getUserDetails();


  }
  final List<IconData> iconList = [
    Icons.grid_view,
    Icons.rate_review_outlined,
    Icons.travel_explore,
    Icons.bookmark_add_outlined,
  ];
  final List<String>imageData=[
    'assets/images/food1.png',
    'assets/images/food2.png',
    'assets/images/food3.png',
    'assets/images/food4.png',
    'assets/images/food5.png',
    'assets/images/grabto_logo_without_text.png',
    'assets/images/grabto_logo_with_text.png',
  ];
  int isSelected=0;
  @override
  Widget build(BuildContext context) {
   return Consumer<UserProvider>(
     builder: (context, userProvider, child) {
       final user = userProvider.user;
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Top Banner Image
                  Image.asset(
                    'assets/images/profile_bg.png',
                    height: heights*0.3,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    top: heights*0.05,
                    right: widths*0.03,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountSettingsScreen()));
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: MyColors.whiteBG,
                        child: Icon(Icons.settings_outlined,size: 16,),
                      ),
                    ),
                  ),
                  Positioned(
                    top: heights*0.05,
                    right: widths*0.13,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountSettingsScreen()));
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: MyColors.whiteBG,
                        child: Icon(Icons.share_outlined,size: 16,),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [
Color(0xffef3e22).withAlpha(150),
Color(0xffef5a42),
Color(0xffef5a42).withAlpha(50),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)
                          ),
                          child:CircleAvatar(
                            radius: 42,
                            backgroundImage: AssetImage(
                              'assets/images/grabto_logo_without_text.png',
                            ),
                          ) ,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.black,
                            child: Icon(Icons.add, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              // Name and Handle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sanjay Mishra",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text("Get Verified",
                        style: TextStyle(fontSize: 11, color: MyColors.textColorTwo)),
                  ),
                ],
              ),
              Text(
                "@sanjay_foodie_1234",
                style: TextStyle(fontSize: 11, color: MyColors.textColorTwo),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  "Jobless by Day, Foodie by night.\nI live my dream life exploring foods ❤️❤️",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: MyColors.textColorTwo),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: widths*0.05),
                padding: EdgeInsets.symmetric(vertical: heights*0.01),
                decoration: BoxDecoration(
                  color: Color(0xfff2f2f1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn("72", "Posts"),
                    _buildStatColumn("1.2k", "Followers"),
                    _buildStatColumn("43", "Following"),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6,horizontal: 15),
                      decoration: BoxDecoration(
                        color: MyColors.redBG,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text("Edit Profile",style: TextStyle(fontSize: 12,color: MyColors.whiteBG,),),
                    ),

                    InkWell(
                      onTap: (){
                        showInsightBottomSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                        decoration: BoxDecoration(
                          // color: MyColors.redBG,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: MyColors.grey.withAlpha(100))
                        ),
                        child: Text("Insights",style: TextStyle(fontSize: 12,color: MyColors.textColor,fontWeight: FontWeight.w500),),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        showCustomBottomSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
                        decoration: BoxDecoration(
                          // color: MyColors.redBG,
                          borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: MyColors.grey.withAlpha(100))
                        ),
                        child: Text("Create",style: TextStyle(fontSize: 12,color: MyColors.textColor,fontWeight: FontWeight.w500),),
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: heights*0.06,
                width: widths,
                margin: EdgeInsets.symmetric(horizontal: widths*0.05),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          isSelected=index;
                        });
                      },
                      child: Container(
                        width: widths*0.23,
                        padding:  EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected==index
                                  ? MyColors.redBG
                                  : Colors.transparent,
                              width: 2
                            ),
                          ),
                        ),
                        child: Icon(
                          iconList[index],
                          size: 20, // customize size
                          color: Colors.black, // customize color
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: heights*0.02),
              isSelected==0?
              MasonryGridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount:imageData.length,
                itemBuilder: (context, index) {
                  return Image(image: AssetImage(imageData[index]));
                  // CachedNetworkImage(
                  //   imageUrl: data?.image??"",
                  //   fit: BoxFit.fill,
                  //   placeholder: (context, url) => Image.asset(
                  //     'assets/images/placeholder.png',
                  //     fit: BoxFit.cover,
                  //     width: double.infinity,
                  //     height: double.infinity,
                  //   ),
                  //   errorWidget: (context, url, error) =>
                  //       Center(child: Icon(Icons.error)),
                  // );
                },
              ):isSelected==1?_buildReviewItem():GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: imageData.length,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    mainAxisExtent: 280),
                itemBuilder: (BuildContext context, int index) {
                  return Image(image: AssetImage(imageData[index]),fit: BoxFit.fill,);
                },
              )

            ],
          ),
        );
       //    Container(
       //   color: MyColors.backgroundBg,
       //   child: Container(
       //     padding: EdgeInsets.only(left: 16, top: 25, right: 16),
       //     child: GestureDetector(
       //       onTap: () {
       //         //FocusScope.of(context).unfocus();
       //       },
       //       child: ListView(
       //         children: [
       //           SizedBox(
       //             height: 15,
       //           ),
       //           Center(
       //             child: Stack(
       //               children: [
       //                 Container(
       //                   width: 110,
       //                   height: 110,
       //                   decoration: BoxDecoration(
       //                     border: Border.all(
       //                         width: 4,
       //                         color: Theme.of(context).scaffoldBackgroundColor),
       //                     boxShadow: [
       //                       BoxShadow(
       //                           spreadRadius: 2,
       //                           blurRadius: 10,
       //                           color: Colors.black.withOpacity(0.1),
       //                           offset: Offset(0, 10))
       //                     ],
       //                     shape: BoxShape.circle,
       //
       //                   ),
       //                   child: ClipOval(
       //                     child: CachedNetworkImage(
       //                       imageUrl: userImage.isNotEmpty
       //                           ? userImage
       //                           : image,
       //                       fit: BoxFit.fill,
       //                       placeholder: (context, url) => Image.asset(
       //                         'assets/images/placeholder.png',
       //                         // Path to your placeholder image asset
       //                         fit: BoxFit.cover,
       //                         width: double.infinity,
       //                         height: double.infinity,
       //                       ),
       //                       errorWidget: (context, url, error) =>
       //                           Center(child: Icon(Icons.error)),
       //                     ),
       //                     // child: Image.network(
       //                     //   userImage.isNotEmpty
       //                     //       ? userImage
       //                     //       : image,
       //                     //   loadingBuilder: (BuildContext context,
       //                     //       Widget child,
       //                     //       ImageChunkEvent? loadingProgress) {
       //                     //     if (loadingProgress == null) {
       //                     //       return child;
       //                     //     }
       //                     //     else {
       //                     //       return Center(
       //                     //         child: CircularProgressIndicator(
       //                     //           value:
       //                     //           loadingProgress.expectedTotalBytes !=
       //                     //               null
       //                     //               ? loadingProgress
       //                     //               .cumulativeBytesLoaded /
       //                     //               (loadingProgress
       //                     //                   .expectedTotalBytes ??
       //                     //                   1)
       //                     //               : null,
       //                     //         ),
       //                     //       );
       //                     //     }
       //                     //   },
       //                     //   errorBuilder: (BuildContext context, Object error,
       //                     //       StackTrace? stackTrace) {
       //                     //     return Icon(Icons
       //                     //         .person); // Placeholder icon for error case
       //                     //   },
       //                     ),
       //                   ),
       //
       //                 // Positioned(
       //                 //     bottom: 0,
       //                 //     right: 0,
       //                 //     child: Container(
       //                 //       height: 40,
       //                 //       width: 40,
       //                 //       decoration: BoxDecoration(
       //                 //         shape: BoxShape.circle,
       //                 //         border: Border.all(
       //                 //           width: 4,
       //                 //           color: Theme.of(context).scaffoldBackgroundColor,
       //                 //         ),
       //                 //         color: MyColors.primaryColor,
       //                 //       ),
       //                 //       child: Icon(
       //                 //         Icons.edit,
       //                 //         color: Colors.white,
       //                 //       ),
       //                 //     )),
       //               ],
       //             ),
       //           ),
       //           SizedBox(
       //             height: 35,
       //           ),
       //           buildText("Name", userName.isNotEmpty
       //               ? userName
       //               : "Update your Name"),
       //           buildText("Mobile", userMobile.isNotEmpty
       //               ? userMobile
       //               : "Update your Mobile"),
       //           buildText("Email", userEmail.isNotEmpty
       //               ? userEmail
       //               : "Update your email"),
       //           buildText("Dath of Birth", userDob.isNotEmpty
       //               ? userDob
       //               : "Update your Dob"),
       //           buildText("City", userLocation.isNotEmpty
       //               ? userLocation
       //               : "Update your city"),
       //           SizedBox(
       //             height: 35,
       //           ),
       //           Row(
       //             mainAxisAlignment: MainAxisAlignment.center,
       //             children: [
       //               ElevatedButton(
       //                 style: ButtonStyle(
       //                   side: MaterialStateProperty.all<BorderSide>(
       //                     BorderSide(
       //                         color:
       //                         MyColors.primaryColor), // Change the color here
       //                   ),
       //                   backgroundColor: MaterialStateProperty.all<Color>(
       //                       MyColors.primaryColor),
       //                 ),
       //                 onPressed: () {
       //                   // Navigator.push(context,
       //                   //     MaterialPageRoute(builder: (context) {
       //                   //       return EditProfileBottomScreen();
       //                   //     }));
       //                   navigateToEditProfileBottomScreen();
       //                 },
       //                 child: Text("Edit",
       //                     style: TextStyle(
       //                         fontSize: 14,
       //                         letterSpacing: 2.2,
       //                         color: Colors.white)),
       //               ),
       //             ],
       //           )
       //         ],
       //       ),
       //     ),
       //   ),
       // );
     },
   );

  }
  Widget _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(number, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color:Colors.black,fontSize: 10)),
      ],
    );
  }
  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.dob);
    setState(() {
      userName = n.name;
      userEmail = n.email;
      userMobile = n.mobile;
      userImage = n.image;
      userLocation = n.current_location;
      userDob = n.dob;
    });
  }
  Widget _buildReviewItem() {
    return Container(
      width: widths * 0.9,
      height: heights * 0.36,
      padding: const EdgeInsets.all(12),
      // margin: const EdgeInsets.symmetric( vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: MyColors.txtDescColor, width: 0.3),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/images/grabto_logo_without_text.png"),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    "Aman",
                    style: const TextStyle(
                      color: MyColors.blackBG,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                  Image.asset("assets/images/country.png")
                ],
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.fromLTRB(6, 4, 8, 4),
                decoration: BoxDecoration(
                  color:
                  // (review.rating <= 2.0)
                  //     ? MyColors.primaryColor
                  //     : (review.rating == 3.0)
                  //     ? Colors.yellow
                  //     :
                  Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "4.5/5",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heights * 0.03),
          Text(
            "Reviewed on: 11 Aug.2024",
            style: TextStyle(fontSize: 9, color: MyColors.textColorTwo),
          ),
          Flexible(
            child: Text(
              "Maintain aspect ratio without overflow",
              style: const TextStyle(
                color: MyColors.blackBG,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis, // Prevent overflow
              maxLines: 2, // Limit to 2 lines
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Read More",
              style: const TextStyle(
                  color: MyColors.textColorTwo,
                  fontSize: 10,
                  fontWeight: FontWeight.w500),
            ),
          ),
        Divider(color: MyColors.textColorTwo.withAlpha(30),),
          SizedBox(
            width: 96,
            height: 96,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.asset(
               "assets/images/grabto_logo_with_text.png",
                fit: BoxFit.cover, // Maintain aspect ratio without overflow
                // loadingBuilder: (BuildContext context, Widget child,
                //     ImageChunkEvent? loadingProgress) {
                //   if (loadingProgress == null) {
                //     // Image has loaded successfully
                //     return child;
                //   } else {
                //     // Image is still loading, display a loading indicator
                //     return const Center(
                //       child: CircularProgressIndicator(color: MyColors.redBG),
                //     );
                //   }
                // },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Handle error if image fails to load
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  // void navigateToEditProfileBottomScreen() async {
  //   // Navigate to the edit profile screen and wait for result
  //   final Map<String, dynamic>? result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => EditProfileBottomScreen()),
  //   );
  //   // Check if the result is not null and contains updated user details
  //   if (result != null) {
  //     // Update user details based on the received data
  //     setState(() {
  //       userName = result['name'] ?? userName;
  //       userEmail = result['email'] ?? userEmail;
  //       userLocation = result['location'] ?? userLocation;
  //       userDob = result['dob'] ?? userDob;
  //       // Update other user details as needed
  //     });
  //   }
  // }


  // void navigateToEditProfileBottomScreen() async {
  //   // Navigate to the edit profile screen and wait for result
  //   final Map<String, dynamic>? result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => EditProfileBottomScreen()),
  //   );
  //   // Check if the result is not null and contains updated user details
  //   if (result != null) {
  //     // Update user details based on the received data
  //     setState(() {
  //       userName = result['name'] ?? userName;
  //       userEmail = result['email'] ?? userEmail;
  //       userLocation = result['location'] ?? userLocation;
  //       userDob = result['dob'] ?? userDob;
  //     });
  //     await getUserDetails();
  //
  //   }
  // }


  void showInsightBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header image with overlay text
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      'assets/images/food1.png', // Replace with your actual asset
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    bottom: heights*0.17,
                    child: Center(
                      child: Text(
                        'Get Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: heights*0.4,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Premium Features Arriving Soon!',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'We’re preparing something special for our true foodies! Grabto Premium will unlock powerful tools to make your dining and social experience even better.',
                            style: TextStyle(fontSize: 12, color:MyColors.textColorTwo),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            cursorHeight: heights*0.02,
                            decoration: InputDecoration(
                              hintText: 'Enter Email Address',
                              hintStyle: TextStyle(fontSize: 12,color: MyColors.textColorTwo),
                              contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: MyColors.grey.withAlpha(50), // Border color when not focused
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: MyColors.grey.withAlpha(50), // Border color when not focused
                                  width: 1,
                                ),
                              ),

                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors.redBG,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {},
                              child: Text('Get Notification via mail',style: TextStyle(color: MyColors.whiteBG),),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:16,right: 16),
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
                            "Coming Soon with Premium",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: List.generate(3, (index) {
                          final List<Map<String, dynamic>> items = [
                            {
                              'icon': Icons.remove_red_eye_outlined,
                              'text':
                              'Stay ahead of the crowd and discover where your friends and favorite foodies are dining in real-time.',
                            },
                            {
                              'icon': Icons.emoji_emotions_outlined,
                              'text':
                              'Food is better with conversation. Connect and chat directly with your foodie circle!',
                            },
                            {
                              'icon': Icons.show_chart_outlined,
                              'text':
                              'Get exclusive stats — track your posts, followers, and engagement.',
                            },
                          ];

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  // Icon Circle
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey.shade300),
                                      // color: Colors.white,
                                    ),
                                    child: Icon(
                                      items[index]['icon'],
                                      size: 20,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  // Vertical Line (except last item)
                                  if (index != items.length - 1)
                                    Container(
                                      width: 2,
                                      height: heights*0.05,
                                      color: Colors.grey.shade300,
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  items[index]['text'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    )

                  ],
                )
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                color: MyColors.textColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 52),
                        decoration: BoxDecoration(
                          // color: MyColors.redBG,
                            borderRadius: BorderRadius.circular(5),
                           color: MyColors.whiteBG
                        ),
                        child: Text("Go Back",style: TextStyle(fontSize: 14,color: MyColors.textColor,fontWeight: FontWeight.w500),),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 40),
                      decoration: BoxDecoration(
                        // color: MyColors.redBG,
                          borderRadius: BorderRadius.circular(5),
                          color: MyColors.redBG
                      ),
                      child: Text("Get Notified",style: TextStyle(fontSize: 14,color: MyColors.whiteBG,fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MyColors.whiteBG,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSheetButton(Icons.grid_view, 'Add Post'),
               Divider(color: MyColors.textColorTwo.withAlpha(30),),
              _buildSheetButton(Icons.travel_explore, 'Add Flick'),
               Divider(color: MyColors.textColorTwo.withAlpha(30),),
              _buildSheetButton(Icons.rate_review_outlined, 'Add Review'),
               Divider(color: MyColors.textColorTwo.withAlpha(30),),
              _buildSheetButton(Icons.star_border_rounded, 'Add Highlight'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Handle tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget buildText(String labelText, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "" + labelText,
                style: TextStyle(
                  color: MyColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "" + text,
                style: TextStyle(
                  color: MyColors.txtTitleColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
