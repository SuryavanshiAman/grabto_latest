import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/menu_type_model.dart';
import '../helper/response/api_response.dart';
import '../repo/menu_type_repo.dart';
import '../ui/gallery_screen.dart';

class MenuTypeViewModel with ChangeNotifier {
  final _menuTypeRepo =MenuTypeRepo();

  ApiResponse<MenuTypeModel> menuTypeList = ApiResponse.loading();

  setMenuTypeList(ApiResponse<MenuTypeModel> response) {
    menuTypeList = response;
    notifyListeners();
  }

  Future<void>menuTypeApi(context, dynamic storeId,dynamic type
      ) async {
    setMenuTypeList(ApiResponse.loading());
    Map data={
      "store_id":storeId,
      "menu_type":type
    };
    print(data);
    print("potaaaaa");
    _menuTypeRepo.menuTypeApi(data).then((value) {
      if (value.res == "success") {
        print('Chalgya :');
        setMenuTypeList(ApiResponse.completed(value));
        navigateToGallerScreen(context,menuTypeList.data?.data);
      } else {
        setMenuTypeList(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setMenuTypeList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
  Future<void> navigateToGallerScreen(context,List<Data>?menuType,) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryScreen(menuType),
      ),
    );
  }
}
