import 'dart:math';

import 'package:barikoi/helper/location_helper.dart';
import 'package:barikoi/utils/appconstants.dart';
import 'package:barikoi/utils/image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapScreen extends StatefulWidget{
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{
  final LocationHelper _locationService = LocationHelper();
  CameraPosition? initialPosition;   //CameraPosition object for initial location in map
  MaplibreMapController? mController;
  Symbol? _currentSymbol;  // To keep track of the current symbol
  Symbol? _tappedSymbol;  // To keep track of the current symbol
  LatLng? initialLatLng;

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
    return Scaffold(
      body: initialPosition == null ? const Center(child: CircularProgressIndicator(),) :
      Stack(
        children: [
          MaplibreMap(
            styleString: AppConstants.mapUrl , // barikoi map style url
            initialCameraPosition: initialPosition!,   // set map initial location where map will show first
            onMapCreated: (MaplibreMapController mapController){  //called when map object is created
              mController = mapController; // use the MaplibreMapController for map operations

              mController?.onSymbolTapped.add(_onSymbolTapped);   // add symbol tap event listener to mapcontroller

            },
            onStyleLoadedCallback: () async {

              _showCurrentLocation();
            },
            onMapClick: (point, latLng) async {

              _onMapClick(point, latLng);
            },
          ),
        ],
      ),
    );
  }


  _onSymbolTapped(Symbol symbol){
    //update symbol text when tapped
    mController?.updateSymbol(symbol, const SymbolOptions(textField: "clicked"));
    setState(() {

    });
  }

  // Adds an asset image to the currently displayed style
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
    // Create SymbolOption for creating a symbol in map
    SymbolOptions symbolOptions = SymbolOptions(
      geometry: initialLatLng!, // location of the symbol, required
      iconImage: 'current-location-marker',   // icon image of the symbol
      //optional parameter to configure the symbol
      iconSize: .4, // size of the icon in ratio of the actual size, optional
      iconAnchor: 'bottom', // anchor direction of the icon on the location specified,  optional
      textField: 'My location',  // Text to show on the symbol, optional
      textSize: 12.5,
      textOffset: const Offset(0, 1.2),   // shifting the text position relative to the symbol with x,y axis value, optional
      textAnchor: 'bottom',   // anchor direction of the text on the location specified, optional
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

    // Handle the map click event here
    debugPrint('Map clicked at: ${latLng.latitude}, ${latLng.longitude}');

    // Example: Show a marker at the clicked location
    SymbolOptions clickedSymbolOptions = SymbolOptions(
      geometry: latLng, // Use clicked location for the symbol
      iconImage: 'tapped-location-marker',   // icon image of the symbol
      //optional parameter to configure the symbol
      iconSize: .4, // size of the icon in ratio of the actual size, optional
      iconAnchor: 'bottom', // anchor direction of the icon on the location specified,  optional
      textField: 'Tapped Location',  // Text to show on the symbol, optional
      textSize: 12.5,
      textOffset: const Offset(0, 1.2),   // shifting the text position relative to the symbol with x,y axis value, optional
      textAnchor: 'bottom',   // anchor direction of the text on the location specified, optional
      textColor: '#000000',
      textHaloBlur: 1,
      textHaloColor: '#ffffff',
      textHaloWidth: 0.8,
    );
    addImageFromAsset("tapped-location-marker",Images.marker).then((value) async {
      _tappedSymbol = await mController?.addSymbol(clickedSymbolOptions);});
    setState(() {
    });
  }

}