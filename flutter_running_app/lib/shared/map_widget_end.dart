import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:line_animator/line_animator.dart';
import './data.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_running_app/shared/data.dart';
import 'package:flutter_running_app/screens/content/activity.dart';

class MapWidgetEnd extends StatefulWidget {
  const MapWidgetEnd({super.key});

  @override
  State<MapWidgetEnd> createState() => _MapWidgetEndState();
}

class _MapWidgetEndState extends State<MapWidgetEnd> {
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
        //alignment: Alignment.topCenter,
        height:
            // (MediaQuery.of(context).size.height - appBar.preferredSize.height) /
            //     2,
            MediaQuery.of(context).size.height,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(48.204, 16.391),
            zoom: 16.75,
            // bounds funktionieren noch nicht richtig
            // bounds: LatLngBounds.fromPoints([...getPoints()]),
            // boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(30)),
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
            PolylineLayer(
              //polylineCulling: false,
              polylines: [
                Polyline(
                  points: points,
                  strokeWidth: 2.0,
                  color: Colors.blue,
                ),
              ],
            )

            // MarkerLayer(markers: [
            //   Marker(
            //     width: 180,
            //     height: 180,
            //     point: markerPoint,
            //     builder: (ctx) => Container(
            //       child: Transform.rotate(
            //           angle: markerAngle,
            //           child: Icon(Icons.airplanemode_active_sharp)),
            //     ),
            //   ),
            // ])
          ],
        ),
      ),
      // ),
    );
  }
}
