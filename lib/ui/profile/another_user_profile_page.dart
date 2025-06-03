import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grabto/generated/assets.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/helper/user_provider.dart';
import 'package:grabto/main.dart';
import 'package:grabto/model/flicks_model.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/profile/edit_profiel_Screen.dart';
import 'package:flutter/material.dart';
import 'package:grabto/ui/profile/follower_following_screen.dart';
import 'package:grabto/ui/profile/saved_flick_screen.dart';
import 'package:grabto/ui/profile/user_flick_screen.dart';
import 'package:grabto/ui/profile/user_post_screen.dart';
import 'package:grabto/view_model/get_flick_view_model.dart';
import 'package:grabto/view_model/get_highlight_view_model.dart';
import 'package:grabto/view_model/get_post_view_model.dart';
import 'package:grabto/view_model/get_review_view_model.dart';
import 'package:grabto/view_model/my_followers_view_model.dart';
import 'package:grabto/view_model/my_following_view_model.dart';
import 'package:grabto/view_model/my_saved_flick_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import '../../model/get_post_model.dart';
import '../../view_model/profile_view_model.dart';
import '../account_setting.dart';
import 'add_post_screen.dart';

class AnotherUserProfileScreen extends StatefulWidget {
  final String id;
  const AnotherUserProfileScreen({super.key, required this.id});

  @override
  State<AnotherUserProfileScreen> createState() =>
      _AnotherUserProfileScreenState();
}

class _AnotherUserProfileScreenState extends State<AnotherUserProfileScreen> {
  @override
  void initState() {
    super.initState();
    initializeProfileData();
  }

  Future<void> initializeProfileData() async {
    Provider.of<ProfileViewModel>(context, listen: false)
        .profileApi(context, id: widget.id);
    await Provider.of<GetPostViewModel>(context, listen: false)
        .getPostApi(context, widget.id);
    await Provider.of<GetReviewViewModel>(context, listen: false)
        .getReviewApi(context, widget.id);
    await Provider.of<GetFlickViewModel>(context, listen: false)
        .getFlickApi(context, widget.id);
    await Provider.of<GetHighlightViewModel>(context, listen: false)
        .getHighlightApi(context, widget.id);
    await Provider.of<MySavedFlickViewModel>(context, listen: false)
        .mySaveFlickApi(context, widget.id);
    await Provider.of<MyFollowersViewModel>(context, listen: false)
        .myFollowersApi(context, widget.id);
    await Provider.of<MyFollowingViewModel>(context, listen: false)
        .myFollowingApi(context, widget.id);
  }

