import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import './data.dart';
import 'dart:async';

class MapWidgetActivity extends StatefulWidget {
  const MapWidgetActivity({super.key});

  @override
  State<MapWidgetActivity> createState() => _MapWidgetActivityState();
}

class _MapWidgetActivityState extends State<MapWidgetActivity> {
  late List<LatLng> points;
  Timer? coordinatesTimer;

  Stream<Position?> stream = Stream.fromFuture(getPosition());

  @override
  void initState() {
    points = getPoints();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(48.204, 16.391),
            zoom: 16.75,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/holigun/clawpw8ic00dm14o6pa6ml5gk/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}",
              additionalOptions: const {
                "access_token":
                    "pk.eyJ1IjoiaG9saWd1biIsImEiOiJja3NidXZqaGowYW9wMm9tYzNpYXBrMzEwIn0.purHnG1lh0oYwtM7bpwQFQ",
              },
              userAgentPackageName: 'com.example.app',
            ),
            // Code for Location Marker
            CurrentLocationLayer(
              style: LocationMarkerStyle(
                marker: const DefaultLocationMarker(
                  color: tertiary,
                  child: Icon(
                    Icons.person,
                    size: 15,
                    color: primary,
                  ),
                ),
                markerSize: const Size(25, 25),
                showAccuracyCircle: false,
                headingSectorColor: tertiary.withOpacity(0.8),
                headingSectorRadius: 60,
              ),
              moveAnimationDuration: Duration.zero, // disable animation
              centerOnLocationUpdate: CenterOnLocationUpdate.always,
            ),
            StreamBuilder<Position?>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  coordinatesTimer =
                      Timer.periodic(Duration(seconds: 10), (Timer t) {
                    getPosition();
                  });
                  return PolylineLayer(
                    //polylineCulling: false,
                    polylines: [
                      Polyline(
                        points: points,
                        strokeWidth: 2.0,
                        color: Colors.blue,
                      ),
                    ],
                  );
                }
                return Text('');
              },
            )
          ],
        ),
      ),
    );
  }
}
