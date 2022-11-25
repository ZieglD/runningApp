import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:latlong2/latlong.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    Widget mapPreview = SizedBox(
        //alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(48.202, 16.392),
            zoom: 13.0,
          ),
          //nonRotatedChildren: [
          // This does NOT fulfill Mapbox's requirements for attribution
          // See https://docs.mapbox.com/help/getting-started/attribution/
          // AttributionWidget.defaultWidget(
          //   source: '',
          //   onSourceTapped: null,
          //async {
          //   // Requires 'url_launcher'
          //   if (!await launchUrl(Uri.parse(
          //       "https://docs.mapbox.com/help/getting-started/attribution/"))) {
          //     // if (kDebugMode) print('Could not launch URL');
          //   }
          // },
          // )
          // ],
          children: [
            TileLayer(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/holigun/clawl8yu4007f15mw79dxcdeb/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}",
              //"https://api.mapbox.com/styles/v1/holigun/clav1jj84007a15o290hw2kbw/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}",
              additionalOptions: const {
                "access_token":
                    "pk.eyJ1IjoiaG9saWd1biIsImEiOiJja3NidXZqaGowYW9wMm9tYzNpYXBrMzEwIn0.purHnG1lh0oYwtM7bpwQFQ",
              },
              userAgentPackageName: 'com.example.app',
            ),
          ],
        ));

    Widget durationSection = Align(
      alignment: Alignment.topCenter,
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
              padding: EdgeInsets.only(bottom: 10),
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
    );

    // Widget distanceAndPaceSection = Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //   children: [
    //     Column(
    //       children: const <Widget>[
    //         Text(
    //           'Distance (km)',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         Text(
    //           '0,00',
    //           style: TextStyle(
    //             //fontWeight: FontWeight.normal,
    //             fontSize: 30,
    //           ),
    //         ),
    //       ],
    //     ),
    //     Column(
    //       children: const <Widget>[
    //         Text(
    //           'Pace (min/km)',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         Text(
    //           '00:00:00',
    //           style: TextStyle(
    //             //fontWeight: FontWeight.normal,
    //             fontSize: 30,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ],
    // );

    // Widget finishAndPauseButtonSection = Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //   children: [
    //     Column(
    //       children: [
    //         Container(
    //             padding: const EdgeInsets.only(top: 20),
    //             child: IconButton(
    //               iconSize: 75,
    //               icon: const Icon(Icons.check_circle_outline_rounded),
    //               onPressed: () {},
    //             ))
    //       ],
    //     ),
    //     Column(
    //       children: [
    //         Container(
    //             padding: const EdgeInsets.only(top: 20),
    //             child: IconButton(
    //               iconSize: 75,
    //               icon: const Icon(Icons.lock_open_outlined),
    //               onPressed: () {},
    //             ))
    //       ],
    //     ),
    //   ],
    // );

    Widget finishAndPauseButtonSection = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
            elevation: 1,
            color: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Ink(
                        decoration: const ShapeDecoration(
                            color: success, shape: CircleBorder()),
                        child: IconButton(
                          iconSize: 50,
                          icon: const Icon(Icons.check_sharp),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Ink(
                        padding: const EdgeInsets.all(10),
                        decoration: const ShapeDecoration(
                            color: primary, shape: CircleBorder()),
                        child: IconButton(
                          iconSize: 50,
                          icon: const Icon(Icons.pause_sharp),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Ink(
                        decoration: const ShapeDecoration(
                            color: primary, shape: CircleBorder()),
                        child: IconButton(
                          iconSize: 50,
                          icon: const Icon(Icons.lock_open_sharp),
                          onPressed: () {},
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
            mapPreview,
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
