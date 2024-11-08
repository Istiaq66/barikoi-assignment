import 'package:barikoi/utils/appconstants.dart';
import 'package:flutter/material.dart';
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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SimpleMap(),
    );
  }
}



class SimpleMap extends StatefulWidget{
  const SimpleMap({super.key});

  @override
  State<SimpleMap> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap>{
  CameraPosition initialPosition= const CameraPosition(target: LatLng(23.835677, 90.380325), zoom: 12);   //CameraPosition object for initial location in map
  MaplibreMapController? mController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaplibreMap(
        initialCameraPosition: initialPosition,   // set map initial location where map will show first
        onMapCreated: (MaplibreMapController mapController){  //called when map object is created
          mController= mapController;   // use the MaplibreMapController for map operations
        },
        styleString: AppConstants.mapUrl , // barikoi map style url
      ),
    );
  }
}
