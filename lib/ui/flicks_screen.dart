import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/flicks_model.dart';
import 'package:grabto/ui/profile/another_user_profile_page.dart';
import 'package:grabto/view_model/follow_view_model.dart';
import 'package:grabto/view_model/like_view_model.dart';
import 'package:grabto/view_model/un_follow_view_model.dart';
import 'package:grabto/view_model/un_like_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../generated/assets.dart';
import '../main.dart';
import '../theme/theme.dart';
import '../view_model/explore_view_model.dart';
import '../view_model/flicks_view_model.dart';
import '../view_model/save_flick_view_model.dart';
import '../view_model/un_save_flick_view_model.dart';
import '../widget/sub_categories_card_widget.dart';
import 'coupon_fullview_screen.dart';

class FlicksScreen extends StatefulWidget {
  const FlicksScreen({super.key});

  @override
  State<FlicksScreen> createState() => _FlicksScreenState();
}

class _FlicksScreenState extends State<FlicksScreen> {
  FlicksViewModel flicksViewModel = FlicksViewModel();

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
      body: Consumer<FlicksViewModel>(
        builder: (context, resultValue, _) {
          final beta = resultValue.flickList.data?.data?.data;
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: beta?.length ?? 0,
            itemBuilder: (context, index) {
              final flicks = beta?[index];
              return FoodPostCard(
                index: index,
                flicksData: flicks,
              );
            },
          );
        },
      ),
    );
  }
}

class FoodPostCard extends StatefulWidget {
  final int index;
  final FlicksData? flicksData;

  const FoodPostCard({
    super.key,
    required this.index,
    this.flicksData,
  });

  @override
  State<FoodPostCard> createState() => _FoodPostCardState();
}

class _FoodPostCardState extends State<FoodPostCard> {
  bool saveReel = false;
  bool isLiked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FlicksViewModel>(context);
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return CouponFullViewScreen(widget.flicksData?.storeId.toString()??"");
                              }));
                            },
                            child: Column(
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
                                        fontFamily: 'wix',
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.whiteBG),
                                  ),
                                ),
                              ],
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
                ],
              )),
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    final flicksViewModel =
                        Provider.of<FlicksViewModel>(context, listen: false);
                    flicksViewModel.setSelectedIndex(widget.index);

                    if (widget.flicksData?.isLiked == 0) {
                      likeReel.likeApi(context, widget.flicksData?.id ?? "",
                          widget.index, flicksViewModel);
                    } else {
                      unLikeReel.unLikeApi(context, widget.flicksData?.id ?? "",
                          widget.index, flicksViewModel);
                    }
                  },
                  child: IconWithLabel(
                    // image: widget.flicksData?.likesCount == 1
                    //     ? Icons.local_fire_department
                    //     : Icons.local_fire_department_outlined,
                    image:widget.flicksData?.likesCount == 1?Assets.imagesLikeFill:Assets.imagesLikeOutLined,
                    color: widget.flicksData?.likesCount == 1
                        ? MyColors.redBG
                        : MyColors.whiteBG,
                    label: '${widget.flicksData?.likesCount ?? "0"}',
                  ),
                ),
                SizedBox(height: 16),
                IconWithLabel(
                    icon: Icons.message_outlined,
                    color: MyColors.whiteBG,
                    label: '${widget.flicksData?.commentsCount ?? "0"}'),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    final flicksViewModel = Provider.of<FlicksViewModel>(context, listen: false);
                    flicksViewModel.setSelectedIndex(widget.index);
                    if (widget.flicksData?.isFavorited == 1) {
                      unSave.unSaveFlickApi(
                          context,
                          widget.flicksData?.id ?? "",
                          widget.index,
                          flicksViewModel);
                    } else {
                      save.saveFlickApi(context, widget.flicksData?.id ?? "",
                          widget.index, flicksViewModel);
                    }
                  },
                  child: IconWithLabel(
                      icon: widget.flicksData?.isFavorited == 0
                          ? Icons.bookmark_border
                          : Icons.bookmark,
                      color: widget.flicksData?.isFavorited == 1
                          ? MyColors.redBG
                          : MyColors.whiteBG,
                      label: '${widget.flicksData?.favoritesCount ?? ""}'),
                ),
                SizedBox(height: 16),
                IconWithLabel(
                  icon: Icons.share,
                  label: '${widget.flicksData?.sharesCount ?? ""}',
                  color: MyColors.whiteBG,
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 50,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnotherUserProfileScreen(
                                id: widget.flicksData?.userId.toString()??"")));
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.flicksData?.profileImage ?? "",
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnotherUserProfileScreen(
                                id: widget.flicksData?.userId.toString()??"")));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.flicksData?.userName ?? "",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('${widget.flicksData?.followerCount} Follower',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    final exploreViewModel =
                        Provider.of<ExploreViewModel>(context, listen: false);
                    final flicksViewModel =
                        Provider.of<FlicksViewModel>(context, listen: false);
                    flicksViewModel.setSelectedIndex(widget.index);
                    if (widget.flicksData?.isFollowingCreator == 0) {
                      follow.followApi(context, widget.flicksData?.userId,
                          widget.index, exploreViewModel, flicksViewModel);
                    } else {
                      unFollow.unFollowApi(context, widget.flicksData?.userId,
                          widget.index, exploreViewModel, flicksViewModel);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: MyColors.blackBG.withAlpha(80),
                      borderRadius: BorderRadius.circular(5),
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
              ],
            ),
          ),
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
  final IconData? icon;
  final String? image;
  final String label;
  Color? color;

  IconWithLabel(
      {super.key,  this.icon, required this.label, this.color, this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        image!=null ?Image(image: AssetImage(image??""),height: heights*0.045,):Container(),
       icon!=null? Icon(
          icon,
          color: color,
          size: 28,
        ):Container(),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
