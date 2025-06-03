import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/repo/follow_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:grabto/view_model/explore_view_model.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import 'flicks_view_model.dart';

class FollowViewModel with ChangeNotifier {
  final _followRepo =FollowRepo();

  Future<void>followApi(
      context,
      dynamic followingId,
      int index,
  ExploreViewModel exploreViewModel,
           FlicksViewModel flicksViewModel
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "followerId":n.id,
      "followingId":followingId
    };
    print(data);
    _followRepo.followApi(data).then((value) {
      if (value['res'] == "success") {
        var currentList = flicksViewModel.flickList.data?.data?.data;
        if (currentList != null && index < currentList.length) {
          final item = currentList[index];
          item.isFollowingCreator = 1;
          item.followerCount = (item.followerCount ?? 0) + 1;
          flicksViewModel.notifyListeners();
          print(item.followerCount);
          print(item.isFollowingCreator);// Provider.of<GetPostViewModel>(context,listen: false).getPostApi(context);

        }
        var exploreList = exploreViewModel.exploreList.data?.data?.exploreData;
        if (exploreList != null && index < exploreList.length) {
          final item = exploreList[index];
          item.isFollowingCreator = 1;
          item.followerCount = (item.followerCount ?? 0) + 1;
          exploreViewModel.notifyListeners();
          print(item.followerCount);
          print(item.isFollowingCreator);// Provider.of<GetPostViewModel>(context,listen: false).getPostApi(context);

        }
       // Navigator.pop(context);
      } else {
        showErrorMessage(context, message: value['message']);
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
