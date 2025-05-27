import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/repo/follow_repo.dart';
import 'package:grabto/repo/like_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import 'flicks_view_model.dart';

class LikeViewModel with ChangeNotifier {
  final _likeRepo =LikeRepo();

  Future<void>likeApi(
      context,
      dynamic reelId
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "userId":n.id,
      "reelId":reelId
    };
    print(data);
    _likeRepo.likeApi(data).then((value) {
      if (value['res'] == "success") {
        Provider.of<FlicksViewModel>(context, listen: false).flicksApi(context);
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
