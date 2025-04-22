import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/recomended_model.dart';
import 'package:grabto/repo/recomended_repo.dart';

import '../helper/response/api_response.dart';

class RecommendedViewModel with ChangeNotifier {
  final _recomendedRepo =RecomendedRepo();

  ApiResponse<RecomendedModel> recommendedList = ApiResponse.loading();

  setRecommendedListList(ApiResponse<RecomendedModel> response) {
    recommendedList = response;
    notifyListeners();
  }

  Future<void>recomendedApi(context,) async {
    setRecommendedListList(ApiResponse.loading());

    _recomendedRepo.recomendedApi().then((value) {
      if (value.res == "success") {
        setRecommendedListList(ApiResponse.completed(value));

      } else {
        if (kDebugMode) {
          setRecommendedListList(ApiResponse.completed(value));
          print(value);
          print('value:');
          // showErrorMessage(context, message:value.msg?.toString()??"");
        }
      }
    }).onError((error, stackTrace) {
      setRecommendedListList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('similarrestaurant: $error');
      }
    });
  }


}
