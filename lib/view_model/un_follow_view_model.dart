import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/repo/un_follow_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import 'flicks_view_model.dart';

class UnFollowViewModel with ChangeNotifier {
  final _unFollowRepo =UnFollowRepo();

  Future<void>unFollowApi(
      context,
      dynamic followingId
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "followerId":n.id,
      "followingId":followingId
    };
    print(data);
    _unFollowRepo.unFollowApi(data).then((value) {
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
