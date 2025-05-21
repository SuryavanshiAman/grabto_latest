import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helper/response/api_response.dart';
import '../model/restaurants_flickes_model.dart';
import '../repo/restaurants_flicks_repo.dart';

class RestaurantsFlicksViewModel with ChangeNotifier {
  final _flickRepo =RestaurantsFlicksRepo();

  ApiResponse<RestaurantsFlicksModel> flickList = ApiResponse.loading();

  setFlicksList(ApiResponse<RestaurantsFlicksModel> response) {
    flickList = response;
    notifyListeners();
  }

  Future<void>restaurantsFlicksApi(context, dynamic storeId) async {
    setFlicksList(ApiResponse.loading());
    Map data={
      "store_id":storeId
    };
    _flickRepo.restaurantsFlicksApi(data).then((value) {
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
