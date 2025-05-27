import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/my_following_model.dart';
import '../../theme/theme.dart';
import '../../view_model/my_following_view_model.dart';


class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {

  @override
  Widget build(BuildContext context) {
    final following=  Provider.of<MyFollowingViewModel>(context,listen: false).myFollowingList.data?.data;
    return   Column(
      children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: SizedBox(
            height: heights * 0.05,
            child: TextField(
              // controller: _searchController,
              decoration: InputDecoration(
                  hintText: 'Search for profile',
                  hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'wix',
                      color: MyColors.textColorTwo),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 7),
                  suffixIcon: Icon(
                    Icons.search,
                    size: 16,
                    color: MyColors.textColorTwo.withAlpha(100),
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderSide:
                    BorderSide(color: MyColors.grey.withAlpha(30)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: MyColors.grey.withAlpha(30)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  suffix: Icon(
                    Icons.search,
                    size: 16,
                    color: MyColors.textColorTwo,
                  )),
            ),
          ),
          // TextField(
          //   decoration: InputDecoration(
          //     hintText: 'Search for profile',
          //     prefixIcon: Icon(Icons.search),
          //     border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          //   ),
          // ),
        ),
        following!=null&&following.length!=0?   Expanded(
          child: ListView.builder(
            itemCount: following.length??0,
            itemBuilder: (context, index) {
              return _buildUserTile(following[index]);
            },
          ),
        ):Center(child: Text("No User Found...")),
      ],
    );
  }
  Widget _buildUserTile(Data?following) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(following?.image??""),
      ),
      title: Row(
        children: [
          Text(following?.name??"",
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'wix')),
          const SizedBox(width: 4),
          const Icon(Icons.verified, color: MyColors.blueBG, size: 14),
        ],
      ),
      subtitle: Text(following?.userName??"",
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 12, fontFamily: 'wix',color: MyColors.textColorTwo)),
      trailing: following?.isFollowedByCurrentUser??""
          ? Container(
        width: widths * 0.25,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          // color: MyColors.redBG,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: MyColors.grey.withAlpha(100))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage("assets/images/primium.png"),
              height: heights * 0.015,
            ),
            // Image.asset(,scale: 1,),
            Text(
              "Message",
              style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'wix',
                  color: MyColors.textColor,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      )
          : Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        decoration: BoxDecoration(
          color: MyColors.redBG,
          borderRadius: BorderRadius.circular(5),
          // border: Border.all(
          // color: MyColors.grey.withAlpha(100)
          // )
        ),
        child: Text(
          "Follow",
          style: TextStyle(
              fontSize: 12,
              fontFamily: 'wix',
              color: MyColors.whiteBG,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
