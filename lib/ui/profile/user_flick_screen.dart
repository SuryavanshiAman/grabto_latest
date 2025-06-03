
import 'package:flutter/material.dart';
import 'package:grabto/helper/user_provider.dart';
import 'package:grabto/main.dart';
import 'package:grabto/model/my_save_flick_model.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/view_model/get_flick_view_model.dart';
import 'package:grabto/view_model/my_saved_flick_view_model.dart';
import 'package:provider/provider.dart';

import '../../model/get_flick_model.dart';
import '../../widget/sub_categories_card_widget.dart';

class UserFlickScreen extends StatefulWidget {
  const UserFlickScreen({super.key,});

  @override
  State<UserFlickScreen> createState() => _UserFlickScreenState();
}

class _UserFlickScreenState extends State<UserFlickScreen> {
  @override
  void initState() {
    super.initState();
    // Provider.of<GetFlickViewModel>(context, listen: false).getFlickApi(context);
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<GetFlickViewModel>(context).flickList.data?.data;
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount:data?.length ?? 0,
        itemBuilder: (context, index) {
          final flicks = data?[index];
          return FoodPostCard(index: index, flicksData: flicks,);
        },
      ),
    );
  }
}

class FoodPostCard extends StatelessWidget {
  final int index;
  final GetFlickData? flicksData;

  const FoodPostCard({super.key, required this.index, this.flicksData,});

  @override
  Widget build(BuildContext context) {
    final user= Provider.of<UserProvider>(context, listen: false).user;
    return SizedBox(
      height: heights,
      width: widths,
      child: Stack(
        children: [
          Center(child: VideoPlayerWidget(videoUrl:flicksData?.videoLink ?? "")),
          // Positioned(
          //     top: 40,
          //     left: 16,
          //     // right: 10,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.only(top: 8.0),
          //           child: Card(
          //             color: Colors.white,
          //             elevation: 5,
          //             clipBehavior: Clip.antiAliasWithSaveLayer,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(35),
          //             ),
          //             child: Card(
          //               color: Colors.white,
          //               elevation: 3,
          //               clipBehavior: Clip.antiAliasWithSaveLayer,
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(200),
          //               ),
          //               child: SizedBox(
          //                 height: MediaQuery.of(context).size.width * 0.06,
          //                 width: MediaQuery.of(context).size.width * 0.06,
          //                 child: CachedNetworkImage(
          //                   imageUrl: flicksData?.??"",
          //                   fit: BoxFit.fill,
          //                   placeholder: (context, url) => Image.asset(
          //                     'assets/images/placeholder.png',
          //                     fit: BoxFit.cover,
          //                     width: double.infinity,
          //                     height: double.infinity,
          //                   ),
          //                   errorWidget: (context, url, error) =>
          //                   const Center(child: Icon(Icons.error)),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Center(
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             padding: const EdgeInsets.all(8),
          //             // color: Colors.red,
          //             // Adjust according to your requirement
          //             child: Row(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     SizedBox(
          //                       width: widths * 0.6,
          //                       child: Text(
          //                         flicksData?.storeName??"",
          //                         textAlign: TextAlign.start,
          //                         style: TextStyle(
          //                             fontSize: 14,
          //                             fontFamily: 'wix',
          //                             fontWeight: FontWeight.w600,
          //                             color: MyColors.whiteBG),
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       width: widths * 0.6,
          //                       child: Text(
          //                         flicksData?.address??"",
          //                         textAlign: TextAlign.start,
          //                         style: TextStyle(
          //                             fontSize: 10,
          //                             // Adjust according to your requirement
          //                             fontFamily: 'wix',
          //                             fontWeight: FontWeight.w600,
          //                             color: MyColors.whiteBG),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 // SizedBox(
          //                 //   width: widths * 0.05,
          //                 // ),
          //                 GestureDetector(
          //                   onTap: () async {
          //                     final url = Uri.parse(flicksData?.mapLink??"");
          //                     if (await canLaunchUrl(url)) {
          //                       await launchUrl(url,
          //                           mode: LaunchMode.externalApplication);
          //                     } else {
          //                       throw 'Could not launch $url';
          //                     }
          //                   },
          //                   child: Container(
          //                     // color: Colors.red,
          //                     child: Text(
          //                       "Map",
          //                       style: TextStyle(
          //                         color: MyColors.whiteBG,
          //                         fontSize: 10,
          //                         fontFamily: 'wix',
          //                         fontWeight: FontWeight.w600,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 GestureDetector(
          //                     onTap: () async {
          //                       final url = Uri.parse(flicksData?.mapLink??"");
          //                       if (await canLaunchUrl(url)) {
          //                         await launchUrl(url,
          //                             mode: LaunchMode.externalApplication);
          //                       } else {
          //                         throw 'Could not launch $url';
          //                       }
          //                     },
          //                     child: Image(
          //                       image: AssetImage(
          //                           "assets/images/assistant_navigation.png"),
          //                       height: heights * 0.02,
          //                     ))
          //               ],
          //             ),
          //           ),
          //         ),
          //
          //         // Icon(Icons.na)
          //       ],
          //     )),

          // Right-side icons
          Positioned(
            right: 16,
            bottom: 160,
            child: Column(
              children: [
                IconWithLabel(
                    icon: Icons.local_fire_department_outlined,
                    label: '${"10"}'),
                SizedBox(height: 16),
                IconWithLabel(
                    icon: Icons.message_outlined, label: '${"10"}'),
                SizedBox(height: 16),
                IconWithLabel(
                    icon: Icons.bookmark_border, label: '${"10"}'),
                SizedBox(height: 16),
                IconWithLabel(icon: Icons.share, label: '${"10"}'),
              ],
            ),
          ),

          // Bottom user info
          Positioned(
            left: 16,
            right: 16,
            bottom: 50,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                  user?.image ?? "",
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( user?.name ?? "",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('${user?.follower ?? ""} Followers',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                // Spacer(),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    // showInsightBottomSheet(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: MyColors.blackBG.withAlpha(80),
                      borderRadius: BorderRadius.circular(5),
                      // border: Border.all(color: MyColors.b.withAlpha(100))
                    ),
                    child: Text(
                      "Follow",
                      style: TextStyle(
                          fontSize: 12,
                          color: MyColors.whiteBG,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {},
                //   child: Text('Follow'),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     foregroundColor: Colors.black,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                //   ),
                // ),
              ],
            ),
          ),

          // Bottom caption
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Text( flicksData?.caption.toString() ?? "",
              style: TextStyle(color: Colors.white70),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class IconWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconWithLabel({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
