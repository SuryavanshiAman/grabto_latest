

import 'package:flutter/foundation.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';
import '../services/api.dart';

class AddReviewRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> addReviewApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/user-review-add',data );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during addReviewApi: $e');
      }
      rethrow;
    }
  }}