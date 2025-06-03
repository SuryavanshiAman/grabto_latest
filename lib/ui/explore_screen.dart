import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/profile/add_post_screen.dart';
import 'package:grabto/ui/profile/another_user_profile_page.dart';
import 'package:grabto/view_model/flicks_view_model.dart';
import 'package:grabto/view_model/follow_view_model.dart';
import 'package:grabto/view_model/save_flick_view_model.dart';
import 'package:grabto/view_model/un_follow_view_model.dart';
import 'package:grabto/view_model/un_save_flick_view_model.dart';
import 'package:grabto/view_model/user_post_like_view_model.dart';
import 'package:grabto/view_model/user_post_un_like_view_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../view_model/explore_view_model.dart';
import '../view_model/get_all_user_highlight_view_model.dart';
import 'comment_bottom_sheet.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;
  int selectedIndex = -1;
  Map<int, bool> _isExpandedMap = {};
  bool isExpanded = false;
  bool isLongText = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ExploreViewModel>(context, listen: false).exploreApi(context);
    Provider.of<GetAllUserHighlightViewModel>(context, listen: false).getHighlightApi(context);
  }
  final List<IconData> iconList = [
    Icons.dns_outlined,
    Icons.auto_awesome_mosaic_outlined,
  ];
 int selectedCategory=0;
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> highlights = [
      {
        'image':
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde', // profile
        'type': 'add',
        'label': 'Add Highlight',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1551218808-94e220e084d2', // sandwich
        'profile': 'https://randomuser.me/api/portraits/women/44.jpg', // avatar
        'label': 'Michelle Dam',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', // salad
        'profile': 'https://randomuser.me/api/portraits/men/32.jpg',
        'label': 'Podmark',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', // salad
        'profile': 'https://randomuser.me/api/portraits/men/32.jpg',
        'label': 'Podmark',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', // salad
        'profile': 'https://randomuser.me/api/portraits/men/32.jpg',
        'label': 'Podmark',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', // salad
        'profile': 'https://randomuser.me/api/portraits/men/32.jpg',
        'label': 'Podmark',
      },
    ];
    final exploreData = Provider.of<ExploreViewModel>(context)
        .exploreList
        .data
        ?.data
        ?.exploreData;
    final save = Provider.of<SaveFlickViewModel>(context);
    final unSave = Provider.of<UnSaveFlickViewModel>(context);
    final likeReel = Provider.of<UserPostLikeViewModel>(context);
    final unLikeReel = Provider.of<UserPostUnLikeViewModel>(context);
    final follow = Provider.of<FollowViewModel>(context);
    final unFollow = Provider.of<UnFollowViewModel>(context);
    final highlight = Provider.of<GetAllUserHighlightViewModel>(context).allHighlightList.data?.data;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(68),
        child: AppBar(
          backgroundColor: MyColors.whiteBG,
          leadingWidth: widths * 0.85,
          leading: Container(
            margin: EdgeInsets.only(left: widths * 0.04, top: 10, bottom: 5),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: MyColors.textColorTwo.withAlpha(50))),
                hintText: 'Search for profiles',
                hintStyle:
                    TextStyle(fontSize: 12, color: MyColors.textColorTwo),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 18,
                ),
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: (){
                showInsightBottomSheet(context);
              },
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.message_sharp,
                  size: 14,
                ),
              ),
            ),
            SizedBox(
              width: widths * 0.05,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 16,),
          children: [
            SizedBox(
              height: heights * 0.18,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: highlight?.length??0,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final item = highlight?[index];
                  return Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
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
                              radius: 38,
                              backgroundImage: CachedNetworkImageProvider(
                                  item?.image??""
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -16,
                            child:
                  item?.exist == 0
                                ? GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>  AddPostScreen(status: "4")));
                    },
                                  child: Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                      ),
                                      child: const Icon(Icons.add,
                                          color: Colors.white, size: 20),
                                    ),
                                )
                                :
                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      image: DecorationImage(
                                        image: NetworkImage(item?.profileImage??""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        item?.exist == 0?"Add Highlight":item?.userName??"",
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'wix',
                          color:MyColors.textColor,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only( right: 0),
              child: Row(
                children: [
                  Row(
                    // mainAxisAlignment:
                    // MainAxisAlignment.spaceBetween,
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
                        'Explore Posts',
                        style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.only(right: 16),
                    height: heights*0.03,
                    width: widths*0.16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color:MyColors.textColorTwo.withAlpha(30) )
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(right: 16),
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: iconList.length,
                      itemBuilder: (context, index) {
                        return   GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedCategory=index;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                              color: selectedCategory==index?MyColors.textColor:MyColors.whiteBG,
                            ),

                            
                            child: Icon(
                              iconList[index],
                              size: 14,
                          color: selectedCategory==index?MyColors.whiteBG:MyColors.textColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),


                ],
              ),
            ),
            const SizedBox(height: 20),
            selectedCategory==0? ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(right: 16),
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: exploreData?.length ?? 0,
              itemBuilder: (context, index) {
                final data = exploreData?[index];
                final imageList = data?.image ?? [];
                final captionText = data?.caption ?? "";
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(

                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnotherUserProfileScreen(id:data?.userId.toString()??"" )));
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(data?.profileImg ?? ""),
                              ),
                              const SizedBox(width: 10),
                              Text(data?.userName ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){

    final exploreViewModel = Provider.of<ExploreViewModel>(context, listen: false);
    final flicksViewModel = Provider.of<FlicksViewModel>(context, listen: false);
    if (data?.isFollowingCreator == 0) {
    follow.followApi(context, data?.userId, index, exploreViewModel,flicksViewModel);
    } else {
    unFollow.unFollowApi(
    context, data?.userId, index, exploreViewModel,flicksViewModel);}

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                            decoration: BoxDecoration(
                              color: MyColors.grey.withAlpha(50),
                              borderRadius: BorderRadius.circular(2),
                              // border: Border.all(color: MyColors.grey.withAlpha(100))
                            ),
                            child: Text(data?.isFollowingCreator == 0?"Follow":"Following",style: TextStyle(fontSize: 10,color: MyColors.textColor,fontWeight: FontWeight.w500),),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    CarouselSlider(
                      items: data?.image?.map((img) {
                            return GestureDetector(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: img.url ?? "",
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
                              final exploreViewModel=  Provider.of<ExploreViewModel>(context,listen: false);
                              if (data?.isLiked == 0) {
                                likeReel.postLikeApi(context, data?.id ?? "",index, exploreViewModel);
                              } else {
                                unLikeReel.userPostUnLikeApi(context, data?.id ?? "",index, exploreViewModel);
                              }
                            },
                            child: Icon(
                              data?.isLiked==0?
                                Icons.local_fire_department_outlined : Icons.local_fire_department,
                                color: data?.isLiked==0?MyColors.textColor:MyColors.redBG ,
                                size: 18)),
                        SizedBox(width: 4),
                        Text(
                          data?.likesCount.toString() ?? "0",
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                            onTap: (){
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => CommentBottomSheet(),
                              );
                            },
                            child: Icon(Icons.chat_outlined, size: 18)),
                        SizedBox(width: 4),
                        Text(
                          data?.commentsCount.toString() ?? "0",
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.location_on_outlined, size: 18),
                        SizedBox(width: 4),
                        Text(
                          data?.sharesCount.toString() ?? "0",
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
                            text: captionText,
                            style: TextStyle(fontSize: 12, fontFamily: "wix"));
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
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "wix",
                                  fontWeight: FontWeight.w500),
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
                );
              },
            ):MasonryGridView.count(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true, // <--- Important!
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount:exploreData?.length ?? 0,
              itemBuilder: (context, index) {
                final data = exploreData?[index].image;
                return   ClipRRect(
                  borderRadius: BorderRadius.circular(5),

                  child: Image.network(
                   data?.first.url??"",
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: avatar + name + follow

          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundImage:
                              NetworkImage('https://i.imgur.com/BoN9kdC.png'),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text('Michelle Dam',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                            color: MyColors.grey.withAlpha(50),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            "Follow",
                            style: TextStyle(
                                fontSize: 10,
                                color: MyColors.textColor,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/images/food1.png',
                        height: heights * 0.35,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.local_fire_department_outlined, size: 18),
                        SizedBox(width: 4),
                        Text(
                          '10.4k',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.chat_outlined, size: 18),
                        SizedBox(width: 4),
                        Text(
                          '324',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.location_on_outlined, size: 18),
                        SizedBox(width: 4),
                        Text(
                          '16',
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
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text:
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
                              style: TextStyle(fontSize: 12)),
                          TextSpan(
                              text: "      Read more",
                              style: TextStyle(
                                  color: MyColors.textColorTwo, fontSize: 12))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("10 mins ago",
                        style: TextStyle(
                            color: MyColors.textColorTwo, fontSize: 10)),
                  ],
                );
              },
            ),
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
}
