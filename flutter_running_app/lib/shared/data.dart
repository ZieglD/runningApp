import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

List<LatLng> polyLinePoints = [];
double totalDistance = 0;
Position? currentPosition;
LatLng? previousPosition;
bool shouldEmit = true;

void pauseStream() {
  shouldEmit = false;
}

void resumeStream() {
  shouldEmit = true;
}

List<LatLng> getPoints() {
  return polyLinePoints;
}

//Todo: Location Updates wenn das Handy gesperrt ist (evtl. flutter_background_geolocation)
// holt sich die Koordinaten fügt die letzte Position in die coordinates LatLng Liste hinzu
// solange shouldEmit true ist (= wenn nicht auf Pause gedrückt wird), berechnet calculateDistance 
// die Entfernung mit den jeweils letzten beiden Positionen.
// (Es wird trotzdem eine durchezogene Linie mit allen Punkten aus der Liste gezogen, egal ob pausiert oder nicht,
// der zurückgelegte Weg ist aber nur die Distanz, die während shouldEmit = true zurückgelegt wurde).
Future<Position?> getPosition() async {
  
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng coordinates =
        LatLng(currentPosition!.latitude, currentPosition!.longitude);
    getPoints().add(coordinates);
    print(getPoints());
    if (shouldEmit) {
    calculateDistance();
    print("should emit");
  }
  return currentPosition;
}

double calculateDistance() {
  if (getPoints().length > 1) {
    previousPosition = getPoints().elementAt(getPoints().length - 2);

    double distanceBetweenLastTwo = Geolocator.distanceBetween(
        previousPosition!.latitude,
        previousPosition!.longitude,
        currentPosition!.latitude,
        currentPosition!.longitude);
    totalDistance += distanceBetweenLastTwo;
    print('test distance between last two: ${distanceBetweenLastTwo}');
    print('test total distance: ${totalDistance}');
  }
  return totalDistance;
}


// List<dynamic> route = [
//   {'lat': 48.7628, 'lng': 15.75958},
//   {'lat': 48.76366, 'lng': 15.75749},
//   {'lat': 48.76424, 'lng': 15.75567},
//   {'lat': 48.76485, 'lng': 15.75451},
//   {'lat': 48.76581, 'lng': 15.75376},
// ];

