import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import '../repo/un_like_repo.dart';
import 'flicks_view_model.dart';

class UnLikeViewModel with ChangeNotifier {
  final _unLikeRepo =UnLikeRepo();

  Future<void>unLikeApi(
      context,
      dynamic reelId,
      int index,
      FlicksViewModel flicksViewModel,
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "userId":n.id,
      "reelId":reelId
    };
    print(data);
    _unLikeRepo.unLikeApi(data).then((value) {
      if (value['res'] == "success") {
        var currentList = flicksViewModel.flickList.data?.data?.data;
        if (currentList != null && index < currentList.length) {
          final item = currentList[index];
          item.isLiked = 0;
          item.likesCount = (item.likesCount ?? 1) - 1;
          flicksViewModel.notifyListeners(); // 🔄 Refresh UI
        }      } else {
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
