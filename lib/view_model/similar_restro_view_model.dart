import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/different_location_model.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/repo/different_location_repo.dart';
import 'package:grabto/repo/similar_restr_repo.dart';
import 'package:grabto/ui/different_location_screen.dart';
import 'package:grabto/utils/snackbar_helper.dart';

import '../helper/response/api_response.dart';
import '../helper/shared_pref.dart';
import '../model/near_by_location_model.dart';
import '../model/similar_restaurant_model.dart';
import '../model/user_model.dart';
import '../repo/filter_repo.dart';

class SimilarRestroViewModel with ChangeNotifier {
  final _similarRepo =SimilarRestrRepo();

  ApiResponse<SimilarRestaurantModel> similarList = ApiResponse.loading();

  setSimilarRestroList(ApiResponse<SimilarRestaurantModel> response) {
    similarList = response;
    notifyListeners();
  }

  Future<void>similarRestroApi(context, dynamic cat_Id) async {
    print("🐬🐬🐬🐬:$cat_Id");
    setSimilarRestroList(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();
    print("🐬🐬🐬🐬:${n.id.toString()}");
Map data={
  "category_id":cat_Id,
  "user_id":n.id.toString()
};
    _similarRepo.similarRestroApi(data).then((value) {
      if (value.res == "success") {

        setSimilarRestroList(ApiResponse.completed(value));

      }
      else {
        if (kDebugMode) {
          setSimilarRestroList(ApiResponse.completed(value));
          print(value);
          print('value:');
          showErrorMessage(context, message:value.msg?.toString()??"");
        }
      }
    }).onError((error, stackTrace) {
      setSimilarRestroList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('similarrestaurant: $error');
      }
    });
  }


}