  final List<IconData> iconList = [
    Icons.grid_view,
    Icons.rate_review_outlined,
    Icons.travel_explore,
  ];
  int isSelected = 0;
  Future<String?> getThumbnailFromUrl(String videoUrl) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 250,
        quality: 75,
      );
      return thumbnailPath;
    } catch (e) {
      print('Thumbnail generation error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile =
        Provider.of<ProfileViewModel>(context).profileData.data?.data;
    final post = Provider.of<GetPostViewModel>(context).postList.data?.data;
    final flick = Provider.of<GetFlickViewModel>(context).flickList.data?.data;
    final highlight =
        Provider.of<GetHighlightViewModel>(context).highlightList.data?.data;

    final List<PostImage> allImages = [];
    if (post != null) {
      for (var p in post) {
        if (p.postImage != null) {
          allImages.addAll(p.postImage!);
        }
      }
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                CachedNetworkImage(
                  height: heights * 0.3,
                  width: widths,
                  imageUrl: profile?.coverPhoto ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/vertical_placeholder.jpg',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Center(
                      child: Image.asset("assets/images/placeholder.png")),
                ),
                Positioned(
                  top: heights * 0.05,
                  right: widths * 0.03,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountSettingsScreen()));
                    },
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: MyColors.whiteBG,
                      child: Icon(
                        Icons.share_outlined,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  child: InkWell(
                    onTap: () {
                      print("Tapped!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPostScreen(status: "4"),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [
                                Color(0xffef3e22).withAlpha(150),
                                Color(0xffef5a42),
                                Color(0xffef5a42).withAlpha(50),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: CircleAvatar(
                        radius: 42,
                        backgroundImage: NetworkImage(
                          highlight?.first.image ?? "",
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -heights * 0.04,
                  right: widths * 0.37,
                  child: const CircleAvatar(
                    radius: 10,
                    backgroundColor: MyColors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(profile?.name ?? "",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text("Get Verified",
                      style: TextStyle(
                          fontSize: 11, color: MyColors.textColorTwo)),
                ),
              ],
            ),
            Text(
              profile?.userName ?? "",
              style: TextStyle(fontSize: 11, color: MyColors.textColorTwo),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                profile?.bio ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: MyColors.textColorTwo),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: widths * 0.05),
              padding: EdgeInsets.symmetric(vertical: heights * 0.01),
              decoration: BoxDecoration(
                color: Color(0xfff2f2f1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn(profile?.post.toString() ?? "", "Posts"),
                  _buildStatColumn(profile?.follower.toString() ?? "",
                      "Followers", FollowerFollowingScreen(status: 0)),
                  _buildStatColumn(profile?.following.toString() ?? "",
                      "Following", FollowerFollowingScreen(status: 1)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widths * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen()));
                    },
                    child: Container(
                      width: widths * 0.43,
                      padding: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: MyColors.redBG,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Follow",
                          style: TextStyle(
                            fontSize: 12,
                            color: MyColors.whiteBG,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showCustomBottomSheet(context);
                    },
                    child: Container(
                      width: widths * 0.43,
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                          // color: MyColors.redBG,
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(color: MyColors.grey.withAlpha(100))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage(Assets.imagesPrimium),
                            height: heights * 0.015,
                          ),
                          Text(
                            "Message",
                            style: TextStyle(
                                fontSize: 12,
                                color: MyColors.textColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: heights * 0.06,
              width: widths,
              margin: EdgeInsets.symmetric(horizontal: widths * 0.05),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: iconList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected = index;
                      });
                    },
                    child: Container(
                      width: widths * 0.3,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: isSelected == index
                                  ? MyColors.redBG
                                  : Colors.transparent,
                              width: 2),
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
            SizedBox(height: heights * 0.02),
            isSelected == 0
                ? allImages.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                        color: MyColors.redBG,
                      ))
                    : allImages.length != 0
                        ? MasonryGridView.count(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemCount: allImages.length,
                            itemBuilder: (context, index) {
                              final data = allImages[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserPostScreen(actualIndex: index,)));
                                },
                                child: AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: CachedNetworkImage(
                                    imageUrl: data.image ?? "",
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
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported,
                                    size: 48, color: Colors.grey),
                                SizedBox(height: 12),
                                Text(
                                  'No posts yet',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                : isSelected == 1
                    ? _buildReviewItem()
                    : flick != null && flick.length != 0
                        ? GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: flick?.length ?? 0,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              mainAxisExtent: 280,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              final videoUrl = flick?[index].videoLink ?? '';

                              return FutureBuilder<String?>(
                                future: getThumbnailFromUrl(videoUrl),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: MyColors.redBG,
                                      )),
                                    );
                                  } else if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserFlickScreen()));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(snapshot.data!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Icon(Icons.broken_image,
                                          color: Colors.red),
                                    );
                                  }
                                },
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported,
                                    size: 48, color: Colors.grey),
                                SizedBox(height: 12),
                                Text(
                                  'No posts yet',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String number, String label, [Widget? screen]) {
    return InkWell(
      onTap: screen != null
          ? () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => screen));
            }
          : null,
      child: Column(
        children: [
          Text(number,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.black, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildReviewItem() {
    final review =
        Provider.of<GetReviewViewModel>(context).reviewList.data?.data;
    final profile =
        Provider.of<ProfileViewModel>(context).profileData.data?.data;
    final user = Provider.of<UserProvider>(context).user;
    return review != null && review.length != 0
        ? Container(
            width: widths * 0.9,
            height: heights,
            // margin: const EdgeInsets.symmetric( vertical: 15),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: review?.length ?? 0, // Use the length of the list
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final data = review?[index];
                return Container(
                  width: widths * 0.9,
                  height: heights * 0.36,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 15),
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
                            backgroundImage: NetworkImage(profile?.image ?? ""),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                profile?.name ?? "",
                                style: const TextStyle(
                                  color: MyColors.blackBG,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
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
                              "${data?.noRating ?? ""}/5",
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
                        "Reviewed on: ${DateFormat('dd/MM/yyy').format(DateTime.parse(data?.date.toString() ?? ""))}",
                        style: TextStyle(
                            fontSize: 9, color: MyColors.textColorTwo),
                      ),
                      Flexible(
                        child: Text(
                          data?.caption ?? "",
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
                      Divider(
                        color: MyColors.textColorTwo.withAlpha(30),
                      ),
                      Container(
                          width: widths * 0.8,
                          height: 96,
                          child: ListView.builder(
                            itemCount: data?.image?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final imageData = data?.image?[index];
                              return CachedNetworkImage(
                                width: heights * 0.12,
                                imageUrl: imageData?.image ?? "",
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image.asset(
                                  'assets/images/vertical_placeholder.jpg',
                                  // Path to your placeholder image asset
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                errorWidget: (context, url, error) => Center(
                                    child: Image.asset(
                                        "assets/images/placeholder.png")),
                              );
                            },
                          )),
                    ],
                  ),
                );
              },
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.travel_explore, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'No review yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
  }

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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      'assets/images/food1.png', // Replace with your actual asset
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    bottom: heights * 0.17,
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
                  height: heights * 0.4,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Premium Features Arriving Soon!',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'We’re preparing something special for our true foodies! Grabto Premium will unlock powerful tools to make your dining and social experience even better.',
                              style: TextStyle(
                                  fontSize: 12, color: MyColors.textColorTwo),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              cursorHeight: heights * 0.02,
                              decoration: InputDecoration(
                                hintText: 'Enter Email Address',
                                hintStyle: TextStyle(
                                    fontSize: 12, color: MyColors.textColorTwo),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: MyColors.grey.withAlpha(
                                        50), // Border color when not focused
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: MyColors.grey.withAlpha(
                                        50), // Border color when not focused
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
                                child: Text(
                                  'Get Notification via mail',
                                  style: TextStyle(color: MyColors.whiteBG),
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
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
                                        border: Border.all(
                                            color: Colors.grey.shade300),
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
                                        height: heights * 0.05,
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
                  )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                color: MyColors.textColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 52),
                        decoration: BoxDecoration(
                            // color: MyColors.redBG,
                            borderRadius: BorderRadius.circular(5),
                            color: MyColors.whiteBG),
                        child: Text(
                          "Go Back",
                          style: TextStyle(
                              fontSize: 14,
                              color: MyColors.textColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                      decoration: BoxDecoration(
                          // color: MyColors.redBG,
                          borderRadius: BorderRadius.circular(5),
                          color: MyColors.redBG),
                      child: Text(
                        "Get Notified",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyColors.whiteBG,
                            fontWeight: FontWeight.w500),
                      ),
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
              _buildSheetButton(
                  Icons.grid_view, 'Add Post', AddPostScreen(status: "1")),
              Divider(
                color: MyColors.textColorTwo.withAlpha(30),
              ),
              _buildSheetButton(Icons.travel_explore, 'Add Flick',
                  AddPostScreen(status: "2")),
              Divider(
                color: MyColors.textColorTwo.withAlpha(30),
              ),
              _buildSheetButton(Icons.rate_review_outlined, 'Add Review',
                  AddPostScreen(status: "3")),
              Divider(
                color: MyColors.textColorTwo.withAlpha(30),
              ),
              _buildSheetButton(Icons.star_border_rounded, 'Add Highlight',
                  AddPostScreen(status: "4")),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetButton(IconData icon, String label, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        });
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
