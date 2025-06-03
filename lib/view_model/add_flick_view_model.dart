import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import '../repo/add_flick_repo.dart';
import 'get_post_view_model.dart';

class AddFlickViewModel with ChangeNotifier {
  final _addFlickRepo =AddFlickRepo();

  Future<void>addFlickApi(
      context,
      dynamic video,
      dynamic caption,
      dynamic storeId,
      dynamic offComment,
      dynamic hideFire,
      dynamic hideShare,
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "user_id": n.id,
      "caption": caption.toString(),
      "store_id": storeId.toString() ,
      "turn_of_comment": offComment.toString(),
      "hide_fire_count": hideFire.toString() ,
      "hide_share_count_page":hideShare.toString(),
      "video": video,
    };
    print(data);
    _addFlickRepo.addFlickApi(data).then((value) {
      if (value['res'] == "success") {
        Provider.of<GetPostViewModel>(context,listen: false).getPostApi(context,n.id);
        Navigator.pop(context);
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
