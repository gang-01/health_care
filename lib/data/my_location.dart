import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyLocation {
  late double latitude;
  late double longitude;

  Future<void> getMyCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      debugPrint('internet connection Error');
    }
  }
}