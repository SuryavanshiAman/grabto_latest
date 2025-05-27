import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:grabto/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import '../repo/update_cover_image.dart';

class UpdateCoverImageViewModel with ChangeNotifier {
  final _updateCoverRepo =UpdateCoverImage();

  Future<void>updateCoverApi(
      context,
      dynamic coverImage
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
    "user_id":n.id,
    "image":coverImage
    };
    print(data);
    _updateCoverRepo.updateCoverApi(data).then((value) {
      if (value['res'] == "success") {
        Provider.of<ProfileViewModel>(context,listen: false).profileApi(context);
        // Navigator.pop(context);
      } else {
        showErrorMessage(context, message: value['message']);
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
