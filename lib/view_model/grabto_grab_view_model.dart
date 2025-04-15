import 'package:flutter/foundation.dart';
import 'package:grabto/model/grabto_grab_model.dart';
import 'package:grabto/repo/grabto_grab_repo.dart';
import '../helper/response/api_response.dart';

class GrabtoGrabViewModel with ChangeNotifier {
  final _grabRepo =GrabtoGrabRepo();

  ApiResponse<GrabtoGrabModel> grabList = ApiResponse.loading();

  setGrabList(ApiResponse<GrabtoGrabModel> response) {
    grabList = response;
    notifyListeners();
  }

  Future<void>grabtoGrabApi(context) async {
    setGrabList(ApiResponse.loading());

    _grabRepo.grabtoGrabApi().then((value) {
      if (value.res == "success") {
        setGrabList(ApiResponse.completed(value));
print(value);
print("value");
      } else {
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setGrabList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
