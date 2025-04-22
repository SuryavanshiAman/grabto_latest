import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/vibe_model.dart';
import 'package:grabto/repo/similar_restr_repo.dart';
import 'package:grabto/repo/vibe_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';

import '../helper/response/api_response.dart';
import '../helper/shared_pref.dart';
import '../model/similar_restaurant_model.dart';
import '../model/user_model.dart';

class VibeViewModel with ChangeNotifier {
  final _vibeRepo =VibeRepo();

  ApiResponse<VibeModel> vibeList = ApiResponse.loading();

  setVibeListList(ApiResponse<VibeModel> response) {
    vibeList = response;
    notifyListeners();
  }

  Future<void>vibeApi(context, dynamic storeId) async {
    setVibeListList(ApiResponse.loading());
    Map data={
      "store_id":storeId

    };
    _vibeRepo.vibeApi(data).then((value) {
      if (value.res == "success") {
        setVibeListList(ApiResponse.completed(value));

      } else {
        if (kDebugMode) {
          setVibeListList(ApiResponse.completed(value));
          print(value);
          print('value:');
          // showErrorMessage(context, message:value.msg?.toString()??"");
        }
      }
    }).onError((error, stackTrace) {
      setVibeListList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('vibeApi: $error');
      }
    });
  }


}
