import 'package:flutter/foundation.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/model/get_flick_model.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/model/my_follower_model.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/repo/my_followrs_repo.dart';

import '../helper/response/api_response.dart';
import '../repo/get_flick_repo.dart';

class MyFollowersViewModel with ChangeNotifier {
  final _myFollowerRepo =MyFollowrsRepo();

  ApiResponse<MyFollowersModel> myFollowersList = ApiResponse.loading();

  setMyFollowersList(ApiResponse<MyFollowersModel> response) {
    myFollowersList = response;
    notifyListeners();
  }

  Future<void>myFollowersApi(context,
      ) async {
    setMyFollowersList(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();

    _myFollowerRepo.myFollowerApi(n.id).then((value) {
      if (value.res == "success") {
        setMyFollowersList(ApiResponse.completed(value));
      } else {
        setMyFollowersList(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setMyFollowersList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
