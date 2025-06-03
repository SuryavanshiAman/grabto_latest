import 'package:flutter/foundation.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/model/my_follower_model.dart';
import 'package:grabto/model/my_following_model.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/repo/my_followrs_repo.dart';

import '../helper/response/api_response.dart';
import '../repo/my_following_repo.dart';

class MyFollowingViewModel with ChangeNotifier {
  final _myFollowingRepo =MyFollowingRepo();

  ApiResponse<MyFollowingModel> myFollowingList = ApiResponse.loading();

  setMyFollowingRList(ApiResponse<MyFollowingModel> response) {
    myFollowingList = response;
    notifyListeners();
  }

  Future<void>myFollowingApi(context,dynamic id
      ) async {
    setMyFollowingRList(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();

    _myFollowingRepo.myFollowingApi(id).then((value) {
      if (value.res == "success") {
        setMyFollowingRList(ApiResponse.completed(value));
      } else {
        setMyFollowingRList(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setMyFollowingRList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
