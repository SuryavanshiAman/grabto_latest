import 'package:flutter/material.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/profile/follower_screen.dart';
import 'package:grabto/ui/profile/following_screen.dart';
import 'package:grabto/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class FollowerFollowingScreen extends StatefulWidget {
  final int status;
  const FollowerFollowingScreen({super.key, required this.status});

  @override
  State<FollowerFollowingScreen> createState() => _FollowerFollowingScreenState();
}

class _FollowerFollowingScreenState extends State<FollowerFollowingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> followers = List.generate(10, (index) {
    return {
      'name': index == 3 || index == 4 ? 'Sanjay Mishra' : 'Michelle Dam',
      'username': '@sanjay_foddie_1234',
      'isFollowing': index == 3 || index == 4 ? false : true,
      'image': 'https://i.pravatar.cc/150?img=${index + 1}',
    };
  });

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this,initialIndex: widget.status);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileViewModel>(context).profileData.data?.data;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title:  Text(
          profile?.userName??"",
          style: TextStyle(
              fontFamily: 'wix', fontSize: 16, fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          indicatorColor: MyColors.redBG,
          labelColor: MyColors.textColor,
          unselectedLabelColor: MyColors.textColorTwo,
          tabs:  [
            Tab(text: '${profile?.follower??""} Followers'),
            Tab(text: '${profile?.following??""} Following'),
          ],
        ),
      ),
      body:  TabBarView(
        controller: _tabController,
        children: [
         FollowerScreen(),
          FollowingScreen()
        ],
      ),
    );
  }
}
