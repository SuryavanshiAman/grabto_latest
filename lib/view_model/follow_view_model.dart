import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/repo/follow_repo.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import 'flicks_view_model.dart';

class FollowViewModel with ChangeNotifier {
  final _followRepo =FollowRepo();

  Future<void>followApi(
      context,
      dynamic followingId
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "followerId":n.id,
      "followingId":followingId
    };
    print(data);
    _followRepo.followApi(data).then((value) {
      if (value['res'] == "success") {
        Provider.of<FlicksViewModel>(context, listen: false).flicksApi(context);
        // Provider.of<GetPostViewModel>(context,listen: false).getPostApi(context);
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
