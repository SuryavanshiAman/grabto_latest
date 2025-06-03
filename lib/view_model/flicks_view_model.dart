import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/flicks_model.dart';

import '../helper/response/api_response.dart';
import '../helper/shared_pref.dart';
import '../model/restaurants_flickes_model.dart';
import '../model/user_model.dart';
import '../repo/flicks_repo.dart';
import '../repo/restaurants_flicks_repo.dart';

class FlicksViewModel with ChangeNotifier {
  final _flickRepo =FlicksRepo();

  ApiResponse<FlicksModel> flickList = ApiResponse.loading();

  setFlicksList(ApiResponse<FlicksModel> response) {
    flickList = response;
    notifyListeners();
  }
  int _selectedIndex=-1;

  int get selectedIndex => _selectedIndex;

  setSelectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
  Future<void>flicksApi(context) async {
    setFlicksList(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();
    _flickRepo.flicksApi(n.id).then((value) {
      if (value.res == "success") {
        setFlicksList(ApiResponse.completed(value));

      } else {
        if (kDebugMode) {
          setFlicksList(ApiResponse.completed(value));        }
      }
    }).onError((error, stackTrace) {
      setFlicksList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('flicksApi: $error');
      }
    });
  }
}
