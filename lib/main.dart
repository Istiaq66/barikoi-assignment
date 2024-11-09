import 'package:barikoi/helper/location_helper.dart';
import 'package:barikoi/utils/appconstants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BariKoi Map',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const SimpleMap(),
    );
  }
}



class SimpleMap extends StatefulWidget{
  const SimpleMap({super.key});

  @override
  State<SimpleMap> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap>{
  final LocationHelper _locationService = LocationHelper();
  CameraPosition? initialPosition;   //CameraPosition object for initial location in map
  MaplibreMapController? mController;
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
      MaplibreMap(
        styleString: AppConstants.mapUrl , // barikoi map style url
        initialCameraPosition: initialPosition!,   // set map initial location where map will show first
        onMapCreated: (MaplibreMapController mapController){  //called when map object is created
          mController= mapController; // use the MaplibreMapController for map operations

          mController?.onSymbolTapped.add(_OnSymboltapped);   // add symbol tap event listener to mapcontroller

        },
        onStyleLoadedCallback: (){
        // Create SymbolOption for creating a symbol in map
        SymbolOptions symbolOptions = SymbolOptions(
          geometry: initialLatLng!, // location of the symbol, required
          iconImage: 'custom-marker',   // icon image of the symbol
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
        addImageFromAsset("custom-marker", "assets/image/my_marker.png").then((value) { mController?.addSymbol(symbolOptions);});
      },
        onMapClick: (point, latLng) {
          // Handle the map click event here
          print('Map clicked at: ${latLng.latitude}, ${latLng.longitude}');
          // Example: Show a marker at the clicked location
          SymbolOptions clickedSymbolOptions = SymbolOptions(
            geometry: latLng, // Use clicked location for the symbol
            iconImage: 'custom-marker',   // icon image of the symbol
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
          addImageFromAsset("custom-marker", "assets/image/marker.png").then((value) { mController?.addSymbol(clickedSymbolOptions);});

          setState(() {
          });

        },
      ),
    );
  }






  _OnSymboltapped(Symbol symbol){
    //update symbol text when tapped
    mController?.updateSymbol(symbol, SymbolOptions(textField: "clicked"));
    setState(() {

    });
  }

  // Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mController!.addImage(name, list);
  }

}


