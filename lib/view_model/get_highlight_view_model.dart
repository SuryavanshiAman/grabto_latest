import 'package:flutter/foundation.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/model/get_hightlight_model.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/model/user_model.dart';

import '../helper/response/api_response.dart';
import '../repo/get_flick_repo.dart';
import '../repo/get_highlight_repo.dart';

class GetHighlightViewModel with ChangeNotifier {
  final _getHighlightRepo =GetHighlightRepo();

  ApiResponse<GetHighlightModel> highlightList = ApiResponse.loading();

  setHighlightList(ApiResponse<GetHighlightModel> response) {
    highlightList = response;
    notifyListeners();
  }

  Future<void>getHighlightApi(context,dynamic id
      ) async {
    setHighlightList(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();
    Map data={
      "user_id": id.toString(),
    };
    _getHighlightRepo.getHighlightApi(data).then((value) {
      if (value.res == "success") {
        setHighlightList(ApiResponse.completed(value));
      } else {
        setHighlightList(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setHighlightList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
