import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

List<LatLng> result = [];

List<LatLng> getPoints() {
  // print('Result: ${result}');
  return result;
}

Future<Position> getPosition() async {
  Position? position;
  position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  LatLng coordinates = LatLng(position.latitude, position.longitude);
  getPoints().add(coordinates);
  print('coordinates: ${coordinates}');
  return position;
}