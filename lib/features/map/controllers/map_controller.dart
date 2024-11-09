

import 'package:barikoi/api/api_checker.dart';
import 'package:barikoi/features/map/domain/model/reverse_geo_model.dart';
import 'package:barikoi/features/map/domain/model/route_model.dart';
import 'package:barikoi/features/map/domain/repository/map_repo.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapController extends GetxController{
  MapRepo mapRepo;
  MapController({required this.mapRepo});


  ReverseGeoModel? _reverseGeoModel;
  RouteModel? _routeModel;

  ReverseGeoModel? get reverseGeoModel => _reverseGeoModel;
  RouteModel? get routeModel => _routeModel;

  List<LatLng>? _polylineCoordinates;
  List<LatLng>? get polylineCoordinates => _polylineCoordinates;


  Future<void> getAddress(LatLng latLng) async {
    Response response = await mapRepo.getAddress(latitude: latLng.latitude.toString(), longitude: latLng.longitude.toString());
    if(response.statusCode == 200){
      _reverseGeoModel = ReverseGeoModel.fromJson(response.body);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getRoute({LatLng? myLatLng, LatLng? latLng}) async {
    Response response = await mapRepo.getRoute(latitude: latLng?.latitude.toString(),
        longitude: latLng?.longitude.toString(), myLatitude: myLatLng?.latitude.toString(),
        myLongitude: myLatLng?.longitude.toString());
    if(response.statusCode == 200){
      _routeModel = RouteModel.fromJson(response.body);
      if(_routeModel?.routes?[0].geometry != null){
        drawRouteOnMap(_routeModel!.routes![0].geometry!);
      }
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  void drawRouteOnMap(String? encodedPolyline) {
    // Decode the polyline string
    List<PointLatLng> points = PolylinePoints().decodePolyline(encodedPolyline!);

    // Convert the list to Maplibre's LatLng format
    _polylineCoordinates = points.map((point) {
      return LatLng(point.latitude, point.longitude);
    }).toList();
  }
}