import 'package:flutter/foundation.dart';
import 'package:grabto/model/get_all_user_highlight_model.dart';
import 'package:grabto/repo/get_all_user_highlight_repo.dart';

import '../helper/response/api_response.dart';

class GetAllUserHighlightViewModel with ChangeNotifier {
  final _getAllHighlightRepo =GetAllUserHighlightRepo();

  ApiResponse<GetAllUserHighlightModel> allHighlightList = ApiResponse.loading();

  setAllHighlightList(ApiResponse<GetAllUserHighlightModel> response) {
    allHighlightList = response;
    notifyListeners();
  }

  Future<void>getHighlightApi(context) async {
    setAllHighlightList(ApiResponse.loading());
    _getAllHighlightRepo.getAllUserHighlightApi().then((value) {
      if (value.res == "success") {
        setAllHighlightList(ApiResponse.completed(value));
      } else {
        setAllHighlightList(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setAllHighlightList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
