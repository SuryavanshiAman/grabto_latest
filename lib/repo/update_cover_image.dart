



import 'package:flutter/foundation.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';
import '../services/api.dart';

class UpdateCoverImage {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> updateCoverApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/update_covor_image',data );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during updateCoverApi: $e');
      }
      rethrow;
    }
  }}