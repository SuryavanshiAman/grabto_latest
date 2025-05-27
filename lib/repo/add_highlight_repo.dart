

import 'package:flutter/foundation.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';
import '../services/api.dart';

class AddHighlightRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> addHighlightApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/user-highlight-add',data );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during addHighlightApi: $e');
      }
      rethrow;
    }
  }}