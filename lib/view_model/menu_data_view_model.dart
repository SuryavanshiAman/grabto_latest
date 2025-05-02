import 'package:flutter/foundation.dart';
import 'package:grabto/model/menu_data_model.dart';
import 'package:grabto/repo/menu_data_repo.dart';
import '../helper/response/api_response.dart';

class MenuDataViewModel with ChangeNotifier {
  final _menuDataRepo =MenuDataRepo();

  ApiResponse<MenuDataModel> menuDataList = ApiResponse.loading();

  setMenuDataList(ApiResponse<MenuDataModel> response) {
    menuDataList = response;
    notifyListeners();
  }

  Future<void>menuDataApi(context, dynamic storeId
      ) async {
    setMenuDataList(ApiResponse.loading());
    Map data={
      "store_id":storeId
    };
    print(data);
    print("potaaaaa");
    _menuDataRepo.menuDataApi(data).then((value) {
      if (value.res == "success") {
        setMenuDataList(ApiResponse.completed(value));

      } else {
        setMenuDataList(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setMenuDataList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
