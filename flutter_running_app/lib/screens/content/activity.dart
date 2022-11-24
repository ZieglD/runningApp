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
    var appBar = AppBar();
    Widget mapPreview = SizedBox(
        //alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height / 3,
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
                  "https://api.mapbox.com/styles/v1/holigun/clav1jj84007a15o290hw2kbw/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}",
              additionalOptions: const {
                "access_token":
                    "pk.eyJ1IjoiaG9saWd1biIsImEiOiJja3NidXZqaGowYW9wMm9tYzNpYXBrMzEwIn0.purHnG1lh0oYwtM7bpwQFQ",
              },
              userAgentPackageName: 'com.example.app',
            ),
          ],
        ));

    Widget durationSection = Container(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: const <Widget>[
                Text(
                  'Duration',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
        ));

    Widget distanceAndPaceSection = Row(
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
    );

    Widget finishAndPauseButtonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 20),
                child: IconButton(
                  iconSize: 75,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  onPressed: () {},
                ))
          ],
        ),
        Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 20),
                child: IconButton(
                  iconSize: 75,
                  icon: const Icon(Icons.lock_open_outlined),
                  onPressed: () {},
                ))
          ],
        ),
      ],
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

    return Scaffold(
      backgroundColor: primary,
      body: ListView(
        children: [
          mapPreview,
          durationSection,
          distanceAndPaceSection,
          finishAndPauseButtonSection,
          startButtonSection,
          //const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),
        ],
      ),
      //const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),
      //     ElevatedButton(
      //   onPressed: () => setState(() => _showAppBar = !_showAppBar),
      //   child: const Text('Hide Appbar'),
      // ),
    );
  }
}
