import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/repo/update_profile_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:grabto/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';

class UpdateProfileViewModel with ChangeNotifier {
  final _updateProfileRepo =UpdateProfileRepo();

  Future<void>updateProfileApi(
      context,
      dynamic dob,
      dynamic name,
      dynamic email,
      dynamic homeLocation,
      dynamic bio,
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "user_id":n.id,
      "dob":dob,
      "name":name,
      "email":email,
      "home_location":homeLocation,
      "current_location":"2",
      "bio":bio
    };
    print(data);
    _updateProfileRepo.updateProfileApi(data).then((value) {
      if (value['res'] == "success") {
        Provider.of<ProfileViewModel>(context,listen: false).profileApi(context);
        Navigator.pop(context);
      } else {
        showErrorMessage(context, message: value['msg']);
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
