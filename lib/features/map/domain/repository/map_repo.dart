

import 'package:barikoi/api/api_client.dart';
import 'package:barikoi/utils/appconstants.dart';
import 'package:get/get.dart';

class MapRepo extends GetxService{
  ApiClient apiClient;

  MapRepo({required this.apiClient});

  Future<Response> getAddress({required String? latitude,required String? longitude}) async {
    Response response = await apiClient.getData('${AppConstants.reverseGeoCodeApi}?api_key=${AppConstants.apiKey}&longitude=$longitude&latitude=$latitude');
    return response;
  }

  Future<Response> getRoute({required String? myLatitude,required String? myLongitude, required String? latitude,required String? longitude}) async {
    Response response = await apiClient.getData('${AppConstants.routeApi}$myLongitude,$myLatitude;$longitude,$latitude?api_key=${AppConstants.apiKey}&geometries=polyline');
    return response;
  }

}