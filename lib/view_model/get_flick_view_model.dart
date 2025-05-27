import 'package:flutter/foundation.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/model/get_flick_model.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/model/user_model.dart';

import '../helper/response/api_response.dart';
import '../repo/get_flick_repo.dart';

class GetFlickViewModel with ChangeNotifier {
  final _getFlickRepo =GetFlickRepo();

  ApiResponse<GetFlickModel> flickList = ApiResponse.loading();

  setFlickList(ApiResponse<GetFlickModel> response) {
    flickList = response;
    notifyListeners();
  }

  Future<void>getFlickApi(context,
      ) async {
    setFlickList(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();
    Map data={
      "user_id": n.id,
    };
    _getFlickRepo.getFlickApi(data).then((value) {
      if (value.res == "success") {
        setFlickList(ApiResponse.completed(value));
      } else {
        setFlickList(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setFlickList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
