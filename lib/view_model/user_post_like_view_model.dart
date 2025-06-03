import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/repo/user_post_like_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:grabto/view_model/explore_view_model.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import 'flicks_view_model.dart';

class UserPostLikeViewModel with ChangeNotifier {
  final _poseLikeRepo =UserPostLikeRepo();


  Future<void>postLikeApi(
      context,
      dynamic id,
      int index,
      ExploreViewModel exploreViewModel,) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "userId":n.id,
      "postId":id
    };
    print(data);
    _poseLikeRepo.postLikeApi(data).then((value) {
      if (value["res"] == "success") {
        var currentList = exploreViewModel.exploreList.data?.data?.exploreData;

        if (currentList != null && index < currentList.length) {
          final item = currentList[index];
          item.isLiked = 1;
          item.likesCount = (item.likesCount ?? 0) + 1;
          exploreViewModel.notifyListeners();
        }
      } else {
        showErrorMessage(context, message: value["message"].toString());
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
