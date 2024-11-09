
import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper{

  static final LocationHelper _instance = LocationHelper._internal();
  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<Position>? get positionSubscription => _positionSubscription;
  final StreamController<Position> _positionStreamController = StreamController<Position>.broadcast();

  // Getter for the stream.
  Stream<Position> get positionStream => _positionStreamController.stream;

  LocationHelper._internal();

  factory LocationHelper(){
    return _instance;
  }


  Future<void> startTracking() async {
    // Request permission to access location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("Location permission denied", name: 'LocationService');
        return;
      }
    }

    // Start tracking location updates
    getCurrentLocation();

  }

  void getCurrentLocation(){
    _positionSubscription = Geolocator.getPositionStream(locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    )).listen((Position? position){
      debugPrint("================CurrentPosition================> $position");
      _positionStreamController.add(position!);
    });
  }

  void stopTracking() {
    _positionSubscription?.cancel();
    log("Stopped tracking location", name: 'LocationService');
  }


}