import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../helper/user_provider.dart';
import '../../model/get_post_model.dart';
import '../../view_model/explore_view_model.dart';
import '../../view_model/get_post_view_model.dart';
import '../../view_model/user_post_like_view_model.dart';
import '../../view_model/user_post_un_like_view_model.dart';

class UserPostScreen extends StatefulWidget {
  final int actualIndex;
  const UserPostScreen({super.key,required this.actualIndex});

  @override
  State<UserPostScreen> createState() => _UserPostScreenState();
}

class _UserPostScreenState extends State<UserPostScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;
  int selectedIndex = -1;
  Map<int, bool> _isExpandedMap = {};
  bool isExpanded = false;
  bool isLongText = false;
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _postKeys = {};
  @override
  void initState() {
    super.initState();

    // Delay scroll until build is done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _postKeys[widget.actualIndex];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<GetPostViewModel>(context).postList.data?.data;
    final profile = Provider.of<ProfileViewModel>(context).profileData.data?.data;
    final likeReel = Provider.of<UserPostLikeViewModel>(context);
    final unLikeReel = Provider.of<UserPostUnLikeViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(68),
        child: AppBar(
          backgroundColor: MyColors.whiteBG,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 16,
              )),
          title: Text(
            "Post",
            style: TextStyle(
                color: MyColors.textColor, fontFamily: 'wix', fontSize: 16),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: post?.length ?? 0,
              itemBuilder: (context, index) {
                _postKeys[index] = GlobalKey();
                final data = post?[index];
                final imageList = data?.postImage ?? [];
                // bool isExpanded = _isExpandedMap[index] ?? false;
                final captionText = data?.caption ?? "";
// print( allImages.length);
                return Container(
                  key: _postKeys[index],
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage(profile?.image ?? ""),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(profile?.userName ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CarouselSlider(
                        items: data?.postImage?.map((img) {
                              return GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: img.image ?? "",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/placeholder.png',
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Center(child: Icon(Icons.error)),
                                  ),
                                ),
                              );
                            }).toList() ??
                            [],
                        carouselController:
                            _carouselController, // Use empty list if image is null
                        options: CarouselOptions(
                          height: heights * 0.4,
                          enlargeCenterPage: true,
                          autoPlay: false,
                          reverse: true,
                          disableCenter: true,
                          aspectRatio: 1 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          initialPage: widget.actualIndex,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      imageList.length != 1
                          ? Center(
                              child: AnimatedSmoothIndicator(
                                activeIndex: _currentIndex,
                                count: imageList.length,
                                effect: const ExpandingDotsEffect(
                                  dotHeight: 5,
                                  dotWidth: 5,
                                  spacing: 5,
                                  expansionFactor: 4,
                                  activeDotColor: MyColors.redBG,
                                  dotColor: MyColors.grey,
                                ),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                // final exploreViewModel=  Provider.of<ExploreViewModel>(context,listen: false);
                                // if (data?.isLiked == 0) {
                                //   likeReel.postLikeApi(context, data?.id ?? "",index, exploreViewModel);
                                // } else {
                                //   unLikeReel.userPostUnLikeApi(context, data?.id ?? "",index, exploreViewModel);
                                // }
                              },
                              child: Icon(Icons.local_fire_department_outlined, size: 18)),
                          SizedBox(width: 4),
                          data?.hideFireCount!=""? Text(
                            data?.hideFireCount ?? "0",
                            style: TextStyle(fontSize: 12),
                          ):Text( "0",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.chat_outlined, size: 18),
                          SizedBox(width: 4),
                          data?.turnOfComment !="" ?Text(
                            data?.turnOfComment ?? "0",
                            style: TextStyle(fontSize: 12),
                          ):Text("0",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.location_on_outlined, size: 18),
                          SizedBox(width: 4),
                          data?.hideShareCountPage!="" ? Text(
                            data?.hideShareCountPage ?? "0",
                            style: TextStyle(fontSize: 12),
                          ): Text( "0",
                            style: TextStyle(fontSize: 12),
                          ),
                          Spacer(),
                          Icon(
                            Icons.bookmark_border,
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final span = TextSpan(
                              text: captionText, style: TextStyle(fontSize: 12,fontFamily: "wix"));
                          final tp = TextPainter(
                            text: span,
                            maxLines: 2,
                            textDirection: TextDirection.ltr,
                          );
                          tp.layout(maxWidth: constraints.maxWidth);

                          isLongText = tp.didExceedMaxLines;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                captionText,
                                style: TextStyle(fontSize: 12,fontFamily: "wix",fontWeight: FontWeight.w500),
                                maxLines: isExpanded ? null : 2,
                                overflow: isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                              ),
                              if (isLongText)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                    child: Text(
                                      isExpanded ? 'Read Less' : 'Read More',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'wix',
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.textColorTwo,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("10 mins ago",
                              style: TextStyle(
                                  color: MyColors.textColorTwo, fontSize: 10))),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
            // _buildPostCard(),
          ],
        ),
      ),
    );
  }
}
