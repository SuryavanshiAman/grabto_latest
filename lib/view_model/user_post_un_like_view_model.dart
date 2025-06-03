import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/repo/user_post_un_like_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:grabto/view_model/explore_view_model.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import '../repo/un_like_repo.dart';
import 'flicks_view_model.dart';

class UserPostUnLikeViewModel with ChangeNotifier {
  final _postUnLikeRepo =UserPostUnLikeRepo();

  Future<void>userPostUnLikeApi(
      context,
      dynamic id,
      int index,
      ExploreViewModel exploreViewModel,
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "userId":n.id,
      "postId":id
    };
    print(data);
    _postUnLikeRepo.userPostUnLikeApi(data).then((value) {
      if (value['res'] == "success") {
        var currentList =  exploreViewModel.exploreList.data?.data?.exploreData;
        if (currentList != null && index < currentList.length) {
          final item = currentList[index];
          item.isLiked = 0;
          item.likesCount = (item.likesCount ?? 1) - 1;
          exploreViewModel.notifyListeners(); // 🔄 Refresh UI
        }      } else {
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
