import 'package:flutter/foundation.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/model/get_flick_model.dart';
import 'package:grabto/model/my_save_flick_model.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/repo/my_saved_flick_repo.dart';

import '../helper/response/api_response.dart';

class MySavedFlickViewModel with ChangeNotifier {
  final _mySavedFlickRepo =MySavedFlickRepo();

  ApiResponse<MySaveFlickModel> savedFlickList = ApiResponse.loading();

  setSavedFlickList(ApiResponse<MySaveFlickModel> response) {
    savedFlickList = response;
    notifyListeners();
  }

  Future<void>mySaveFlickApi(context,dynamic id
      ) async {
    setSavedFlickList(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();
    Map data={
      "user_id": id.toString(),
    };
    _mySavedFlickRepo.mySaveFlickApi(data).then((value) {
      if (value.res == "success") {
        setSavedFlickList(ApiResponse.completed(value));
      } else {
        setSavedFlickList(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setSavedFlickList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
