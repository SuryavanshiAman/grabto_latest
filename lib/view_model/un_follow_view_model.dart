import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/repo/un_follow_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import 'explore_view_model.dart';
import 'flicks_view_model.dart';

class UnFollowViewModel with ChangeNotifier {
  final _unFollowRepo =UnFollowRepo();

  Future<void>unFollowApi(
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
    _unFollowRepo.unFollowApi(data).then((value) {
      if (value['res'] == "success") {
        var currentList = flicksViewModel.flickList.data?.data?.data;
        if (currentList != null && index < currentList.length) {
          final item = currentList[index];
          item.isFollowingCreator = 0;
          item.followerCount = (item.followerCount ?? 1) - 1;
          flicksViewModel.notifyListeners();
        }
        var exploreList = exploreViewModel.exploreList.data?.data?.exploreData;
        if (exploreList != null && index < exploreList.length) {
          final item = exploreList[index];
          item.isFollowingCreator = 0;
          item.followerCount = (item.followerCount ?? 1) - 1;
          exploreViewModel.notifyListeners();
        }
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
