import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_running_app/screens/content/activity.dart';
import 'package:flutter_running_app/screens/content/countdown.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/shared/constants.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_running_app/shared/map_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class StartActivity extends StatefulWidget {
  const StartActivity({super.key});

  @override
  State<StartActivity> createState() => _StartActivityState();
}

class _StartActivityState extends State<StartActivity> {
  final AuthService _auth = AuthService();
  bool _showAppBar = true;

  @override
  Widget build(BuildContext context) {
    // Position currentPosition;

    // _getCurrentLocation() {
    //   Geolocator.getCurrentPosition(
    //           desiredAccuracy: LocationAccuracy.best,
    //           forceAndroidLocationManager: true)
    //       .then((Position position) {
    //     setState(() {
    //       currentPosition = position;
    //       print(currentPosition);
    //     });
    //   }).catchError((e) {
    //     print(e);
    //   });
    // }

    Future<Position> _determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      // _getCurrentLocation();
      print('test');
      return await Geolocator.getCurrentPosition();
    }

    // Widget mapPreview = SizedBox(
    //     //alignment: Alignment.topCenter,
    //     height:
    //         // (MediaQuery.of(context).size.height - appBar.preferredSize.height) /
    //         //     2,
    //         MediaQuery.of(context).size.height,
    //     child: FlutterMap(
    //       options: MapOptions(
    //         center: LatLng(48.202, 16.392),
    //         zoom: 13.0,
    //       ),
    //       children: [
    //         TileLayer(
    //           urlTemplate:
    //               "https://api.mapbox.com/styles/v1/holigun/clawpw8ic00dm14o6pa6ml5gk/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}",
    //           additionalOptions: const {
    //             "access_token":
    //                 "pk.eyJ1IjoiaG9saWd1biIsImEiOiJja3NidXZqaGowYW9wMm9tYzNpYXBrMzEwIn0.purHnG1lh0oYwtM7bpwQFQ",
    //           },
    //           userAgentPackageName: 'com.example.app',
    //         ),
    //         CurrentLocationLayer(
    //           style: LocationMarkerStyle(
    //             marker: const DefaultLocationMarker(
    //               color: tertiary,
    //               child: Icon(
    //                 Icons.person,
    //                 size: 15,
    //                 color: primary,
    //               ),
    //             ),
    //             markerSize: const Size(25, 25),
    //             showAccuracyCircle: false,
    //             headingSectorColor: tertiary.withOpacity(0.8),
    //             headingSectorRadius: 60,
    //           ),
    //           moveAnimationDuration: Duration.zero, // disable animation
    //         ),
    //       ],
    //     ));

    Widget durationSection = Align(
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 5,
        child: ColoredBox(
          color: primary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Duration',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '00:00:00',
                        style: TextStyle(
                          //fontWeight: FontWeight.normal,
                          fontSize: 80,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const <Widget>[
                        Text(
                          'Distance (km)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '0,00',
                          style: TextStyle(
                            //fontWeight: FontWeight.normal,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: const <Widget>[
                        Text(
                          'Pace (min/km)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '00:00:00',
                          style: TextStyle(
                            //fontWeight: FontWeight.normal,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget startButton = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 70,
        padding: EdgeInsets.only(bottom: 10),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: success,
              //minimumSize: Size(200, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          onPressed: () {
            _determinePosition();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Countdown()));
          },
          icon: const Icon(
            Icons.play_arrow_sharp,
            color: secondary,
            size: 35,
          ),
          label: const Text(
            'Start Run',
            style: TextStyle(color: secondary, fontSize: 25),
          ),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: primary,
        appBar: AppBar(
          leading: const Icon(
            Icons.directions_run_rounded,
            color: success,
          ),
          title: const Text('Running App'),
          centerTitle: true,
          foregroundColor: light,
          backgroundColor: secondary,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('logout'),
              style: TextButton.styleFrom(
                foregroundColor: light,
              ),
              onPressed: () async {
                await _auth.signOutFromApp();
              },
            )
          ],
        ),
        body: Stack(
          children: [
            const MapWidget(),
            Stack(
              children: [
                durationSection,
                //mapPreview,

                //distanceAndPaceSection,
                //finishAndPauseButtonSection,
                startButton,
                //startButtonSection,
                //const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),
              ],
            ),
          ],
        )

        //const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),
        //     ElevatedButton(
        //   onPressed: () => setState(() => _showAppBar = !_showAppBar),
        //   child: const Text('Hide Appbar'),
        // ),
        );
  }
}
