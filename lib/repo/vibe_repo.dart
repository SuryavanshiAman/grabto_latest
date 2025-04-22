


import 'package:flutter/foundation.dart';
import 'package:grabto/model/vibe_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';
import '../model/similar_restaurant_model.dart';

class VibeRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<VibeModel> vibeApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/api-vibes-store',data);
      return VibeModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during vibeApi: $e');
      }
      rethrow;
    }
  }

}