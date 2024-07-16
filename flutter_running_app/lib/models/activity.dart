import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Activity {
  final String id;
  final double distance; // in meters
  final List<LatLng> coordinates;
  final int duration; // in seconds
  final double pace; // in seconds per kilometer
  final DateTime date;

  Activity({
    required this.id,
    required this.distance,
    required this.coordinates,
    required this.duration,
    required this.pace,
    required this.date,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Parse the list of coordinates
    // var rawCoordinatesList =
    //     data['activityCoords'] as List<dynamic>?; // nullable
    // var coordinatesList = rawCoordinatesList
    //         ?.map((item) => LatLng(
    //               item['latitude'].toDouble(),
    //               item['longitude'].toDouble(),
    //             ))
    //         .toList() ??
    //     []; // if null, default to an empty list

    // List<LatLng> coordinatesList = [];
    // if (data['activityCoordinates'] != null) {
    //   coordinatesList = List.from(data['activityCoordinates']).map((item) {
    //     // Log each coordinate item
    //     print('Coordinate item: $item');
    //     return LatLng(
    //       item['latitude'].toDouble(),
    //       item['longitude'].toDouble(),
    //     );
    //   }).toList();
    // }

    List<LatLng> coordinatesList = [];
    if (data['activityCoordinates'] != null) {
      coordinatesList = (data['activityCoordinates'] as List).map((coordMap) {
        var coordList = coordMap['coordinates'];
        if (coordList != null && coordList.length == 2) {
          // Assuming the first element is latitude and the second is longitude
          double longitude = (coordList[0] as num).toDouble();
          double latitude = (coordList[1] as num).toDouble();
          return LatLng(latitude, longitude);
        } else {
          // Handle the case where coordinates are not available
          throw Exception('Invalid coordinates format');
        }
      }).toList();
    }

    print('Parsed coordinates list: $coordinatesList');

    return Activity(
      id: doc.id,
      distance: data['activityDistance'].toDouble(),
      duration: data['activityDuration'],
      pace: data['activityPace'].toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      coordinates: coordinatesList, // If null, default to an empty list
    );
  }

  Polyline getPolyline() {
    var points = coordinates
        .map((coord) => LatLng(coord.latitude, coord.longitude))
        .toList();
    return Polyline(
      points: points,
      strokeWidth: 4.0,
      color: Colors.blue,
    );
  }
}
