
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HowItWorksScreen extends StatefulWidget {
  const HowItWorksScreen({Key? key}) : super(key: key);

  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Extract video ID from the URL
    const videoUrl = "https://www.youtube.com/shorts/6tmXzaV9qgQ";
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId!,  // Use the extracted video ID
      flags: const YoutubePlayerFlags(
        autoPlay: false,  // Set to true if you want to autoplay
        mute: false,
        loop: false,
        enableCaption: true,  // Enable subtitles if available
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("How It Work")),
      body: Center(
        child: YoutubePlayer(
          aspectRatio: 16/25,
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          onReady: () {
            debugPrint("YouTube player is ready.");
          },
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:grabto/main.dart';
// import 'package:grabto/theme/theme.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class HowItWorksScreen extends StatefulWidget {
//   @override
//   State<HowItWorksScreen> createState() => _HowItWorksScreenState();
// }
//
// class _HowItWorksScreenState extends State<HowItWorksScreen> {
//   final List<Map<String, dynamic>> infoList = [
//     {
//       'title': 'Explore Restaurants Around You',
//       'content':
//       'Open the Explore tab to browse trending restaurants, local gems, and foodie-approved places. Check out photos, ratings, and real-time reviews from other users.',
//     },
//     {
//       'title': 'Pay Your Bill & Unlock Discounts',
//       'content':
//       'No more awkward coupon codes!\nJust eat, open Grabto, tap "Pay Bill", select the restaurant, and pay directly from the app to enjoy instant discounts and cashback.',
//     },
//     {
//       'title': 'Share Your Foodie Moments',
//       'content': '',
//       'points': [
//         {'icon': Icons.image, 'text': 'Photos — Snap and share delicious dishes.'},
//         {'icon': Icons.movie, 'text': 'Flicks — Short, fun video moments from your meals.'},
//         {'icon': Icons.rate_review, 'text': 'Reviews — Share honest feedback about the restaurant.'},
//       ]
//     },
//     {
//       'title': 'Follow Foodies, Build Your Circle',
//       'content':
//       'Grabto isn’t just about food — it’s about the people behind the plates.\nFollow friends, family, and top foodies to see where they’re dining and get inspired for your next outing.',
//     },
//     {
//       'title': 'Earn, Save & Repeat',
//       'content':
//       'The more you dine via Grabto, the more you save.\nStay active, share more, and unlock exclusive partner deals and early access to new restaurants.',
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyColors.whiteBG,
//       appBar: AppBar(
//         backgroundColor: MyColors.whiteBG,
//         leading: InkWell(
//             onTap: (){
//               Navigator.pop(context);
//             },
//             child: Icon(Icons.arrow_back,size: 18,)),
//           title: Text("How to use App?",style: TextStyle(fontSize: 16),)),
//       body: ListView(
//         shrinkWrap: true,
//         padding: EdgeInsets.all(16),
//         children: [
//           Expanded(
//             child: ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               // padding: EdgeInsets.all(16),
//               itemCount: infoList.length,
//               itemBuilder: (context, index) {
//                 final item = infoList[index];
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "${index + 1}. ${item['title']}",
//                             style: TextStyle( fontSize: 14,fontWeight: FontWeight.w500),
//                           ),
//                           Icon(Icons.keyboard_arrow_up)
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       if (item['content'] != '')
//                         Text(
//                           item['content'],
//                           style: TextStyle(fontSize: 12,color: MyColors.textColorTwo),
//                         ),
//                       if (item['points'] != null)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: (item['points'] as List)
//                               .map((point) => Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 4.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Icon(point['icon'], size: 18, color: Colors.green),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(point['text'], style: TextStyle(fontSize: 12,color: MyColors.textColorTwo)),
//                                 ),
//                               ],
//                             ),
//                           ))
//                               .toList(),
//                         ),
//                       Divider(color: MyColors.textColorTwo.withAlpha(30),),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               "Help us improve",
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               "Report a bug or suggest ways to make Grabto better.",style: TextStyle(fontWeight: FontWeight.w500,color: MyColors.textColorTwo),
//             ),
//           ),
//           const SizedBox(height: 10),
//
//           Align(
//             alignment: Alignment.centerRight,
//             child: Container(
//               width: widths*0.39,
//               padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
//               decoration: BoxDecoration(
//                 color: MyColors.redBG,
//                 borderRadius: BorderRadius.circular(5),
//                 // border: Border.all(color: MyColors.grey.withAlpha(100))
//               ),
//               child: Row(
//                 children: [
//                   Text("Give Feedback ",style: TextStyle(fontSize: 12,color: MyColors.whiteBG,fontWeight: FontWeight.w500),),
//                   Icon(Icons.arrow_forward,color: MyColors.whiteBG,size: 12,)
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Follow us on",
//                   style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.textColorTwo.withAlpha(50),fontSize: 22),
//                 ),
//                 SizedBox(
//                   width: widths*0.4,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Image.asset("assets/images/youtube.png"),
//                       ),
//                       Image.asset("assets/images/insta.png"),
//                       Image.asset("assets/images/facebook.png"),
//                       Image.asset("assets/images/linkdin.png"),
//                       // IconButton(onPressed: () {}, icon: const Icon(Icons.play_circle_filled_outlined)),
//                       // IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
//                       // IconButton(onPressed: () {}, icon: const Icon(Icons.facebook_outlined)),
//                       // IconButton(onPressed: () {}, icon: const Icon(Icons.linked_camera_outlined)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }
