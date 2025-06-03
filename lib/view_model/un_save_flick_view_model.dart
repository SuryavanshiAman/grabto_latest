
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/repo/save_flick_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import '../repo/unsave_flick_repo.dart';
import 'flicks_view_model.dart';
import 'get_post_view_model.dart';

class UnSaveFlickViewModel with ChangeNotifier {
  final _unSaveFlickRepo =UnSaveFlickRepo();

  Future<void>unSaveFlickApi(
      context,
      dynamic reelId,
      int index,
      FlicksViewModel flicksViewModel,
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "userId": n.id.toString(),
      "reelId": reelId.toString(),
    };
    print(data);
    _unSaveFlickRepo.unSaveFlickApi(data).then((value) {
      if (value['res'] == "success") {
        var currentList =  flicksViewModel.flickList.data?.data?.data;
        if (currentList != null && index < currentList.length) {
          final item = currentList[index];
          item.isFavorited = 0;
          item.favoritesCount = (item.favoritesCount ?? 1) - 1;
          flicksViewModel.notifyListeners(); // 🔄 Refresh UI
        }        } else {
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
