import 'package:flutter/material.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:provider/provider.dart';

import '../../helper/user_provider.dart';
import '../../model/get_post_model.dart';
import '../../view_model/get_post_view_model.dart';

class UserPostScreen extends StatelessWidget {
  const UserPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<GetPostViewModel>(context).postList.data?.data;
    final user= Provider.of<UserProvider>(context, listen: false).user;
    final List<PostImage> allImages = [];
    if (post != null) {
      for (var p in post) {
        if (p.postImage != null) {
          allImages.addAll(p.postImage!);
        }
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(68),
        child: AppBar(
          backgroundColor: MyColors.whiteBG,
            leading:InkWell(
                onTap: (){},
                child: Icon(Icons.arrow_back,size: 16,)),
          title: Text("Post",style: TextStyle(color: MyColors.textColor,fontFamily: 'wix',fontSize: 16),),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 16,right: 16),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: allImages.length,
              itemBuilder: (context, index) {
                final data=post?[index];

                return Column(
                  children: [
                    Row(
                      children: [
                         CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(user?.image??""),
                        ),
                        const SizedBox(width: 10),
                         Expanded(
                          child: Text(user?.name??"", style: TextStyle(fontWeight: FontWeight.w400,)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        allImages[index].image??"",
                        height: heights*0.35,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.local_fire_department_outlined, size: 18),
                        SizedBox(width: 4),
                        Text('10.4k',style: TextStyle(fontSize: 12),),
                        SizedBox(width: 16),
                        Icon(Icons.chat_outlined, size: 18),
                        SizedBox(width: 4),
                        Text('324',style: TextStyle(fontSize: 12),),
                        SizedBox(width: 16),
                        Icon(Icons.location_on_outlined, size: 18),
                        SizedBox(width: 4),
                        Text('16',style: TextStyle(fontSize: 12),),
                        Spacer(),
                        Icon(Icons.bookmark_border,size: 18,),
                      ],
                    ),
                    const SizedBox(height: 8),
                     Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: data?.caption??"",
                              style: TextStyle(fontSize: 12)
                          ),
                          TextSpan(
                              text: "     ' Read more", style: TextStyle(color: MyColors.textColorTwo,fontSize: 12)
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("10 mins ago", style: TextStyle(color: MyColors.textColorTwo,fontSize: 10))),
                    const SizedBox(height: 10),
                  ],
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
