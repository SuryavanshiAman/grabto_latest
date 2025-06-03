import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grabto/generated/assets.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/helper/user_provider.dart';
import 'package:grabto/main.dart';
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

class ProfileBottomScreen extends StatefulWidget {
  const ProfileBottomScreen({super.key});

  @override
  State<ProfileBottomScreen> createState() => _ProfileBottomScreenState();
}

class _ProfileBottomScreenState extends State<ProfileBottomScreen> {
  String userName = '';
  String userEmail = '';
  String userMobile = '';
  String userImage = '';
  String userLocation = '';
  String userDob = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeProfileData();
      Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
    });
  }

  Future<void> initializeProfileData() async {
    try {
      UserModel n = await SharedPref.getUser();
      final context = this.context;
      Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
      Provider.of<GetPostViewModel>(context, listen: false)
          .getPostApi(context, n.id);
      Provider.of<GetReviewViewModel>(context, listen: false)
          .getReviewApi(context, n.id);
      Provider.of<GetFlickViewModel>(context, listen: false)
          .getFlickApi(context, n.id);
      Provider.of<GetHighlightViewModel>(context, listen: false)
          .getHighlightApi(context, n.id);
      Provider.of<MySavedFlickViewModel>(context, listen: false)
          .mySaveFlickApi(context, n.id);
      Provider.of<MyFollowersViewModel>(context, listen: false)
          .myFollowersApi(context, n.id);
      Provider.of<MyFollowingViewModel>(context, listen: false)
          .myFollowingApi(context, n.id);
    } catch (e, st) {
      print("❌ Error in initializeProfileData: $e\n$st");
      // Optionally show error UI or retry
    }
  }

  final List<IconData> iconList = [
    Icons.grid_view,
    Icons.rate_review_outlined,
    Icons.travel_explore,
    Icons.bookmark_add_outlined,
  ];
  final List<String> _image = [
    "assets/images/browse.png",
    "assets/images/rate_review.png",
    "assets/images/travel_explore.png",
    "assets/images/bookmark_star.png",
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
    final savedFlick = Provider.of<MySavedFlickViewModel>(context)
        .savedFlickList
        .data
        ?.data
        ?.data;

    final List<PostImage> allImages = [];
    if (post != null) {
      for (var p in post) {
        if (p.postImage != null) {
          allImages.addAll(p.postImage!);
        }
      }
    }
    return Consumer<ProfileViewModel>(
      builder: (context, ProfileViewModel, child) {
        final user = ProfileViewModel.profileData.data?.data;
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: heights * 0.3,
              width: widths,
              decoration: BoxDecoration(
                image: DecorationImage(image: CachedNetworkImageProvider( profile?.coverPhoto ?? "",),fit: BoxFit.cover)
              ),
              child:
              Padding(
                padding:  EdgeInsets.only(bottom: heights*0.18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
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
                    SizedBox(width: widths*0.03,),
                    InkWell(
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
                          Icons.settings_outlined,
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: widths*0.03,),
                  ],
                ),
              ),
            ),
            // Stack(
            //   alignment: Alignment.center,
            //   clipBehavior: Clip.none,
            //   children: [
            //     CachedNetworkImage(
            //       height: heights * 0.3,
            //       width: widths,
            //       imageUrl: profile?.coverPhoto ?? "",
            //       fit: BoxFit.cover,
            //       placeholder: (context, url) => Image.asset(
            //         'assets/images/vertical_placeholder.jpg',
            //         // Path to your placeholder image asset
            //         fit: BoxFit.fill,
            //         width: double.infinity,
            //         height: double.infinity,
            //       ),
            //       errorWidget: (context, url, error) => Center(
            //           child: Image.asset("assets/images/placeholder.png")),
            //     ),
            //     Positioned(
            //       top: heights * 0.05,
            //       right: widths * 0.03,
            //       child: InkWell(
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => AccountSettingsScreen()));
            //         },
            //         child: CircleAvatar(
            //           radius: 12,
            //           backgroundColor: MyColors.whiteBG,
            //           child: Icon(
            //             Icons.settings_outlined,
            //             size: 16,
            //           ),
            //         ),
            //       ),
            //     ),
            //     Positioned(
            //       top: heights * 0.05,
            //       right: widths * 0.13,
            //       child: InkWell(
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => AccountSettingsScreen()));
            //         },
            //         child: CircleAvatar(
            //           radius: 12,
            //           backgroundColor: MyColors.whiteBG,
            //           child: Icon(
            //             Icons.share_outlined,
            //             size: 16,
            //           ),
            //         ),
            //       ),
            //     ),
            //     Positioned(
            //       bottom: -30,
            //       child: InkWell(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => AddPostScreen(status: "4"),
            //             ),
            //           );
            //         },
            //         child: Container(
            //           padding: EdgeInsets.all(3),
            //           decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               gradient: LinearGradient(
            //                   colors: [
            //                     Color(0xffef3e22).withAlpha(150),
            //                     Color(0xffef5a42),
            //                     Color(0xffef5a42).withAlpha(50),
            //                   ],
            //                   begin: Alignment.topCenter,
            //                   end: Alignment.bottomCenter)),
            //           child: CircleAvatar(
            //             radius: 42,
            //             backgroundImage: NetworkImage(
            //               highlight?.first.image ?? "",
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Positioned(
            //       bottom: 10,
            //       right: widths * 0.36,
            //       child: Material(
            //         color: Colors.transparent,
            //         shape: CircleBorder(),
            //         child: InkWell(
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => AddPostScreen(status: "4"),
            //               ),
            //             );
            //           },
            //           customBorder: CircleBorder(),
            //           child: const CircleAvatar(
            //             radius: 14,
            //             backgroundColor: MyColors.textColor,
            //             child: Icon(Icons.add, size: 18, color: Colors.white),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const SizedBox(height: 50),
            Positioned(
              top: -40,
              left: widths*0.37,
              // right: 0,
              child: InkWell(
                onTap: () {
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
              top: 10,
              right: widths * 0.36,
              child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPostScreen(status: "4"),
                      ),
                    );
                  },
                  customBorder: CircleBorder(),
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: MyColors.textColor,
                    child: Icon(Icons.add, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(user?.name ?? "",
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
            InkWell(
              onTap: () {},
              child: Center(
                child: Text(
                  user?.userName ?? "",
                  style: TextStyle(fontSize: 11, color: MyColors.textColorTwo),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                user?.bio ?? "",
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
                  _buildStatColumn(user?.post.toString() ?? "", "Posts"),
                  _buildStatColumn(user?.follower.toString() ?? "",
                      "Followers", FollowerFollowingScreen(status: 0)),
                  _buildStatColumn(user?.following.toString() ?? "",
                      "Following", FollowerFollowingScreen(status: 1)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                      decoration: BoxDecoration(
                        color: MyColors.redBG,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 12,
                          color: MyColors.whiteBG,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showInsightBottomSheet(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(
                          // color: MyColors.redBG,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: MyColors.grey.withAlpha(100))),
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage(Assets.imagesPrimium),
                            height: heights * 0.015,
                          ),
                          SizedBox(
                            width: widths * 0.03,
                          ),
                          Text(
                            "Insights",
                            style: TextStyle(
                                fontSize: 12,
                                color: MyColors.textColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showCustomBottomSheet(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                      decoration: BoxDecoration(
                          // color: MyColors.redBG,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: MyColors.grey.withAlpha(100))),
                      child: Text(
                        "Add Post",
                        style: TextStyle(
                            fontSize: 12,
                            color: MyColors.textColor,
                            fontWeight: FontWeight.w500),
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
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected = index;
                      });
                    },
                    child: Container(
                      width: widths * 0.23,
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
            SizedBox(height: heights * 0.01),
            isSelected == 0
                ? allImages.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                        color: MyColors.redBG,
                      ))
                    : allImages.length != 0
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Column(
                              children: [
                                Container(
                                  height: heights *
                                      0.27, // You can also use MediaQuery if needed, or wrap in AspectRatio
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          allImages[0].image ?? ""),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: heights * 0.005,
                                ),
                                MasonryGridView.count(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  itemCount: allImages.length,
                                  itemBuilder: (context, index) {
                                    final data = allImages[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserPostScreen( actualIndex: index,)));
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5),
                                        child: AspectRatio(
                                          aspectRatio: 7 / 9,
                                          child: CachedNetworkImage(
                                            imageUrl: data.image ?? "",
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Center(
                                                    child: Icon(Icons.error)),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
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
                    : isSelected == 2
                        ? flick != null && flick.length != 0
                            ? GridView.builder(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
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
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  final videoUrl =
                                      flick?[index].videoLink ?? '';

                                  return FutureBuilder<String?>(
                                    future: getThumbnailFromUrl(videoUrl),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator(
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                        : savedFlick != null && savedFlick.length != 0
                            ? GridView.builder(
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 0),

                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: savedFlick?.length ?? 0,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  mainAxisExtent: 280,
                                ),
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  final videoUrl =
                                      savedFlick?[index].videoLink ?? '';

                                  return FutureBuilder<String?>(
                                    future: getThumbnailFromUrl(videoUrl),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator(
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
                                                        SaveFlickScreen()));
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                  children: [
                                    Icon(Icons.bookmark_add_outlined,
                                        size: 48, color: Colors.grey),
                                    Text(
                                      "Start Saving ",
                                      style: TextStyle(
                                          fontFamily: "wix",
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Save photos and videos to your all posts collection",
                                      style: TextStyle(
                                          fontFamily: "wix",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: MyColors.textColorTwo),
                                    ),
                                  ],
                                ),
                              )
          ],
        );
      },
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
    return review != null && review.length != 0
        ? ListView.builder(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
          itemCount: review?.length ?? 0, // Use the length of the list
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final data = review?[index];
            return Card(
              child: Container(
                width: widths * 0.9,
                height: heights * 0.36,
                padding: const EdgeInsets.all(12),
                // margin: const EdgeInsets.symmetric( vertical: 5),
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
                          backgroundImage:
                              NetworkImage(profile?.image ?? ""),
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
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CachedNetworkImage(
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
                              ),
                            );
                          },
                        )),
                  ],
                ),
              ),
            );
          },
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
                  Assets.imagesBrowse, 'Add Post', AddPostScreen(status: "1")),
              Divider(
                color: MyColors.textColorTwo.withAlpha(30),
              ),
              _buildSheetButton( Assets.imagesTravelExplore, 'Add Flick',
                  AddPostScreen(status: "2")),
              Divider(
                color: MyColors.textColorTwo.withAlpha(30),
              ),
              _buildSheetButton( Assets.imagesRateReview, 'Add Review',
                  AddPostScreen(status: "3")),
              Divider(
                color: MyColors.textColorTwo.withAlpha(30),
              ),
              _buildSheetButton( Assets.imagesFamilyStar, 'Add Highlight',
                  AddPostScreen(status: "4")),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetButton(String image, String label, Widget screen) {
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
            Image(image: AssetImage(image),height:heights*0.02 ,),
            // Icon(icon, size: 18, color: Colors.black),
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

/// old profile screen
// Container(
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
//                   ),
//                 ),
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
//                   // navigateToEditProfileBottomScreen();
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
// )
