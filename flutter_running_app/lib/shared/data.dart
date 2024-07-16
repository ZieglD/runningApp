import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

List<LatLng> polyLinePoints = [];
List<LatLng> savedCoordinates = [];
double totalDistance = 0;
double savedDistance = 0;
Position? currentPosition;
LatLng? previousPosition;
bool shouldEmit = true;
bool isFinished = true;

void pauseStream() {
  shouldEmit = false;
}

void resumeStream() {
  shouldEmit = true;
}

setFinish() {
  isFinished = false;
  // print(isFinished);
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
  if (isFinished) {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng coordinates =
        LatLng(currentPosition!.latitude, currentPosition!.longitude);
    getPoints().add(coordinates);
    if (shouldEmit) {
      calculateDistance();
    }
  }
  return currentPosition;
}

// calculates distance between last two gps location coordinates and adds it to the total distance
// of the activity
double calculateDistance() {
  if (getPoints().length > 1) {
    previousPosition = getPoints().elementAt(getPoints().length - 2);
    double distanceBetweenLastTwo = Geolocator.distanceBetween(
        previousPosition!.latitude,
        previousPosition!.longitude,
        currentPosition!.latitude,
        currentPosition!.longitude);
    totalDistance += distanceBetweenLastTwo;
  }
  return totalDistance;
}

saveData() {
  // save Duration, Distance, Coords
  // savedDuration = '10:28';
  savedDistance = totalDistance;
  // savedDistance = 3.0;
  savedCoordinates = getPoints();
  // print('saved distance: ${savedDistance}');
  //print('saved coords: ${savedCoords}');
}
