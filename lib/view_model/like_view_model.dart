import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/helper/response/api_response.dart';
import 'package:grabto/model/like_model.dart';
import 'package:grabto/repo/follow_repo.dart';
import 'package:grabto/repo/like_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import 'flicks_view_model.dart';

class LikeViewModel with ChangeNotifier {
  final _likeRepo =LikeRepo();

  ApiResponse<LikeModel> likeList = ApiResponse.loading();

  setLikeList(ApiResponse<LikeModel> response) {
    likeList = response;
    notifyListeners();
  }
  Future<void>likeApi(
      context,
      dynamic reelId,
      int index, // pass index
      FlicksViewModel flicksViewModel,
      ) async {
    setLikeList(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();
    Map data={
      "userId":n.id,
      "reelId":reelId
    };
    print(data);
    _likeRepo.likeApi(data).then((value) {
      if (value.res == "success") {
        setLikeList(ApiResponse.completed(value));
        var currentList = flicksViewModel.flickList.data?.data?.data;
        if (currentList != null && index < currentList.length) {
          final item = currentList[index];
          item.isLiked = 1;
          item.likesCount = (item.likesCount ?? 0) + 1;
          flicksViewModel.notifyListeners();
        }
      } else {
        setLikeList(ApiResponse.completed(value));

        showErrorMessage(context, message: value.message.toString());
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setLikeList(ApiResponse.error(error.toString()));

      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
