import 'package:flutter/foundation.dart';
import 'package:grabto/model/filtered_data_model.dart';

import '../helper/response/api_response.dart';
import '../repo/filter_repo.dart';

class FilterViewModel with ChangeNotifier {
  final _filterRepo =FilterRepo();

  ApiResponse<FilteredDataModel> filterList = ApiResponse.loading();

  setFilterList(ApiResponse<FilteredDataModel> response) {
    filterList = response;
    notifyListeners();
  }
  int _filterIndex = 0;

  int get filterIndex => _filterIndex;

  setFilterIndex(int value) {
    _filterIndex = value;
    notifyListeners();
  }
  Future<void>filterApi(context, dynamic lat,
      dynamic long,
      dynamic rating,
      dynamic discount,
      dynamic distance,
      List<String> amenities,
      List<String> restaurantCategories,
      ) async {
    print("$long,$lat");
    setFilterList(ApiResponse.loading());
    Map data={
      "latitude": lat,
      "longitude": long,
      "rating": rating ?? "",
      "discount": discount ?? "",
      "distance": distance ?? "",
      "amenities": amenities ,
      "subcategory_id":restaurantCategories,
    };
    print("filter-Stores=${data}");
    _filterRepo.filterApi(data).then((value) {
      if (value.res == "success") {
        setFilterList(ApiResponse.completed(value));
      } else {
        setFilterList(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setFilterList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
