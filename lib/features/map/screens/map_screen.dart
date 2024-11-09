import 'dart:math';
import 'package:barikoi/features/map/controllers/map_controller.dart';
import 'package:barikoi/helper/location_helper.dart';
import 'package:barikoi/utils/appconstants.dart';
import 'package:barikoi/utils/image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapScreen extends StatefulWidget{
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{
  final LocationHelper _locationService = LocationHelper();
  CameraPosition? initialPosition;
  MaplibreMapController? mController;
  Symbol? _currentSymbol;
  Symbol? _tappedSymbol;
  LatLng? initialLatLng;
  LatLng? tappedLatLng;
  Line? routeLine;

  @override
  void initState() {
    super.initState();
    _locationService.startTracking();
    startListeningToLocation();
  }


  void startListeningToLocation() {
    _locationService.positionStream.listen((Position? position) {
      if(position != null){
        initialPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 12);
        initialLatLng = LatLng(position.latitude, position.longitude);
        setState(() {});
        debugPrint("Received position: $position");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: initialPosition == null ? const Center(child: CircularProgressIndicator(),) :
        GetBuilder<MapController>(builder: (mapController) {
            return Stack(
              children: [
                MaplibreMap(
                  styleString: AppConstants.mapUrl ,
                  initialCameraPosition: initialPosition!,
                  onMapCreated: (MaplibreMapController mapController){
                    mController = mapController;
                    mController?.onSymbolTapped.add(_onSymbolTapped);
                  },
                  onStyleLoadedCallback: () async {
                    _showCurrentLocation();
                  },
                  onMapClick: (point, latLng) async {
                    tappedLatLng = latLng;
                    if(routeLine != null){
                      await mController?.removeLine(routeLine!);
                    }
                    _onMapClick(point, latLng);
                  },
                ),
                if (mapController.reverseGeoModel != null)
                  Positioned(top: 10, left: 10, right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green..withOpacity(0.5),    // Starting color of the gradient
                            Colors.blue.withOpacity(0.5),  // Ending color of the gradient
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(children: [
                          IconButton(
                              onPressed: () async {
                                await mapController.getRoute(myLatLng: initialLatLng,latLng: tappedLatLng);

                                if(routeLine != null){
                                  await mController?.removeLine(routeLine!);
                                }
                                // Add the polyline to the map
                                routeLine = await mController?.addLine(
                                  LineOptions(
                                    geometry: mapController.polylineCoordinates,
                                    lineColor: "#ff0000",
                                    lineWidth: 4.0,
                                  ),
                                );
                                },
                              icon: const Icon(Icons.directions,size: 50,color: Colors.white,)),
                          Expanded(
                            child: Text(
                              mapController.reverseGeoModel!.place!.address!,
                              style: const TextStyle(fontSize: 16,color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
        ),
      ),
    );
  }


  _onSymbolTapped(Symbol symbol){
    //update symbol text when tapped
    mController?.updateSymbol(symbol, const SymbolOptions(textField: "clicked"));
    setState(() {

    });
  }


  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mController!.addImage(name, list);
  }


  void _showCurrentLocation() async {
    // Remove the previous current location marker if it exists
    if (_currentSymbol != null) {
      await mController?.removeSymbol(_currentSymbol!);
      _currentSymbol = null;
    }

    SymbolOptions symbolOptions = SymbolOptions(
      geometry: initialLatLng!,
      iconImage: 'current-location-marker',
      iconSize: .4,
      iconAnchor: 'bottom',
      textField: 'My location',
      textSize: 12.5,
      textOffset: const Offset(0, 1.2),
      textAnchor: 'bottom',
      textColor: '#000000',
      textHaloBlur: 1,
      textHaloColor: '#ffffff',
      textHaloWidth: 0.8,
    );

    addImageFromAsset("current-location-marker", Images.currentLocationMarker).then((value) async{
      _currentSymbol = await mController?.addSymbol(symbolOptions);});
    setState(() {
    });
  }


  void _onMapClick(Point<double> point, LatLng latLng) async{
    // Remove previous tapped location marker if it exists
    if (_tappedSymbol != null) {
      await mController?.removeSymbol(_tappedSymbol!);
      _tappedSymbol = null;
    }

    debugPrint('Map clicked at: ${latLng.latitude}, ${latLng.longitude}');

    SymbolOptions clickedSymbolOptions = SymbolOptions(
      geometry: latLng,
      iconImage: 'tapped-location-marker',
      iconSize: .3,
      iconAnchor: 'bottom',
      textField: 'Tapped Location',
      textSize: 12.5,
      textOffset: const Offset(0, 1.2),
      textAnchor: 'bottom',
      textColor: '#000000',
      textHaloBlur: 1,
      textHaloColor: '#ffffff',
      textHaloWidth: 0.8,
    );
    addImageFromAsset("tapped-location-marker",Images.marker).then((value) async {
      _tappedSymbol = await mController?.addSymbol(clickedSymbolOptions);});
    Get.find<MapController>().getAddress(latLng);
  }

}