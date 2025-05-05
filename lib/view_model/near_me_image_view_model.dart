import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/near_me_image_model.dart';
import 'package:grabto/model/vibe_model.dart';
import 'package:grabto/repo/near_me_image_repo.dart';
import 'package:grabto/repo/similar_restr_repo.dart';
import 'package:grabto/repo/vibe_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';

import '../helper/response/api_response.dart';
import '../helper/shared_pref.dart';
import '../model/similar_restaurant_model.dart';
import '../model/user_model.dart';

class NearMeImageViewModel with ChangeNotifier {
  final _imageRepo =NearMeImageRepo();

  ApiResponse<NearMeImageModel> imageList = ApiResponse.loading();

  setImageList(ApiResponse<NearMeImageModel> response) {
    imageList = response;
    notifyListeners();
  }

  Future<void>nearMeImageApi(context,) async {
    setImageList(ApiResponse.loading());

    _imageRepo.nearMeImageApi().then((value) {
      if (value.res == "success") {
        setImageList(ApiResponse.completed(value));

      } else {
        if (kDebugMode) {
          setImageList(ApiResponse.completed(value));
          print(value);
          print('value:');
          // showErrorMessage(context, message:value.msg?.toString()??"");
        }
      }
    }).onError((error, stackTrace) {
      setImageList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('image: $error');
      }
    });
  }


}
