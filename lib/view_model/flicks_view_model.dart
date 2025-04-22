import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/flickes_model.dart';
import 'package:grabto/model/vibe_model.dart';
import 'package:grabto/repo/flicks_repo.dart';
import 'package:grabto/repo/vibe_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';

import '../helper/response/api_response.dart';

class FlicksViewModel with ChangeNotifier {
  final _flickRepo =FlicksRepo();

  ApiResponse<FlicksModel> flickList = ApiResponse.loading();

  setFlicksList(ApiResponse<FlicksModel> response) {
    flickList = response;
    notifyListeners();
  }

  Future<void>flicksApi(context, dynamic storeId) async {
    setFlicksList(ApiResponse.loading());
    Map data={
      "store_id":storeId

    };
    _flickRepo.flicksApi(data).then((value) {
      if (value.res == "success") {
        setFlicksList(ApiResponse.completed(value));
        print("🐬🐬🐬🐬");
        // showErrorMessage(context, message:",mmmmmmm".toString()??"");


      } else {
        if (kDebugMode) {
          setFlicksList(ApiResponse.completed(value));
          print(value);
          print('value:');
          // showErrorMessage(context, message:"value.msg?".toString()??"");
        }
      }
    }).onError((error, stackTrace) {
      setFlicksList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('flicksApi: $error');
      }
    });
  }


}
