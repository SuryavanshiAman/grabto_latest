import 'package:flutter/foundation.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/model/user_model.dart';
import '../helper/response/api_response.dart';
import '../model/get_review_model.dart';
import '../repo/get_review_repo.dart';

class GetReviewViewModel with ChangeNotifier {
  final _getReviewRepo =GetReviewRepo();

  ApiResponse<GetReviewModel> reviewList = ApiResponse.loading();

  setReviewList(ApiResponse<GetReviewModel> response) {
    reviewList = response;
    notifyListeners();
  }

  Future<void>getReviewApi(context,dynamic id) async {
    setReviewList(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();
    Map data={
      "user_id":id.toString(),
    };
    print(data);
    _getReviewRepo.getReviewApi(data).then((value) {
      if (value.res == "success") {
        print("agyaaaa data");
        setReviewList(ApiResponse.completed(value));
      } else {
        setReviewList(ApiResponse.completed(value));
        print("nahi agyaaaa data");
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      print("nahi agyaaaa data");
      setReviewList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
