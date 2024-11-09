

import 'package:barikoi/api/api_checker.dart';
import 'package:barikoi/features/map/domain/model/reverse_geo_model.dart';
import 'package:barikoi/features/map/domain/repository/map_repo.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapController extends GetxController{
  MapRepo mapRepo;
  MapController({required this.mapRepo});


  ReverseGeoModel? _reverseGeoModel;
  ReverseGeoModel? get reverseGeoModel => _reverseGeoModel;


  Future<void> getAddress(LatLng latLng) async {
    Response response = await mapRepo.getAddress(latitude: latLng.latitude.toString(), longitude: latLng.longitude.toString());
    if(response.statusCode == 200){
      _reverseGeoModel = ReverseGeoModel.fromJson(response.body);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }
}