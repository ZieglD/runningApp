import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
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
            // CurrentLocationLayer(
            //   style: LocationMarkerStyle(
            //     marker: const DefaultLocationMarker(
            //       color: tertiary,
            //       child: Icon(
            //         Icons.person,
            //         size: 15,
            //         color: primary,
            //       ),
            //     ),
            //     markerSize: const Size(25, 25),
            //     showAccuracyCircle: false,
            //     headingSectorColor: tertiary.withOpacity(0.8),
            //     headingSectorRadius: 60,
            //   ),
            //   moveAnimationDuration: Duration.zero, // disable animation
            //   centerOnLocationUpdate: CenterOnLocationUpdate.always,
            // ),
            PolylineLayer(
              polylineCulling: false,
              polylines: [
                Polyline(
                  points: [
                    LatLng(48.200, 16.390),
                    LatLng(48.201, 16.391),
                    LatLng(48.203, 16.393),
                    LatLng(48.205, 16.397),
                  ],
                  color: Colors.blue,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
