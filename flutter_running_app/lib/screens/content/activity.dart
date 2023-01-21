import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_running_app/screens/content/end_activity.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:flutter_running_app/shared/map_widget.dart';
import 'package:flutter_running_app/shared/map_widget_activity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_running_app/shared/data.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_running_app/screens/content/end_activity.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  Duration duration = Duration();
  Duration pace = Duration();
  Timer? timer;
  Timer? coordinatesTimer;
  late double distance;

  bool buttonEnabled = false;
  bool isPaused = false;

  Stream<Position?> distanceStream = Stream.fromFuture(getPosition());

  @override
  void initState() {
    super.initState();
    startTimer();
    distance = calculateDistance();

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
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      addTime();
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  void calculatePace() {
    setState(() {
      double durationInSeconds = duration.inSeconds.toDouble();
      if (distance != 0) {
        double paceInSeconds = durationInSeconds / distance;
        pace = Duration(seconds: paceInSeconds.toInt());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final paceMinutes = twoDigits(pace.inMinutes.remainder(60));
    final paceSeconds = twoDigits(pace.inSeconds.remainder(60));

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
                      children: <Widget>[
                        Text(
                          'Distance (km)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        StreamBuilder<Position?>(
                            stream: distanceStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                coordinatesTimer = Timer.periodic(
                                    Duration(seconds: 10), (Timer t) {
                                  distance = double.parse((totalDistance / 1000)
                                      .toStringAsFixed(3));
                                    calculatePace();
                                });
                                return Text(
                                  '$distance',
                                  style: TextStyle(
                                    //fontWeight: FontWeight.normal,
                                    fontSize: 30,
                                  ),
                                );
                              }
                              return Text(
                                '0.0',
                                style: TextStyle(fontSize: 30),
                              );
                            }),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Pace (min/km)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$paceMinutes:$paceSeconds',
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
              // Padding(
              //   padding: EdgeInsets.only(bottom: 10, top: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       Column(
              //         children: const <Widget>[
              //           Text(
              //             'Placeholder',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Text(
              //             '-',
              //             style: TextStyle(
              //               //fontWeight: FontWeight.normal,
              //               fontSize: 30,
              //             ),
              //           ),
              //         ],
              //       ),
              //       Column(
              //         children: const <Widget>[
              //           Text(
              //             'Placeholder',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Text(
              //             '-',
              //             style: TextStyle(
              //               //fontWeight: FontWeight.normal,
              //               fontSize: 30,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
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
                          icon: isPaused
                              ? const Icon(Icons.play_arrow_sharp)
                              : const Icon(Icons.pause_sharp),
                          onPressed: buttonEnabled
                              ? () {
                                  setState(() {
                                    if (isPaused) {
                                      startTimer(resets: false);
                                      resumeStream();
                                      isPaused = false;
                                    } else {
                                      stopTimer(resets: false);
                                      pauseStream();
                                      isPaused = true;
                                    }
                                  });
                                }
                              : null,
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
                          onPressed: buttonEnabled
                              ? () {
                                  setState(() {
                                    stopTimer(resets: false);
                                    pauseStream();
                                    isPaused = true;
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Ending Activity'),
                                        content: const Text(
                                            'Are you sure you want to end the current activity? You are not able to resume this activity once it has been completed'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Navigator.pop(context, 'OK'),
                                              setFinish();
                                              saveData();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const EndActivity()));
                                            },
                                            child: const Text('Finish'),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                }
                              : null,
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
            //const MapWidget(),
            const MapWidgetActivity(),
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
