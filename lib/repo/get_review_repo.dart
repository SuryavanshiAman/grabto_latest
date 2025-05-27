


import 'package:flutter/foundation.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/model/get_review_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class GetReviewRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<GetReviewModel> getReviewApi(dynamic data) async {
    try {
      print("QQQQ$data");
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/get-user-review',data );
      return GetReviewModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during GetReviewRepo: $e');
      }
      rethrow;
    }
  }

}