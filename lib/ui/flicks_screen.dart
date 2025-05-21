// import 'package:flutter/material.dart';
// import 'package:grabto/main.dart';
// import 'package:grabto/theme/theme.dart';
// import 'package:grabto/view_model/flicks_view_model.dart';
// import 'package:pod_player/pod_player.dart';
// import 'package:provider/provider.dart';
//
// import '../widget/sub_categories_card_widget.dart';
//
// class FlicksScreen extends StatefulWidget {
//   const FlicksScreen({super.key});
//
//   @override
//   State<FlicksScreen> createState() => _FlicksScreenState();
// }
//
// class _FlicksScreenState extends State<FlicksScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<FlicksViewModel>(context,listen: false).flicksApi(context);
//   }
//   @override
//   Widget build(BuildContext context) {
//     final data =Provider.of<FlicksViewModel>(context,listen: false).flickList.data?.data?.data;
//     return Scaffold(
//       backgroundColor: MyColors.textColor,
//       body: ListView.builder(
//         shrinkWrap: true,
//         itemCount: data?.length??0,
//         itemBuilder: (context, index) {
//
//           final flick = data?[index];
//           print(flick?.id??0);
//           print("flick?.id??0");
//           return Stack(
//             children: [
//               // Background Image
//               SizedBox(
//                 height: heights,
//                 child: VideoPlayerWidget(
//                     videoUrl:
//                     flick?.videoLink??""),
//               ),
//               SizedBox.expand(
//                 child: Image.asset(
//                   'assets/images/intro_screen.png', // Replace with your image
//                   fit: BoxFit.cover,
//                 ),
//               ),
//
//               // Top overlay: Location info
//               Positioned(
//                 top: 40,
//                 left: 16,
//                 right: 16,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 18,
//                       backgroundColor: Colors.white,
//                       child: Icon(Icons.store, color: Colors.black),
//                     ),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Cafe Hons - House of No Sugar',
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             'Shop A-9, Kisan Bazar, Vibhuti Khand, Gomti Nagar, Lucknow - 4.3 km',
//                             style: TextStyle(color: Colors.white70, fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Icon(Icons.map, color: Colors.white)
//                   ],
//                 ),
//               ),
//
//               // Right-side icons
//               Positioned(
//                 right: 16,
//                 bottom: 160,
//                 child: Column(
//                   children: [
//                     IconWithLabel(icon: Icons.local_fire_department, label: '10.4k'),
//                     SizedBox(height: 16),
//                     IconWithLabel(icon: Icons.comment, label: '324'),
//                     SizedBox(height: 16),
//                     IconWithLabel(icon: Icons.bookmark_border, label: '16'),
//                     SizedBox(height: 16),
//                     IconWithLabel(icon: Icons.share, label: '32'),
//                   ],
//                 ),
//               ),
//
//               // Bottom user info
//               Positioned(
//                 left: 16,
//                 right: 16,
//                 bottom: 20,
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(
//                         'https://randomuser.me/api/portraits/women/79.jpg',
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Michelle Dam',
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                         Text('12k Followers',
//                             style: TextStyle(color: Colors.white70, fontSize: 12)),
//                       ],
//                     ),
//                     Spacer(),
//                     ElevatedButton(
//                       onPressed: () {},
//                       child: Text('Follow'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.black,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Bottom caption
//               Positioned(
//                 left: 16,
//                 right: 16,
//                 bottom: 0,
//                 child: Text(
//                   'Sit rutrum ac sit sit facilisis aliquet tellus enim lacus...',
//                   style: TextStyle(color: Colors.white70),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           );
//         },
//
//       ),
//
//     );
//   }
// }
//
// class IconWithLabel extends StatelessWidget {
//   final IconData icon;
//   final String label;
//
//   const IconWithLabel({super.key, required this.icon, required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.white, size: 28),
//         SizedBox(height: 4),
//         Text(label, style: TextStyle(color: Colors.white)),
//       ],
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/flicks_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../theme/theme.dart';
import '../view_model/flicks_view_model.dart';
import '../widget/sub_categories_card_widget.dart';

class FlicksScreen extends StatefulWidget {
  const FlicksScreen({super.key});

  @override
  State<FlicksScreen> createState() => _FlicksScreenState();
}

class _FlicksScreenState extends State<FlicksScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<FlicksViewModel>(context, listen: false).flicksApi(context);
  }

  @override
  Widget build(BuildContext context) {
    final data =
        Provider.of<FlicksViewModel>(context).flickList.data?.data?.data;
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: data?.length ?? 0,
        itemBuilder: (context, index) {
          final flicks = data?[index];
          return FoodPostCard(index: index, flicksData: flicks);
        },
      ),
    );
  }
}

class FoodPostCard extends StatelessWidget {
  final int index;
  final FlicksData? flicksData;

  const FoodPostCard({super.key, required this.index, this.flicksData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heights,
      width: widths,
      child: Stack(
        children: [
          SizedBox(
            height: heights,
            child: VideoPlayerWidget(videoUrl: flicksData?.videoLink ?? ""),
          ),
          // Top-left location info
          Positioned(
              top: 40,
              left: 16,
              // right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Card(
                        color: Colors.white,
                        elevation: 3,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.06,
                          width: MediaQuery.of(context).size.width * 0.06,
                          child: CachedNetworkImage(
                            imageUrl: flicksData?.image??"",
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
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8),
                      // color: Colors.red,
                      // Adjust according to your requirement
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: widths * 0.6,
                                child: Text(
                                  flicksData?.storeName??"",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'wix',
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.whiteBG),
                                ),
                              ),
                              SizedBox(
                                width: widths * 0.6,
                                child: Text(
                                  flicksData?.address??"",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 10,
                                      // Adjust according to your requirement
                                      fontFamily: 'wix',
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.whiteBG),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   width: widths * 0.05,
                          // ),
                          GestureDetector(
                            onTap: () async {
                              final url = Uri.parse(flicksData?.mapLink??"");
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Container(
                              // color: Colors.red,
                              child: Text(
                                "Map",
                                style: TextStyle(
                                  color: MyColors.whiteBG,
                                  fontSize: 10,
                                  fontFamily: 'wix',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                final url = Uri.parse(flicksData?.mapLink??"");
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url,
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Image(
                                image: AssetImage(
                                    "assets/images/assistant_navigation.png"),
                                height: heights * 0.02,
                              ))
                        ],
                      ),
                    ),
                  ),

                  // Icon(Icons.na)
                ],
              )),

          // Right-side icons
          Positioned(
            right: 16,
            bottom: 160,
            child: Column(
              children: [
                IconWithLabel(
                    icon: Icons.local_fire_department_outlined,
                    label: '${flicksData?.likesCount??""}'),
                SizedBox(height: 16),
                IconWithLabel(
                    icon: Icons.message_outlined, label: '${flicksData?.commentsCount ?? ""}'),
                SizedBox(height: 16),
                IconWithLabel(
                    icon: Icons.bookmark_border, label: '${flicksData?.isFavorited ?? ""}'),
                SizedBox(height: 16),
                IconWithLabel(icon: Icons.share, label: '${flicksData?.sharesCount ?? ""}'),
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
                    flicksData?.profileImage ?? "",
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(flicksData?.userName ?? "",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('${12 + index}k Followers',
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
            child: Text(
              flicksData?.caption ?? "",
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
