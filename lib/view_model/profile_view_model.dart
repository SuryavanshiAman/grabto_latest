import 'package:flutter/foundation.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/model/pofile_model.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/repo/profile_repo.dart';
import 'package:provider/provider.dart';
import '../helper/response/api_response.dart';
import 'filter_view_model.dart';

class ProfileViewModel with ChangeNotifier {
  final _profileRepo =ProfileRepo();

  ApiResponse<ProfileModel> profileData = ApiResponse.loading();

  setProfileData(ApiResponse<ProfileModel> response) {
    profileData = response;
    notifyListeners();
  }

  Future<void>profileApi(context, {dynamic id}) async {
    setProfileData(ApiResponse.loading());
    UserModel n = await SharedPref.getUser();
    Map data={
      "user_id":id!=null?id.toString(): n.id,
    };
    _profileRepo.profileApi(data).then((value) {
      if (value.res == "success") {
        print("⭐⭐⭐");
        setProfileData(ApiResponse.completed(value));
        final profile = Provider.of<ProfileViewModel>(context,listen: false).profileData.data?.data;
        Future.delayed(Duration(seconds: 5),(){
          print(profile?.lat??"");
          print(profile?.long,);
          print("😊😊😊😊😊😊");
          Provider.of<FilterViewModel>(context, listen: false)
              .filterApi(context,profile?.lat??"", profile?.long, "", "", "", [], []);
        });
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
