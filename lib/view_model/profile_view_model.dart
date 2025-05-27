import 'package:flutter/foundation.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/model/pofile_model.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/repo/profile_repo.dart';
import '../helper/response/api_response.dart';

class ProfileViewModel with ChangeNotifier {
  final _profileRepo =ProfileRepo();

  ApiResponse<ProfileModel> profileData = ApiResponse.loading();

  setProfileData(ApiResponse<ProfileModel> response) {
    profileData = response;
    notifyListeners();
  }

  Future<void>profileApi(context,
      ) async {
    setProfileData(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();
    Map data={
      "user_id": n.id,
    };
    _profileRepo.profileApi(data).then((value) {
      if (value.res == "success") {
        setProfileData(ApiResponse.completed(value));
      } else {
        setProfileData(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setProfileData(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
