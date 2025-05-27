import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import '../repo/add_review_repo.dart';
import 'get_post_view_model.dart';

class AddReviewViewModel with ChangeNotifier {
  final _addReviewRepo = AddReviewRepo();

  Future<void> addReviewApi(
    context,
    List<String> img,
    dynamic caption,
    dynamic storeId,
    dynamic offComment,
    dynamic hideFire,
    dynamic hideShare,
    dynamic rating,
  ) async {
    UserModel n = await SharedPref.getUser();
    Map data = {
      "user_id": n.id,
      "caption": caption.toString(),
      "store_id": storeId.toString(),
      "turn_of_comment": offComment.toString(),
      "hide_fire_count": hideFire.toString(),
      "hide_share_count_page": hideShare.toString(),
      "no_rating": rating,
      "image": img
    };
    print(data);
    _addReviewRepo.addReviewApi(data).then((value) {
      if (value['res'] == "success") {
        Provider.of<GetPostViewModel>(context, listen: false)
            .getPostApi(context);
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
