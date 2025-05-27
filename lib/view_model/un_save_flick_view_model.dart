
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/repo/save_flick_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import '../repo/unsave_flick_repo.dart';
import 'get_post_view_model.dart';

class UnSaveFlickViewModel with ChangeNotifier {
  final _unSaveFlickRepo =UnSaveFlickRepo();

  Future<void>unSaveFlickApi(
      context,
      dynamic reelId,
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "userId": n.id.toString(),
      "reelId": reelId.toString(),
    };
    print(data);
    _unSaveFlickRepo.unSaveFlickApi(data).then((value) {
      if (value['res'] == "success") {
        Provider.of<GetPostViewModel>(context,listen: false).getPostApi(context);
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
