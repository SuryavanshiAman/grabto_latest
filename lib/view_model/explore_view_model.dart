import 'package:flutter/foundation.dart';
import 'package:grabto/model/explore_model.dart';
import 'package:grabto/model/get_flick_model.dart';
import 'package:grabto/repo/explore_repo.dart';

import '../helper/response/api_response.dart';

class ExploreViewModel with ChangeNotifier {
  final _getFlickRepo =ExploreRepo();

  ApiResponse<ExploreModel> exploreList = ApiResponse.loading();

  setExploreList(ApiResponse<ExploreModel> response) {
    exploreList = response;
    notifyListeners();
  }

  Future<void>exploreApi(context) async {
    setExploreList(ApiResponse.loading());

    _getFlickRepo.exploreApi().then((value) {
      if (value.res == "success") {
        setExploreList(ApiResponse.completed(value));
      } else {
        setExploreList(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setExploreList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
