import 'package:flutter/foundation.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/repo/get_post_repo.dart';

import '../helper/response/api_response.dart';

class GetPostViewModel with ChangeNotifier {
  final _getPostRepo =GetPostRepo();

  ApiResponse<GetPostModel> postList = ApiResponse.loading();

  setPostList(ApiResponse<GetPostModel> response) {
    postList = response;
    notifyListeners();
  }

  Future<void>getPostApi(context,id) async {
    setPostList(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();
    Map data={
      "user_id": id.toString(),
    };
    _getPostRepo.getPostApi(data).then((value) {
      if (value.res == "success") {
        setPostList(ApiResponse.completed(value));
      } else {
        setPostList(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setPostList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
