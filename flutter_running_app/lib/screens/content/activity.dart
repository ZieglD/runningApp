import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:flutter_running_app/shared/map_widget.dart';
import 'package:latlong2/latlong.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  Duration duration = Duration();
  Timer? timer;

  bool buttonEnabled = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void reset() {
    setState(() => duration = Duration());
  }

  void addTime() {
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    // Map, currently not used in this widget --> map_widget.dart
    // Widget mapPreview = SizedBox(
    //     //alignment: Alignment.topCenter,
    //     height: MediaQuery.of(context).size.height,
    //     child: FlutterMap(
    //       options: MapOptions(
    //         center: LatLng(48.202, 16.392),
    //         zoom: 16.75,
    //       ),
    //       //nonRotatedChildren: [
    //       // This does NOT fulfill Mapbox's requirements for attribution
    //       // See https://docs.mapbox.com/help/getting-started/attribution/
    //       // AttributionWidget.defaultWidget(
    //       //   source: '',
    //       //   onSourceTapped: null,
    //       //async {
    //       //   // Requires 'url_launcher'
    //       //   if (!await launchUrl(Uri.parse(
    //       //       "https://docs.mapbox.com/help/getting-started/attribution/"))) {
    //       //     // if (kDebugMode) print('Could not launch URL');
    //       //   }
    //       // },
    //       // )
    //       // ],
    //       children: [
    //         TileLayer(
    //           urlTemplate:
    //               "https://api.mapbox.com/styles/v1/holigun/clawpw8ic00dm14o6pa6ml5gk/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}",
    //           //"https://api.mapbox.com/styles/v1/holigun/clav1jj84007a15o290hw2kbw/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}",
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

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

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
                    children: <Widget>[
                      const Padding(
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
                        '$hours:$minutes:$seconds',
                        // '00:00:00',
                        style: const TextStyle(
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
              Padding(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const <Widget>[
                        Text(
                          'Placeholder',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '-',
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
                          'Placeholder',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '-',
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

    Widget finishAndPauseButtonSection = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
            //elevation: 1,
            color: Colors.transparent,
            //color: primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Ink(
                        decoration: const ShapeDecoration(
                            color: Colors.transparent, shape: CircleBorder()),
                        child: IconButton(
                          iconSize: 40,
                          icon: isPaused ? const Icon(Icons.play_arrow_sharp) : const Icon(Icons.pause_sharp),
                          onPressed: buttonEnabled ? () {                            
                            setState(() {
                              if (isPaused) {
                                startTimer(resets: false);
                                isPaused = false;
                              } else {
                                stopTimer(resets: false);
                                isPaused = true;
                              }
                            });} : null,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Ink(
                        padding: const EdgeInsets.all(0),
                        decoration: const ShapeDecoration(
                            color: success, shape: CircleBorder()),
                        child: IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.lock_sharp),
                          onPressed: () {
                            setState(() {
                              //setState to refresh UI
                              if (buttonEnabled) {
                                buttonEnabled = false;
                                //if buttonenabled == true, then make buttonenabled = false
                              } else {
                                buttonEnabled = true;
                                //if buttonenabled == false, then make buttonenabled = true
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Ink(
                        decoration: const ShapeDecoration(
                            color: Colors.transparent, shape: CircleBorder()),
                        child: IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.check_sharp),
                          onPressed: buttonEnabled ? () {} : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );

    // Widget startButtonSection = IconButton(
    //   iconSize: 150,
    //   icon: const Icon(Icons.play_circle_outline_rounded),
    //   onPressed: () {},
    // );

    Widget startButtonSection = Container(
        //padding: const EdgeInsets.only(bottom: 8),
        child: IconButton(
      iconSize: 150,
      icon: const Icon(Icons.play_circle_outline_sharp),
      onPressed: () {},
    ));

    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
        body:
            // durationSection,
            //distanceAndPaceSection,
            //finishAndPauseButtonSection,
            Stack(
          children: [
            const MapWidget(),
            // mapPreview,
            durationSection,
            finishAndPauseButtonSection,
          ],
        ),
        // mapPreview,
        //finishAndPauseButtonSection,
        //startButtonSection,
        //const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),

        //const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),
        //     ElevatedButton(
        //   onPressed: () => setState(() => _showAppBar = !_showAppBar),
        //   child: const Text('Hide Appbar'),
        // ),
      ),
    );
  }
}
