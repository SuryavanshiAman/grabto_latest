



import 'package:flutter/foundation.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';
import '../services/api.dart';

class UpdateProfileRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> updateProfileApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/update_profile',data );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during updateProfileApi: $e');
      }
      rethrow;
    }
  }}