import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';
import '../helper/shared_pref.dart';
import '../model/user_model.dart';
import '../repo/add_highlight_repo.dart';
import 'get_post_view_model.dart';
class AddHighlightViewModel with ChangeNotifier {
  final _addHighlightRepo =AddHighlightRepo();

  Future<void>addHighlightApi(
      context,
      List<String> img,
      ) async {
    UserModel n = await SharedPref.getUser();
    Map data={
      "user_id": n.id,
      "image": img,
    };
    print(data);
    _addHighlightRepo.addHighlightApi(data).then((value) {
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
