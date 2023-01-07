import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

List<LatLng> polyLinePoints = [];
double totalDistance = 0;
  Position? currentPosition;
  LatLng? previousPosition;

List<LatLng> getPoints() {
  // print('Result: ${result}');
  return polyLinePoints;
}

//Todo: Location Updates wenn das Handy gesperrt ist (evtl. flutter_background_geolocation)
Future<Position?> getPosition() async {
  // Position? currentPosition;
  // LatLng? previousPosition;

  currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  LatLng coordinates = LatLng(currentPosition!.latitude, currentPosition!.longitude);
  getPoints().add(coordinates);


  if (getPoints().length > 1) {
    previousPosition = getPoints().elementAt(getPoints().length - 2);

    double distanceBetweenLastTwo = Geolocator.distanceBetween(previousPosition!.latitude, previousPosition!.longitude, currentPosition!.latitude, currentPosition!.longitude);
    totalDistance += distanceBetweenLastTwo;
    print('distance between last two: ${distanceBetweenLastTwo}');
    print('total distance: ${totalDistance}');
  }

  print('getPoints: ${getPoints()}');
  return currentPosition;
}


// List<dynamic> route = [
//   {'lat': 48.7628, 'lng': 15.75958},
//   {'lat': 48.76366, 'lng': 15.75749},
//   {'lat': 48.76424, 'lng': 15.75567},
//   {'lat': 48.76485, 'lng': 15.75451},
//   {'lat': 48.76581, 'lng': 15.75376},
// ];

