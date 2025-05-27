import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/flicks_model.dart';
import 'package:grabto/view_model/follow_view_model.dart';
import 'package:grabto/view_model/like_view_model.dart';
import 'package:grabto/view_model/un_follow_view_model.dart';
import 'package:grabto/view_model/un_like_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../theme/theme.dart';
import '../view_model/flicks_view_model.dart';
import '../view_model/save_flick_view_model.dart';
import '../view_model/un_save_flick_view_model.dart';
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

class FoodPostCard extends StatefulWidget {
  final int index;
  final FlicksData? flicksData;

  const FoodPostCard({super.key, required this.index, this.flicksData});

  @override
  State<FoodPostCard> createState() => _FoodPostCardState();
}

class _FoodPostCardState extends State<FoodPostCard> {
  bool saveReel = false;
  bool like = false;

  @override
  Widget build(BuildContext context) {
    final save = Provider.of<SaveFlickViewModel>(context);
    final unSave = Provider.of<UnSaveFlickViewModel>(context);
    final likeReel = Provider.of<LikeViewModel>(context);
    final unLikeReel = Provider.of<UnLikeViewModel>(context);
    final follow = Provider.of<FollowViewModel>(context);
    final unFollow = Provider.of<UnFollowViewModel>(context);
    return SizedBox(
      height: heights,
      width: widths,
      child: Stack(
        children: [
          Center(
              child: VideoPlayerWidget(
                  videoUrl: widget.flicksData?.videoLink ?? "")),
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
                            imageUrl: widget.flicksData?.image ?? "",
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
                                  widget.flicksData?.storeName ?? "",
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
                                  widget.flicksData?.address ?? "",
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
                              final url =
                                  Uri.parse(widget.flicksData?.mapLink ?? "");
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
                                final url =
                                    Uri.parse(widget.flicksData?.mapLink ?? "");
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
                InkWell(
                  onTap: () {
                    setState(() {
                      like = !like;
                      like == false
                          ? unLikeReel.unLikeApi(
                          context, widget.flicksData?.id ?? "")
                          : likeReel.likeApi(
                          context, widget.flicksData?.id ?? "");
                    });
                  },
                  child: IconWithLabel(
                      icon:widget.flicksData?.isLiked==0? Icons.local_fire_department_outlined:Icons.local_fire_department,
                      label: '${widget.flicksData?.likesCount ?? "0"}'),
                ),
                SizedBox(height: 16),
                IconWithLabel(
                    icon: Icons.message_outlined,
                    label: '${widget.flicksData?.commentsCount ?? "0"}'),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    setState(() {
                      saveReel = !saveReel;
                      saveReel == false
                          ? unSave.unSaveFlickApi(
                              context, widget.flicksData?.id ?? "")
                          : save.saveFlickApi(
                              context, widget.flicksData?.id ?? "");
                    });
                  },
                  child: IconWithLabel(
                      icon: saveReel == false
                          ? Icons.bookmark_border
                          : Icons.bookmark,
                      label: '${widget.flicksData?.likesCount ?? ""}'),
                ),
                SizedBox(height: 16),
                IconWithLabel(
                    icon: Icons.share,
                    label: '${widget.flicksData?.sharesCount ?? ""}'),
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
                    widget.flicksData?.profileImage ?? "",
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.flicksData?.userName ?? "",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('${widget.flicksData?.followerCount } Follower',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                // Spacer(),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.flicksData?.isFollowingCreator == 0
                          ? follow.followApi(context, widget.flicksData?.userId)
                          : unFollow.unFollowApi(
                              context, widget.flicksData?.userId);
                    });
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
                      widget.flicksData?.isFollowingCreator == 0
                          ? "Follow"
                          : "Following",
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
              widget.flicksData?.caption ?? "",
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
