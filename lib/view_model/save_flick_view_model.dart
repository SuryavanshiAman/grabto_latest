import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/repo/save_flick_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import 'get_post_view_model.dart';

class SaveFlickViewModel with ChangeNotifier {
  final _saveFlickRepo =SaveFlickRepo();

  Future<void>saveFlickApi(
      context,
      dynamic reelId,
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "userId": n.id.toString(),
      "reelId": reelId.toString(),
    };
    print(data);
    _saveFlickRepo.saveFlickApi(data).then((value) {
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
